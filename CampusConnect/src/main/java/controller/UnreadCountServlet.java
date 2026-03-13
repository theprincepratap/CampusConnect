package controller;

import dao.MessageDAO;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * UnreadCountServlet – GET /unread-count
 * Returns JSON: {"count": N}
 * Called every 5 seconds by the navbar badge script.
 */
public class UnreadCountServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MessageDAO messageDAO;

    @Override
    public void init() throws ServletException {
        messageDAO = new MessageDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-store");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            out.print("{\"count\":0}");
            return;
        }

        User user = (User) session.getAttribute("user");
        int count = messageDAO.getUnreadMessageCount(user.getId());
        out.print("{\"count\":" + count + "}");
    }
}
