package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class UserPhoto implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int userId;
    private String photoUrl;
    private Timestamp uploadedAt;

    public UserPhoto() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getPhotoUrl() { return photoUrl; }
    public void setPhotoUrl(String photoUrl) { this.photoUrl = photoUrl; }

    public Timestamp getUploadedAt() { return uploadedAt; }
    public void setUploadedAt(Timestamp uploadedAt) { this.uploadedAt = uploadedAt; }
}
