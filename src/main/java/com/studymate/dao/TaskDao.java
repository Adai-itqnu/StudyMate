package com.studymate.dao;

import com.studymate.model.Task;
import java.util.List;

public interface TaskDao {
    
    // Basic CRUD operations
    void createTask(Task task);
    Task getTaskById(int taskId);
    void updateTask(Task task);
    void deleteTask(int taskId);
    
    // Query operations for main tasks
    List<Task> getAllTasksByUserId(int userId);
    List<Task> getCompletedTasksByUserId(int userId);
    List<Task> getIncompleteTasksByUserId(int userId);
    List<Task> getPinnedTasksByUserId(int userId);
    
    // Subtask operations
    List<Task> getSubtasksByParentId(int parentId);
    void deleteSubtasksByParentId(int parentId);
    
    // Statistics
    int getCompletedSubtasksCount(int parentId);
    int getTotalSubtasksCount(int parentId);
    int getPinnedTasksCount(int userId);
}