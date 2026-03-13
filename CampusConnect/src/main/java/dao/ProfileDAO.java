package dao;

import model.UserProfile;

import java.sql.*;

/**
 * ProfileDAO – manages extended user profile data (bio, interests, instagram).
 */
public class ProfileDAO {

    // ----------------------------------------------------------------
    // Get profile by userId (returns empty UserProfile if not found)
    // ----------------------------------------------------------------
    public UserProfile getProfile(int userId) {
        String sql = "SELECT user_id, bio, interests, instagram, updated_at FROM user_profiles WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    UserProfile p = new UserProfile();
                    p.setUserId(rs.getInt("user_id"));
                    p.setBio(rs.getString("bio"));
                    p.setInterests(rs.getString("interests"));
                    p.setInstagram(rs.getString("instagram"));
                    p.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return p;
                }
            }
        } catch (SQLException e) {
            System.err.println("ProfileDAO.getProfile error: " + e.getMessage());
        }
        // Return an empty profile so JSP never gets null
        UserProfile empty = new UserProfile();
        empty.setUserId(userId);
        return empty;
    }

    // ----------------------------------------------------------------
    // Upsert profile (INSERT … ON CONFLICT UPDATE)
    // ----------------------------------------------------------------
    public boolean saveProfile(UserProfile profile) {
        String sql =
            "INSERT INTO user_profiles (user_id, bio, interests, instagram, updated_at) " +
            "VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP) " +
            "ON CONFLICT (user_id) DO UPDATE " +
            "SET bio = EXCLUDED.bio, interests = EXCLUDED.interests, " +
            "    instagram = EXCLUDED.instagram, updated_at = CURRENT_TIMESTAMP";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, profile.getUserId());
            ps.setString(2, profile.getBio());
            ps.setString(3, profile.getInterests());
            ps.setString(4, profile.getInstagram());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ProfileDAO.saveProfile error: " + e.getMessage());
            return false;
        }
    }
}
