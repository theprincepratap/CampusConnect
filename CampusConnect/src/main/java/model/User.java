package model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * User Model Class
 * Represents a user entity in the CampusConnect application
 */
public class User implements Serializable {
    
    private static final long serialVersionUID = 1L;
    
    private int id;
    private String fullName;
    private String email;
    private String password;
    private String college;
    private String pincode;
    private String gender;
    private Timestamp createdAt;
    private String profilePicture;
    
    // Default Constructor
    public User() {
    }
    
    // Parameterized Constructor
    public User(String fullName, String email, String password, String college, String pincode, String gender) {
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.college = college;
        this.pincode = pincode;
        this.gender = gender;
    }
    
    // Full Constructor
    public User(int id, String fullName, String email, String password, String college, String pincode, String gender, Timestamp createdAt) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.college = college;
        this.pincode = pincode;
        this.gender = gender;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getPassword() {
        return password;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public String getCollege() {
        return college;
    }
    
    public void setCollege(String college) {
        this.college = college;
    }
    
    public String getPincode() {
        return pincode;
    }
    
    public void setPincode(String pincode) {
        this.pincode = pincode;
    }
    
    public String getGender() {
        return gender;
    }
    
    public void setGender(String gender) {
        this.gender = gender;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getProfilePicture() {
        return profilePicture;
    }
    
    public void setProfilePicture(String profilePicture) {
        this.profilePicture = profilePicture;
    }
    
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", fullName='" + fullName + '\'' +
                ", email='" + email + '\'' +
                ", college='" + college + '\'' +
                ", pincode='" + pincode + '\'' +
                ", gender='" + gender + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
