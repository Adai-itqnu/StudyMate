package com.studymate.model;

import java.util.Date;

public class Task {
    private int taskId;
    private int userId;
    private String title;
    private String description;
    private Date dueDate;
    private String status; // PENDING, DONE
    private boolean isPinned;
    private Date createdAt;
    private Date updatedAt;

    // Default constructor
    public Task() {
        this.status = "PENDING";
        this.isPinned = false;
        this.createdAt = new Date();
        this.updatedAt = new Date();
    }

    // Constructor với title, description, userId
    public Task(String title, String description, int userId) {
        this();
        this.title = title;
        this.description = description;
        this.userId = userId;
    }
    
    // Constructor với các thuộc tính chính
    public Task(int userId, String title, String description, Date dueDate, String status, boolean isPinned) {
        this();
        this.userId = userId;
        this.title = title;
        this.description = description;
        this.dueDate = dueDate;
        this.status = status != null ? status : "PENDING";
        this.isPinned = isPinned;
    }

    // Getters and Setters
    public int getTaskId() {
        return taskId;
    }

    public void setTaskId(int taskId) {
        this.taskId = taskId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isPinned() {
        return isPinned;
    }

    public void setPinned(boolean pinned) {
        isPinned = pinned;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

//    @Override
//    public String toString() {
//        return "Task{" +
//                "taskId=" + taskId +
//                ", userId=" + userId +
//                ", title='" + title + '\'' +
//                ", description='" + description + '\'' +
//                ", dueDate=" + dueDate +
//                ", status='" + status + '\'' +
//                ", isPinned=" + isPinned +
//                ", createdAt=" + createdAt +
//                ", updatedAt=" + updatedAt +
//                '}';
//    }
}