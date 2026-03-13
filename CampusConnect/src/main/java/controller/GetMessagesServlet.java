package controller;

import dao.MessageDAO;
import model.Message;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

/**
 * GetMessagesServlet – GET /get-messages?with=userId[&since=epochMs]
 * Returns JSON array of messages between current user and the specified user.
 * Also marks received messages as read.
 */
public class GetMessagesServlet extends HttpServlet {
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
        // Prevent caching
        response.setHeader("Cache-Control", "no-store");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("[]");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String withParam = request.getParameter("with");
        String sinceParam = request.getParameter("since");

        if (withParam == null) {
            out.print("[]");
            return;
        }

        int otherId;
        try {
            otherId = Integer.parseInt(withParam.trim());
        } catch (NumberFormatException e) {
            out.print("[]");
            return;
        }

        List<Message> messages;
        if (sinceParam != null && !sinceParam.trim().isEmpty()) {
            try {
                long since = Long.parseLong(sinceParam.trim());
                messages = messageDAO.getMessagesSince(currentUser.getId(), otherId, since);
            } catch (NumberFormatException e) {
                messages = messageDAO.getMessages(currentUser.getId(), otherId);
            }
        } else {
            messages = messageDAO.getMessages(currentUser.getId(), otherId);
        }

        // Mark messages from the other user as read
        messageDAO.markMessagesAsRead(otherId, currentUser.getId());

        // Build JSON manually (safe, controlled output)
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < messages.size(); i++) {
            Message m = messages.get(i);
            if (i > 0) json.append(",");
            json.append("{");
            json.append("\"id\":").append(m.getId()).append(",");
            json.append("\"senderId\":").append(m.getSenderId()).append(",");
            json.append("\"receiverId\":").append(m.getReceiverId()).append(",");
            json.append("\"message\":\"").append(escapeJson(m.getMessage())).append("\",");
            json.append("\"senderName\":\"").append(escapeJson(m.getSenderName())).append("\",");
            json.append("\"createdAt\":").append(m.getCreatedAt() != null ? m.getCreatedAt().getTime() : 0).append(",");
            json.append("\"createdAtStr\":\"").append(m.getCreatedAt() != null ? formatTime(m.getCreatedAt()) : "").append("\",");
            json.append("\"isRead\":").append(m.isRead());
            json.append("}");
        }
        json.append("]");
        out.print(json.toString());
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t")
                .replace("<", "\\u003c")
                .replace(">", "\\u003e")
                .replace("&", "\\u0026");
    }

    private String formatTime(java.sql.Timestamp ts) {
        java.time.LocalDateTime ldt = ts.toLocalDateTime();
        return String.format("%02d:%02d", ldt.getHour(), ldt.getMinute());
    }
}
