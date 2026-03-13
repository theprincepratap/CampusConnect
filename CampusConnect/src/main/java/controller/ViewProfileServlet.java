package controller;

import dao.PhotoDAO;
import dao.ProfileDAO;
import dao.UserDAO;
import model.User;
import model.UserPhoto;
import model.UserProfile;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * ViewProfileServlet – GET /view-profile?id=userId
 * Displays another user's public profile page.
 */
public class ViewProfileServlet extends HttpServlet {
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("dashboard");
            return;
        }

        int profileUserId;
        try {
            profileUserId = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect("dashboard");
            return;
        }

        // Redirect to own profile page if viewing self
        if (profileUserId == currentUser.getId()) {
            response.sendRedirect("profile");
            return;
        }

        User profileUser = userDAO.getUserById(profileUserId);
        if (profileUser == null) {
            response.sendRedirect("dashboard");
            return;
        }

        UserProfile userProfile = profileDAO.getProfile(profileUserId);
        List<UserPhoto> photos = photoDAO.getPhotos(profileUserId);

        request.setAttribute("currentUser", currentUser);
        request.setAttribute("profileUser", profileUser);
        request.setAttribute("userProfile", userProfile);
        request.setAttribute("photos", photos);

        request.getRequestDispatcher("view-profile.jsp").forward(request, response);
    }
}
