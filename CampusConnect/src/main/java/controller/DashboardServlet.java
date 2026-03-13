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
 * Dashboard Servlet Controller
 * Handles dashboard view and user filtering
 */
public class DashboardServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }
    
    /**
     * Display dashboard page
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
        
        // Get current user
        User currentUser = (User) session.getAttribute("user");

        // Get filter parameters
        String pincodeFilter = request.getParameter("pincode");
        String genderFilter  = request.getParameter("gender");
        String nameFilter    = request.getParameter("name");

        // Normalise empty strings to null
        if (pincodeFilter != null) pincodeFilter = pincodeFilter.trim().isEmpty() ? null : pincodeFilter.trim();
        if (genderFilter  != null) genderFilter  = genderFilter.trim().isEmpty()  ? null : genderFilter.trim();
        if (nameFilter    != null) nameFilter     = nameFilter.trim().isEmpty()    ? null : nameFilter.trim();

        // Fetch filtered users
        List<User> collegeUsers = userDAO.getUsersByFilter(
            currentUser.getCollege(), currentUser.getId(),
            pincodeFilter, genderFilter, nameFilter
        );

        // Pass filter values back to JSP so the form stays filled
        request.setAttribute("selectedPincode", pincodeFilter != null ? pincodeFilter : "");
        request.setAttribute("selectedGender",  genderFilter  != null ? genderFilter  : "");
        request.setAttribute("selectedName",     nameFilter    != null ? nameFilter    : "");

        // Set attributes for JSP
        request.setAttribute("currentUser", currentUser);
        request.setAttribute("collegeUsers", collegeUsers);
        request.setAttribute("userCount", collegeUsers.size());

        // Forward to dashboard
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }

    /**
     * Handle POST requests (for filtering)
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pincode = request.getParameter("pincode");
        String gender  = request.getParameter("gender");
        String name    = request.getParameter("name");
        StringBuilder redirect = new StringBuilder("dashboard?");
        if (pincode != null && !pincode.trim().isEmpty()) redirect.append("pincode=").append(pincode.trim()).append("&");
        if (gender  != null && !gender.trim().isEmpty())  redirect.append("gender=").append(gender.trim()).append("&");
        if (name    != null && !name.trim().isEmpty())    redirect.append("name=").append(name.trim()).append("&");
        String url = redirect.toString();
        if (url.endsWith("&") || url.endsWith("?")) url = url.substring(0, url.length() - 1);
        response.sendRedirect(url);
    }
}
