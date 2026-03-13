package controller;

import javax.servlet.ServletException;
// WebServlet annotation removed - using web.xml mapping instead
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Logout Servlet Controller
 * Handles user logout and session invalidation
 */
public class LogoutServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    /**
     * Process logout request
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        performLogout(request, response);
    }
    
    /**
     * Process logout request (POST)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        performLogout(request, response);
    }
    
    /**
     * Perform logout operation
     */
    private void performLogout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // Get existing session
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Remove all session attributes
            session.removeAttribute("user");
            session.removeAttribute("userId");
            session.removeAttribute("userName");
            session.removeAttribute("userEmail");
            session.removeAttribute("userCollege");
            
            // Invalidate session
            session.invalidate();
        }
        
        // Set logout message in new session
        HttpSession newSession = request.getSession();
        newSession.setAttribute("successMessage", "You have been logged out successfully.");
        
        // Redirect to login page
        response.sendRedirect("login");
    }
}
