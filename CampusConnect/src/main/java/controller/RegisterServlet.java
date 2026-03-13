package controller;

import dao.UserDAO;
import model.User;

import javax.servlet.ServletException;
// WebServlet annotation removed - using web.xml mapping instead
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * Register Servlet Controller
 * Handles user registration
 */

public class RegisterServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    /**
     * Display registration page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect("dashboard");
            return;
        }
        
        // Get list of colleges for dropdown
        List<String> colleges = userDAO.getAllColleges();
        request.setAttribute("colleges", colleges);
        
        // Forward to registration page
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }
    
    /**
     * Process registration form submission
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get form parameters
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        // Support both firstName+lastName and legacy fullName field
        String fullName = request.getParameter("fullName");
        if ((fullName == null || fullName.trim().isEmpty()) && firstName != null) {
            fullName = (firstName.trim() + " " + (lastName != null ? lastName.trim() : "")).trim();
        }
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String college = request.getParameter("college");
        String pincode = request.getParameter("pincode");
        String gender = request.getParameter("gender");
        
        // Store form data for repopulation
        request.setAttribute("firstName", firstName);
        request.setAttribute("lastName", lastName);
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("college", college);
        request.setAttribute("pincode", pincode);
        request.setAttribute("gender", gender);
        
        // Get colleges for dropdown
        List<String> colleges = userDAO.getAllColleges();
        request.setAttribute("colleges", colleges);
        
        // Validate required fields
        if (isNullOrEmpty(fullName) || isNullOrEmpty(email) || 
            isNullOrEmpty(password) || isNullOrEmpty(confirmPassword) ||
            isNullOrEmpty(college) || isNullOrEmpty(pincode)) {
            request.setAttribute("error", "Please fill in all required fields");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Trim inputs
        fullName = fullName.trim();
        email = email.trim().toLowerCase();
        password = password.trim();
        confirmPassword = confirmPassword.trim();
        college = college.trim();
        pincode = pincode.trim();
        gender = gender != null ? gender.trim() : "";
        
        // Validate full name (2-100 characters)
        if (fullName.length() < 2 || fullName.length() > 100) {
            request.setAttribute("error", "Full name must be between 2 and 100 characters");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Validate email format
        if (!isValidEmail(email)) {
            request.setAttribute("error", "Please enter a valid email address");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Check if email already exists
        if (userDAO.isEmailExists(email)) {
            request.setAttribute("error", "Email address is already registered");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Validate password length (minimum 8 characters)
        if (password.length() < 8) {
            request.setAttribute("error", "Password must be at least 8 characters long");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Validate password strength
        if (!isStrongPassword(password)) {
            request.setAttribute("error", "Password must contain at least one uppercase letter, one lowercase letter, and one number");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Validate password match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Validate college name
        if (college.length() < 2 || college.length() > 150) {
            request.setAttribute("error", "College name must be between 2 and 150 characters");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Validate pincode (6 digits)
        if (!pincode.matches("^[0-9]{6}$")) {
            request.setAttribute("error", "Please enter a valid 6-digit pincode");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
        
        // Create user object
        User user = new User(fullName, email, password, college, pincode, gender);
        
        // Attempt registration
        boolean success = userDAO.registerUser(user);
        
        if (success) {
            // Registration successful - redirect to login with success message
            request.getSession().setAttribute("successMessage", "Registration successful! Please login.");
            response.sendRedirect("login");
        } else {
            // Registration failed
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
    
    /**
     * Check if string is null or empty
     */
    private boolean isNullOrEmpty(String str) {
        return str == null || str.trim().isEmpty();
    }
    
    /**
     * Validate email format
     */
    private boolean isValidEmail(String email) {
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
        return email.matches(emailRegex);
    }
    
    /**
     * Validate password strength
     */
    private boolean isStrongPassword(String password) {
        // At least one uppercase, one lowercase, one digit
        return password.matches(".*[A-Z].*") && 
               password.matches(".*[a-z].*") && 
               password.matches(".*[0-9].*");
    }
}
