package dao;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.User;



/**
 * User Data Access Object
 * Handles all database operations related to users
 */
public class UserDAO {
    
    // SQL Queries
    private static final String INSERT_USER = 
        "INSERT INTO users (full_name, email, password, college, pincode, gender) VALUES (?, ?, ?, ?, ?, ?)";
    
    private static final String SELECT_USER_BY_EMAIL_PASSWORD = 
        "SELECT id, full_name, email, password, college, pincode, gender, created_at, profile_picture FROM users WHERE email = ? AND password = ?";
    
    private static final String SELECT_USER_BY_EMAIL = 
        "SELECT id, full_name, email, password, college, pincode, gender, created_at, profile_picture FROM users WHERE email = ?";
    
    private static final String SELECT_USERS_BY_COLLEGE = 
        "SELECT id, full_name, email, password, college, pincode, gender, created_at, profile_picture FROM users WHERE college = ? AND id != ?";
    
    private static final String SELECT_USERS_BY_COLLEGE_AND_PINCODE = 
        "SELECT id, full_name, email, password, college, pincode, gender, created_at, profile_picture FROM users WHERE college = ? AND pincode = ? AND id != ?";
    
    private static final String SELECT_USER_BY_ID = 
        "SELECT id, full_name, email, password, college, pincode, gender, created_at, profile_picture FROM users WHERE id = ?";
    
    private static final String UPDATE_USER = 
        "UPDATE users SET full_name = ?, college = ?, pincode = ?, gender = ? WHERE id = ?";
    
    private static final String UPDATE_PROFILE_PICTURE =
        "UPDATE users SET profile_picture = ? WHERE id = ?";
    
    private static final String CHECK_EMAIL_EXISTS = 
        "SELECT COUNT(*) FROM users WHERE email = ?";
    
    private static final String SELECT_ALL_COLLEGES = 
        "SELECT DISTINCT college FROM users ORDER BY college";
    
    /**
     * Hash password using SHA-256
     * @param password Plain text password
     * @return SHA-256 hashed password
     */
    public static String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) {
                    hexString.append('0');
                }
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not found", e);
        }
    }
    
    /**
     * Register a new user
     * @param user User object to register
     * @return true if registration successful, false otherwise
     */
    public boolean registerUser(User user) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(INSERT_USER)) {
            
            // Hash the password before storing
            String hashedPassword = hashPassword(user.getPassword());
            
            pstmt.setString(1, user.getFullName());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, hashedPassword);
            pstmt.setString(4, user.getCollege());
            pstmt.setString(5, user.getPincode());
            pstmt.setString(6, user.getGender());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error registering user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Authenticate user login
     * @param email User email
     * @param password User password (plain text)
     * @return User object if authenticated, null otherwise
     */
    public User loginUser(String email, String password) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SELECT_USER_BY_EMAIL_PASSWORD)) {
            
            // Hash the password for comparison
            String hashedPassword = hashPassword(password);
            
            pstmt.setString(1, email);
            pstmt.setString(2, hashedPassword);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error during login: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Check if email already exists
     * @param email Email to check
     * @return true if email exists, false otherwise
     */
    public boolean isEmailExists(String email) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(CHECK_EMAIL_EXISTS)) {
            
            pstmt.setString(1, email);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error checking email existence: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Get user by email
     * @param email User email
     * @return User object if found, null otherwise
     */
    public User getUserByEmail(String email) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SELECT_USER_BY_EMAIL)) {
            
            pstmt.setString(1, email);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting user by email: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Get user by ID
     * @param id User ID
     * @return User object if found, null otherwise
     */
    public User getUserById(int id) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SELECT_USER_BY_ID)) {
            
            pstmt.setInt(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting user by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Get all users from same college (excluding current user)
     * @param college College name
     * @param currentUserId Current user's ID to exclude
     * @return List of users from same college
     */
    public List<User> getUsersByCollege(String college, int currentUserId) {
        List<User> users = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SELECT_USERS_BY_COLLEGE)) {
            
            pstmt.setString(1, college);
            pstmt.setInt(2, currentUserId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting users by college: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }
    
    /**
     * Get users from same college filtered by pincode
     * @param college College name
     * @param pincode Pincode to filter
     * @param currentUserId Current user's ID to exclude
     * @return List of filtered users
     */
    public List<User> getUsersByCollegeAndPincode(String college, String pincode, int currentUserId) {
        List<User> users = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SELECT_USERS_BY_COLLEGE_AND_PINCODE)) {
            
            pstmt.setString(1, college);
            pstmt.setString(2, pincode);
            pstmt.setInt(3, currentUserId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting users by college and pincode: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }
    
    /**
     * Get users from same college with optional filters: pincode, gender, name search
     */
    public List<User> getUsersByFilter(String college, int currentUserId,
                                       String pincode, String gender, String nameSearch) {
        List<User> users = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT id, full_name, email, password, college, pincode, gender, created_at, profile_picture " +
            "FROM users WHERE college = ? AND id != ?");

        if (pincode != null && !pincode.isEmpty()) {
            sql.append(" AND pincode = ?");
        }
        if (gender != null && !gender.isEmpty()) {
            sql.append(" AND LOWER(gender) = LOWER(?)");
        }
        if (nameSearch != null && !nameSearch.isEmpty()) {
            sql.append(" AND LOWER(full_name) LIKE LOWER(?)");
        }
        sql.append(" ORDER BY full_name ASC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            pstmt.setString(idx++, college);
            pstmt.setInt(idx++, currentUserId);
            if (pincode != null && !pincode.isEmpty()) {
                pstmt.setString(idx++, pincode);
            }
            if (gender != null && !gender.isEmpty()) {
                pstmt.setString(idx++, gender);
            }
            if (nameSearch != null && !nameSearch.isEmpty()) {
                pstmt.setString(idx++, "%" + nameSearch + "%");
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }

        } catch (SQLException e) {
            System.err.println("Error filtering users: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    /**
     * Update user profile
     * @param user User object with updated information
     * @return true if update successful, false otherwise
     */
    public boolean updateUser(User user) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(UPDATE_USER)) {
            
            pstmt.setString(1, user.getFullName());
            pstmt.setString(2, user.getCollege());
            pstmt.setString(3, user.getPincode());
            pstmt.setString(4, user.getGender());
            pstmt.setInt(5, user.getId());
            
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update profile picture filename for a user
     */
    public boolean updateProfilePicture(int userId, String filename) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(UPDATE_PROFILE_PICTURE)) {
            pstmt.setString(1, filename);
            pstmt.setInt(2, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating profile picture: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Get all distinct colleges
     * @return List of college names
     */
    public List<String> getAllColleges() {
        List<String> colleges = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SELECT_ALL_COLLEGES);
             ResultSet rs = pstmt.executeQuery()) {
            
            while (rs.next()) {
                colleges.add(rs.getString("college"));
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting colleges: " + e.getMessage());
            e.printStackTrace();
        }
        return colleges;
    }
    
    /**
     * Map ResultSet to User object
     * @param rs ResultSet containing user data
     * @return User object
     * @throws SQLException if mapping fails
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setCollege(rs.getString("college"));
        user.setPincode(rs.getString("pincode"));
        user.setGender(rs.getString("gender"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setProfilePicture(rs.getString("profile_picture"));
        return user;
    }
}
