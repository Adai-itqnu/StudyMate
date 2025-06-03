package com.studymate.model;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;

public class Post {
    private int id;
    private int subjectId;
    private String title;
    private String content;
    private String filePath;
    private String fileType;
    private int viewCount;
    private Timestamp createdAt;
    private int likeCount;
    private int commentCount;
    private boolean likedByCurrentUser; 
    
    private User user; // Thông tin người đăng
    private List<Comment> comments; // Danh sách bình luận
    
    // Constructors
    public Post() {}
    
    public Post(String title, String content, User user) {
        this.title = title;
        this.content = content;
        this.user = user;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getSubjectId() { return subjectId; }
    public void setSubjectId(int subjectId) { this.subjectId = subjectId; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    
    public String getFilePath() { return filePath; }
    public void setFilePath(String filePath) { this.filePath = filePath; }
    
    public String getFileType() { return fileType; }
    public void setFileType(String fileType) { this.fileType = fileType; }
    
    public int getViewCount() { return viewCount; }
    public void setViewCount(int viewCount) { this.viewCount = viewCount; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public int getLikeCount() { return likeCount; }
    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }
    
    public int getCommentCount() { return commentCount; }
    public void setCommentCount(int commentCount) { this.commentCount = commentCount; }
    
    public boolean isLikedByCurrentUser() { return likedByCurrentUser; }
    public void setLikedByCurrentUser(boolean likedByCurrentUser) { 
        this.likedByCurrentUser = likedByCurrentUser; 
    }
    
    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
    
    public List<Comment> getComments() { return comments; }
    public void setComments(List<Comment> comments) { this.comments = comments; }
    
    /**
     * Lấy thời gian đăng dưới dạng chuỗi định dạng
     * @return Chuỗi thời gian đã format
     */
    public String getFormattedCreatedAt() {
        if (createdAt == null) return "";
        
        long diff = System.currentTimeMillis() - createdAt.getTime();
        long seconds = diff / 1000;
        long minutes = seconds / 60;
        long hours = minutes / 60;
        long days = hours / 24;
        
        if (days > 0) {
            return days + " ngày trước";
        } else if (hours > 0) {
            return hours + " giờ trước";
        } else if (minutes > 0) {
            return minutes + " phút trước";
        } else {
            return "Vừa xong";
        }
    }
    
    /**
     * Kiểm tra có file đính kèm không
     * @return true nếu có file
     */
    public boolean hasFile() {
        return filePath != null && !filePath.trim().isEmpty();
    }
    
    /**
     * Kiểm tra file có phải là ảnh không
     * @return true nếu là ảnh
     */
    public boolean isImage() {
        if (fileType == null) return false;
        return fileType.toLowerCase().startsWith("image/");
    }
}