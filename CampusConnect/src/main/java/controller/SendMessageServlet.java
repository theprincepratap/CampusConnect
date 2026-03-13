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
 * SendMessageServlet – POST /send-message
 * Accepts JSON or form params: receiverId, message
 * Returns JSON: {"success": true} or {"success": false, "error": "..."}
 */
public class SendMessageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MessageDAO messageDAO;

    @Override
    public void init() throws ServletException {
        messageDAO = new MessageDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"success\":false,\"error\":\"Not authenticated\"}");
            return;
        }

        User sender = (User) session.getAttribute("user");

        String receiverIdParam = request.getParameter("receiverId");
        String message = request.getParameter("message");

        if (receiverIdParam == null || message == null || message.trim().isEmpty()) {
            out.print("{\"success\":false,\"error\":\"Missing parameters\"}");
            return;
        }

        // Prevent message injection – use trim and length cap
        message = message.trim();
        if (message.length() > 2000) {
            message = message.substring(0, 2000);
        }

        int receiverId;
        try {
            receiverId = Integer.parseInt(receiverIdParam.trim());
        } catch (NumberFormatException e) {
            out.print("{\"success\":false,\"error\":\"Invalid receiver\"}");
            return;
        }

        // Prevent sending message to yourself
        if (receiverId == sender.getId()) {
            out.print("{\"success\":false,\"error\":\"Cannot message yourself\"}");
            return;
        }

        boolean ok = messageDAO.sendMessage(sender.getId(), receiverId, message);
        if (ok) {
            out.print("{\"success\":true}");
        } else {
            out.print("{\"success\":false,\"error\":\"Failed to send\"}");
        }
    }
}
