package controller;

import dao.PhotoDAO;
import dao.ProfileDAO;
import dao.UserDAO;
import model.User;
import model.UserPhoto;
import model.UserProfile;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.UUID;

/**
 * Profile Servlet Controller
 * Handles user profile view, edit, and profile picture upload
 */
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, maxRequestSize = 5 * 1024 * 1024)
public class ProfileServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private ProfileDAO profileDAO;
    private PhotoDAO photoDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        profileDAO = new ProfileDAO();
        photoDAO = new PhotoDAO();
    }
    
    /**
     * Display profile page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Get current user (refresh from database)
        User sessionUser = (User) session.getAttribute("user");
        User currentUser = userDAO.getUserById(sessionUser.getId());
        
        if (currentUser == null) {
            // User not found, invalidate session
            session.invalidate();
            response.sendRedirect("login");
            return;
        }
        
        // Update session with fresh data
        session.setAttribute("user", currentUser);
        request.setAttribute("currentUser", currentUser);

        // Load extended profile and photos
        UserProfile userProfile = profileDAO.getProfile(currentUser.getId());
        List<UserPhoto> photos = photoDAO.getPhotos(currentUser.getId());
        request.setAttribute("userProfile", userProfile);
        request.setAttribute("photos", photos);
        
        // Forward to profile page
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
    
    /**
     * Process profile update, picture upload, or sample picture selection
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        
        User currentUser = (User) session.getAttribute("user");
        String action = request.getParameter("action");
        
        // --- Handle profile picture upload ---
        if ("uploadPicture".equals(action)) {
            Part filePart = request.getPart("profilePicture");
            if (filePart != null && filePart.getSize() > 0) {
                String contentType = filePart.getContentType();
                if (contentType == null || !contentType.startsWith("image/")) {
                    request.setAttribute("picError", "Only image files are allowed.");
                } else {
                    String ext = contentType.substring(contentType.lastIndexOf('/') + 1);
                    if ("jpeg".equals(ext)) ext = "jpg";
                    String filename = "user_" + currentUser.getId() + "_" + UUID.randomUUID().toString().substring(0, 8) + "." + ext;
                    String uploadDir = getServletContext().getRealPath("/uploads");
                    new File(uploadDir).mkdirs();
                    try (InputStream in = filePart.getInputStream()) {
                        Files.copy(in, Paths.get(uploadDir, filename), StandardCopyOption.REPLACE_EXISTING);
                    }
                    userDAO.updateProfilePicture(currentUser.getId(), "uploads/" + filename);
                    currentUser.setProfilePicture("uploads/" + filename);
                    session.setAttribute("user", currentUser);
                    request.setAttribute("success", "Profile picture updated successfully!");
                }
            } else {
                request.setAttribute("picError", "Please select an image file.");
            }
            User refreshed = userDAO.getUserById(currentUser.getId());
            session.setAttribute("user", refreshed);
            request.setAttribute("currentUser", refreshed);
            request.setAttribute("userProfile", profileDAO.getProfile(refreshed.getId()));
            request.setAttribute("photos", photoDAO.getPhotos(refreshed.getId()));
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }
        
        // --- Handle sample picture selection ---
        if ("selectSample".equals(action)) {
            String sample = request.getParameter("sample");
            String[] allowed = {"images/samples/avatar1.svg", "images/samples/avatar2.svg", "images/samples/avatar3.svg"};
            boolean valid = false;
            for (String a : allowed) { if (a.equals(sample)) { valid = true; break; } }
            if (valid) {
                userDAO.updateProfilePicture(currentUser.getId(), sample);
                currentUser.setProfilePicture(sample);
                session.setAttribute("user", currentUser);
                request.setAttribute("success", "Profile picture updated!");
            } else {
                request.setAttribute("picError", "Invalid selection.");
            }
            User refreshed = userDAO.getUserById(currentUser.getId());
            session.setAttribute("user", refreshed);
            request.setAttribute("currentUser", refreshed);
            request.setAttribute("userProfile", profileDAO.getProfile(refreshed.getId()));
            request.setAttribute("photos", photoDAO.getPhotos(refreshed.getId()));
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }

        // --- Handle extended profile update (bio, interests, instagram) ---
        if ("updateExtProfile".equals(action)) {
            String bio = request.getParameter("bio");
            String interests = request.getParameter("interests");
            String instagram = request.getParameter("instagram");
            UserProfile profile = new UserProfile();
            profile.setUserId(currentUser.getId());
            profile.setBio(bio != null ? bio.trim() : "");
            profile.setInterests(interests != null ? interests.trim() : "");
            profile.setInstagram(instagram != null ? instagram.trim() : "");
            profileDAO.saveProfile(profile);
            User refreshed = userDAO.getUserById(currentUser.getId());
            session.setAttribute("user", refreshed);
            request.setAttribute("currentUser", refreshed);
            request.setAttribute("userProfile", profileDAO.getProfile(refreshed.getId()));
            request.setAttribute("photos", photoDAO.getPhotos(refreshed.getId()));
            request.setAttribute("success", "Profile details updated!");
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }
        
        // --- Handle profile info update (original logic) ---
        String fullName = request.getParameter("fullName");
        String college = request.getParameter("college");
        String pincode = request.getParameter("pincode");
        String gender = request.getParameter("gender");
        
        // Store for repopulation
        request.setAttribute("fullName", fullName);
        request.setAttribute("college", college);
        request.setAttribute("pincode", pincode);
        request.setAttribute("gender", gender);
        
        // Validate inputs
        if (isNullOrEmpty(fullName) || isNullOrEmpty(college) || isNullOrEmpty(pincode)) {
            request.setAttribute("error", "Please fill in all required fields");
            request.setAttribute("currentUser", currentUser);
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }
        
        // Trim inputs
        fullName = fullName.trim();
        college = college.trim();
        pincode = pincode.trim();
        gender = gender != null ? gender.trim() : "";
        
        // Validate full name
        if (fullName.length() < 2 || fullName.length() > 100) {
            request.setAttribute("error", "Full name must be between 2 and 100 characters");
            request.setAttribute("currentUser", currentUser);
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }
        
        // Validate college
        if (college.length() < 2 || college.length() > 150) {
            request.setAttribute("error", "College name must be between 2 and 150 characters");
            request.setAttribute("currentUser", currentUser);
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }
        
        // Validate pincode
        if (!pincode.matches("^[0-9]{6}$")) {
            request.setAttribute("error", "Please enter a valid 6-digit pincode");
            request.setAttribute("currentUser", currentUser);
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }
        
        // Update user object
        currentUser.setFullName(fullName);
        currentUser.setCollege(college);
        currentUser.setPincode(pincode);
        currentUser.setGender(gender);
        
        // Attempt update
        boolean success = userDAO.updateUser(currentUser);
        
        if (success) {
            // Update session
            session.setAttribute("user", currentUser);
            session.setAttribute("userName", currentUser.getFullName());
            session.setAttribute("userCollege", currentUser.getCollege());
            
            request.setAttribute("success", "Profile updated successfully!");
            request.setAttribute("currentUser", currentUser);
        } else {
            request.setAttribute("error", "Failed to update profile. Please try again.");
            request.setAttribute("currentUser", currentUser);
        }

        request.setAttribute("userProfile", profileDAO.getProfile(currentUser.getId()));
        request.setAttribute("photos", photoDAO.getPhotos(currentUser.getId()));
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
    
    /**
     * Check if string is null or empty
     */
    private boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
}
