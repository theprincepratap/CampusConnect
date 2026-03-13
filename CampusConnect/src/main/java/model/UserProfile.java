package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class UserProfile implements Serializable {
    private static final long serialVersionUID = 1L;

    private int userId;
    private String bio;
    private String interests;
    private String instagram;
    private Timestamp updatedAt;

    public UserProfile() {}

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public String getInterests() { return interests; }
    public void setInterests(String interests) { this.interests = interests; }

    public String getInstagram() { return instagram; }
    public void setInstagram(String instagram) { this.instagram = instagram; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
