package model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Represents a conversation summary (latest message + unread count) for the chat list panel.
 */
public class Conversation implements Serializable {
    private static final long serialVersionUID = 1L;

    private int otherUserId;
    private String otherUserName;
    private String otherUserProfilePic;
    private String lastMessage;
    private Timestamp lastMessageTime;
    private int unreadCount;

    public Conversation() {}

    public int getOtherUserId() { return otherUserId; }
    public void setOtherUserId(int otherUserId) { this.otherUserId = otherUserId; }

    public String getOtherUserName() { return otherUserName; }
    public void setOtherUserName(String otherUserName) { this.otherUserName = otherUserName; }

    public String getOtherUserProfilePic() { return otherUserProfilePic; }
    public void setOtherUserProfilePic(String otherUserProfilePic) { this.otherUserProfilePic = otherUserProfilePic; }

    public String getLastMessage() { return lastMessage; }
    public void setLastMessage(String lastMessage) { this.lastMessage = lastMessage; }

    public Timestamp getLastMessageTime() { return lastMessageTime; }
    public void setLastMessageTime(Timestamp lastMessageTime) { this.lastMessageTime = lastMessageTime; }

    public int getUnreadCount() { return unreadCount; }
    public void setUnreadCount(int unreadCount) { this.unreadCount = unreadCount; }
}
