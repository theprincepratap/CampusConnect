package controller;

import dao.MessageDAO;
import dao.UserDAO;
import model.Conversation;
import model.Message;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

/**
 * ConversationsServlet – GET /chat[?with=userId]
 * Displays the full messenger page.
 * - If ?with=userId is supplied, the right panel opens that conversation.
 * - Marks received messages from the active conversation as read.
 */
public class ConversationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MessageDAO messageDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        messageDAO = new MessageDAO();
        userDAO = new UserDAO();
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

        // Conversation list (left panel)
        List<Conversation> conversations = messageDAO.getConversations(currentUser.getId());
        request.setAttribute("conversations", conversations);
        request.setAttribute("currentUser", currentUser);

        // Active conversation (right panel)
        String withParam = request.getParameter("with");
        if (withParam != null && !withParam.trim().isEmpty()) {
            try {
                int otherId = Integer.parseInt(withParam.trim());
                User otherUser = userDAO.getUserById(otherId);
                if (otherUser != null) {
                    List<Message> messages = messageDAO.getMessages(currentUser.getId(), otherId);
                    // Mark received messages as read
                    messageDAO.markMessagesAsRead(otherId, currentUser.getId());
                    request.setAttribute("activeUser", otherUser);
                    request.setAttribute("messages", messages);
                    request.setAttribute("activeUserId", otherId);
                }
            } catch (NumberFormatException ignored) {}
        }

        request.getRequestDispatcher("chat.jsp").forward(request, response);
    }
}
