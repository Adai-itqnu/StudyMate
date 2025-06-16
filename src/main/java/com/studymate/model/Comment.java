package com.studymate.model;

import java.util.Date;

public class Comment {
    private int commentId;
    private int userId;
    private int postId;
    private String content;
    private Date createdAt;
    private int likeCount; // Thêm để lưu số lượt thích

    public Comment() {}
    public Comment(int commentId, int userId, int postId, String content, Date createdAt) {
        this.commentId = commentId;
        this.userId = userId;
        this.postId = postId;
        this.content = content;
        this.createdAt = createdAt;
    }

    public int getCommentId() { return commentId; }
    public void setCommentId(int commentId) { this.commentId = commentId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getPostId() { return postId; }
    public void setPostId(int postId) { this.postId = postId; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}