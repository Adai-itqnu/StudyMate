package com.studymate.model;

import java.util.Date;

public class Like {
    private int userId;
    private int postId;
    private Date createdAt;

    public Like() {}
    public Like(int userId, int postId, Date createdAt) {
        this.userId = userId;
        this.postId = postId;
        this.createdAt = createdAt;
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getPostId() { return postId; }
    public void setPostId(int postId) { this.postId = postId; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}