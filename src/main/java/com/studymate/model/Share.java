package com.studymate.model;

import java.util.Date;

public class Share {
    private int shareId;
    private int userId;
    private int postId;
    private Date createdAt;

    public Share() {}
    public Share(int shareId, int userId, int postId, Date createdAt) {
        this.shareId = shareId;
        this.userId = userId;
        this.postId = postId;
        this.createdAt = createdAt;
    }

    public int getShareId() { return shareId; }
    public void setShareId(int shareId) { this.shareId = shareId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getPostId() { return postId; }
    public void setPostId(int postId) { this.postId = postId; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}