package com.studymate.model;

import java.util.Date;
import java.util.List;

public class Post {
    private int postId;
    private int userId;
    private String title;
    private String body;
    private String privacy;
    private String status;
    private Date createdAt;
    private Date updatedAt;
    private List<Attachment> attachments;
    private int likeCount;         
    private List<Comment> comments;
    private int commentCount;
    private User user;
    
    // Thêm các thuộc tính mới cho user info
    private String userAvatar;
    private String userFullName;
    
    // Thêm thuộc tính để kiểm tra like của user hiện tại
    private boolean likedByCurrentUser;
    
    // Thêm thuộc tính cho bài viết gốc khi share
    private int originalPostId;

    // getters & setters

    public int getPostId() { return postId; }
    public void setPostId(int postId) { this.postId = postId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getBody() { return body; }
    public void setBody(String body) { this.body = body; }

    public String getPrivacy() { return privacy; }
    public void setPrivacy(String privacy) { this.privacy = privacy; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public List<Attachment> getAttachments() { return attachments; }
    public void setAttachments(List<Attachment> attachments) { this.attachments = attachments; }

    public int getLikeCount() { return likeCount; }
    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }

    public List<Comment> getComments() { return comments; }
    public void setComments(List<Comment> comments) { this.comments = comments; }

    public int getCommentCount() { return commentCount; }
    public void setCommentCount(int commentCount) { this.commentCount = commentCount; }
    
    
    public String getUserAvatar() {
        return userAvatar;
    }
    
    public void setUserAvatar(String userAvatar) {
        this.userAvatar = userAvatar;
    }
    
    public String getUserFullName() {
        return userFullName;
    }
    
    public void setUserFullName(String userFullName) {
        this.userFullName = userFullName;
    }
    
    public boolean isLikedByCurrentUser() {
        return likedByCurrentUser;
    }
    
    public void setLikedByCurrentUser(boolean likedByCurrentUser) {
        this.likedByCurrentUser = likedByCurrentUser;
    }
    
    public int getOriginalPostId() {
        return originalPostId;
    }
    
    public void setOriginalPostId(int originalPostId) {
        this.originalPostId = originalPostId;
    }
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
}