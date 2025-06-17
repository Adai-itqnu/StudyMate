package com.studymate.service;

import com.studymate.model.Task;
import java.util.List;

public interface TaskService {
    
    // Basic CRUD operations
    void createTask(Task task);
    Task getTaskById(int taskId);
    void updateTask(Task task);
    void deleteTask(int taskId);
    
    // Query operations
    List<Task> getAllTasksByUserId(int userId);
    List<Task> getCompletedTasksByUserId(int userId);
    List<Task> getIncompleteTasksByUserId(int userId);
    List<Task> getPinnedTasksByUserId(int userId);
    List<Task> getSubtasksByParentId(int parentId);
    
    // Status operations
    void toggleTaskStatus(int taskId);
    void toggleTaskPin(int taskId, int userId) throws Exception;
    
    // Validation
    boolean canPinTask(int userId);
    void updateParentTaskCompletion(int parentId);
}