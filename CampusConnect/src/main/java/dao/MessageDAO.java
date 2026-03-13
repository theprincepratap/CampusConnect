package dao;

import model.Conversation;
import model.Message;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * MessageDAO – all database operations for the chat/messaging system.
 */
public class MessageDAO {

    // ----------------------------------------------------------------
    // Send a message
    // ----------------------------------------------------------------
    public boolean sendMessage(int senderId, int receiverId, String message) {
        String sql = "INSERT INTO messages (sender_id, receiver_id, message) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, senderId);
            ps.setInt(2, receiverId);
            ps.setString(3, message);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("MessageDAO.sendMessage error: " + e.getMessage());
            return false;
        }
    }

    // ----------------------------------------------------------------
    // Get all messages between two users (chronological order)
    // ----------------------------------------------------------------
    public List<Message> getMessages(int userId, int otherUserId) {
        List<Message> list = new ArrayList<>();
        String sql =
            "SELECT m.id, m.sender_id, m.receiver_id, m.message, m.created_at, m.is_read, " +
            "       u.full_name AS sender_name " +
            "FROM messages m " +
            "JOIN users u ON u.id = m.sender_id " +
            "WHERE (m.sender_id = ? AND m.receiver_id = ?) " +
            "   OR (m.sender_id = ? AND m.receiver_id = ?) " +
            "ORDER BY m.created_at ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, otherUserId);
            ps.setInt(3, otherUserId);
            ps.setInt(4, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapMessage(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("MessageDAO.getMessages error: " + e.getMessage());
        }
        return list;
    }

    // ----------------------------------------------------------------
    // Get messages newer than a given timestamp (for AJAX polling)
    // ----------------------------------------------------------------
    public List<Message> getMessagesSince(int userId, int otherUserId, long sinceMs) {
        List<Message> list = new ArrayList<>();
        String sql =
            "SELECT m.id, m.sender_id, m.receiver_id, m.message, m.created_at, m.is_read, " +
            "       u.full_name AS sender_name " +
            "FROM messages m " +
            "JOIN users u ON u.id = m.sender_id " +
            "WHERE ((m.sender_id = ? AND m.receiver_id = ?) " +
            "    OR (m.sender_id = ? AND m.receiver_id = ?)) " +
            "  AND m.created_at > ? " +
            "ORDER BY m.created_at ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, otherUserId);
            ps.setInt(3, otherUserId);
            ps.setInt(4, userId);
            ps.setTimestamp(5, new Timestamp(sinceMs));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapMessage(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("MessageDAO.getMessagesSince error: " + e.getMessage());
        }
        return list;
    }

    // ----------------------------------------------------------------
    // Get conversation list for a user (most recent first)
    // ----------------------------------------------------------------
    public List<Conversation> getConversations(int userId) {
        List<Conversation> list = new ArrayList<>();
        // Use a CTE to find distinct conversation partners, then get latest message
        String sql =
            "SELECT DISTINCT ON (partner_id) " +
            "       partner_id, u.full_name AS partner_name, u.profile_picture AS partner_pic, " +
            "       m.message AS last_message, m.created_at AS last_time, " +
            "       (SELECT COUNT(*) FROM messages uc " +
            "        WHERE uc.sender_id = partner_id AND uc.receiver_id = ? AND uc.is_read = FALSE) AS unread " +
            "FROM ( " +
            "    SELECT CASE WHEN sender_id = ? THEN receiver_id ELSE sender_id END AS partner_id, id " +
            "    FROM messages WHERE sender_id = ? OR receiver_id = ? " +
            ") pairs " +
            "JOIN messages m ON m.id = pairs.id " +
            "JOIN users u ON u.id = pairs.partner_id " +
            "ORDER BY partner_id, m.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);
            ps.setInt(4, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Conversation c = new Conversation();
                    c.setOtherUserId(rs.getInt("partner_id"));
                    c.setOtherUserName(rs.getString("partner_name"));
                    c.setOtherUserProfilePic(rs.getString("partner_pic"));
                    c.setLastMessage(rs.getString("last_message"));
                    c.setLastMessageTime(rs.getTimestamp("last_time"));
                    c.setUnreadCount(rs.getInt("unread"));
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            System.err.println("MessageDAO.getConversations error: " + e.getMessage());
        }
        // Sort by lastMessageTime DESC in Java to avoid complex SQL ordering with DISTINCT ON
        list.sort((a, b) -> {
            if (b.getLastMessageTime() == null) return -1;
            if (a.getLastMessageTime() == null) return 1;
            return b.getLastMessageTime().compareTo(a.getLastMessageTime());
        });
        return list;
    }

    // ----------------------------------------------------------------
    // Total unread messages count for a user
    // ----------------------------------------------------------------
    public int getUnreadMessageCount(int userId) {
        String sql = "SELECT COUNT(*) FROM messages WHERE receiver_id = ? AND is_read = FALSE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("MessageDAO.getUnreadMessageCount error: " + e.getMessage());
        }
        return 0;
    }

    // ----------------------------------------------------------------
    // Mark all messages from sender → receiver as read
    // ----------------------------------------------------------------
    public void markMessagesAsRead(int senderId, int receiverId) {
        String sql = "UPDATE messages SET is_read = TRUE WHERE sender_id = ? AND receiver_id = ? AND is_read = FALSE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, senderId);
            ps.setInt(2, receiverId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("MessageDAO.markMessagesAsRead error: " + e.getMessage());
        }
    }

    // ----------------------------------------------------------------
    // Helper
    // ----------------------------------------------------------------
    private Message mapMessage(ResultSet rs) throws SQLException {
        Message m = new Message();
        m.setId(rs.getInt("id"));
        m.setSenderId(rs.getInt("sender_id"));
        m.setReceiverId(rs.getInt("receiver_id"));
        m.setMessage(rs.getString("message"));
        m.setCreatedAt(rs.getTimestamp("created_at"));
        m.setRead(rs.getBoolean("is_read"));
        m.setSenderName(rs.getString("sender_name"));
        return m;
    }
}
