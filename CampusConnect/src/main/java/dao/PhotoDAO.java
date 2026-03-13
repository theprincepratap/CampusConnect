package dao;

import model.UserPhoto;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * PhotoDAO – manages user photo gallery.
 */
public class PhotoDAO {

    // ----------------------------------------------------------------
    // Add a photo for a user
    // ----------------------------------------------------------------
    public boolean addPhoto(int userId, String photoUrl) {
        String sql = "INSERT INTO user_photos (user_id, photo_url) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, photoUrl);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("PhotoDAO.addPhoto error: " + e.getMessage());
            return false;
        }
    }

    // ----------------------------------------------------------------
    // Get all photos for a user (newest first)
    // ----------------------------------------------------------------
    public List<UserPhoto> getPhotos(int userId) {
        List<UserPhoto> list = new ArrayList<>();
        String sql = "SELECT id, user_id, photo_url, uploaded_at FROM user_photos WHERE user_id = ? ORDER BY uploaded_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UserPhoto p = new UserPhoto();
                    p.setId(rs.getInt("id"));
                    p.setUserId(rs.getInt("user_id"));
                    p.setPhotoUrl(rs.getString("photo_url"));
                    p.setUploadedAt(rs.getTimestamp("uploaded_at"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            System.err.println("PhotoDAO.getPhotos error: " + e.getMessage());
        }
        return list;
    }

    // ----------------------------------------------------------------
    // Delete a photo (only if it belongs to the requesting user)
    // ----------------------------------------------------------------
    public boolean deletePhoto(int photoId, int userId) {
        String sql = "DELETE FROM user_photos WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, photoId);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("PhotoDAO.deletePhoto error: " + e.getMessage());
            return false;
        }
    }
}
