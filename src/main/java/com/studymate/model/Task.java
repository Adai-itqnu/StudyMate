package com.studymate.model;

import java.util.Date;
import java.util.List;

public class Task {
    private Integer taskId;
    private Integer userId;
    private String title;
    private String description;
    private Date dueDate;
    private String status; // TODO, DONE
    private boolean isPinned;
    private Integer parentId; // null nếu là main task
    private Date createdAt;
    private Date updatedAt;
    
    // Fields for completion tracking
    private List<Task> subtasks;
    private int totalSubtasks;
    private int completedSubtasks;
    
    // Constructors
    public Task() {}
    
    public Task(String title, String description, Integer userId) {
        this.title = title;
        this.description = description;
        this.userId = userId;
        this.status = "TODO";
        this.isPinned = false;
        this.createdAt = new Date();
        this.updatedAt = new Date();
    }
    
    // Helper methods
    public boolean isMainTask() {
        return parentId == null;
    }
    
    public boolean isSubtask() {
        return parentId != null;
    }
    
    public boolean isCompleted() {
        if (isMainTask() && hasSubtasks()) {
            return totalSubtasks > 0 && completedSubtasks == totalSubtasks;
        }
        return "DONE".equals(status);
    }
    
    public boolean hasSubtasks() {
        return subtasks != null && !subtasks.isEmpty();
    }
    
    public double getCompletionPercentage() {
        if (totalSubtasks == 0) return 0.0;
        return (double) completedSubtasks / totalSubtasks * 100;
    }
    
    // Getters and Setters
    public Integer getTaskId() {
        return taskId;
    }
    
    public void setTaskId(Integer taskId) {
        this.taskId = taskId;
    }
    
    public Integer getUserId() {
        return userId;
    }
    
    public void setUserId(Integer userId) {
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
    
    public Integer getParentId() {
        return parentId;
    }
    
    public void setParentId(Integer parentId) {
        this.parentId = parentId;
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
    
    public List<Task> getSubtasks() {
        return subtasks;
    }
    
    public void setSubtasks(List<Task> subtasks) {
        this.subtasks = subtasks;
    }
    
    public int getTotalSubtasks() {
        return totalSubtasks;
    }
    
    public void setTotalSubtasks(int totalSubtasks) {
        this.totalSubtasks = totalSubtasks;
    }
    
    public int getCompletedSubtasks() {
        return completedSubtasks;
    }
    
    public void setCompletedSubtasks(int completedSubtasks) {
        this.completedSubtasks = completedSubtasks;
    }
}