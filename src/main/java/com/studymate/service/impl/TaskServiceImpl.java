package com.studymate.service.impl;

import com.studymate.dao.TaskDao;
import com.studymate.model.Task;
import com.studymate.service.TaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
@Transactional
public class TaskServiceImpl implements TaskService {
    
    @Autowired
    private TaskDao taskDao;
    
    @Override
    public void createTask(Task task) {
        // Validation
        if (task.getTitle() == null || task.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Tiêu đề task không được để trống");
        }
        
        // Set default values
        if (task.getStatus() == null) {
            task.setStatus("TODO");
        }
        
        if (task.getCreatedAt() == null) {
            task.setCreatedAt(new Date());
        }
        
        if (task.getUpdatedAt() == null) {
            task.setUpdatedAt(new Date());
        }
        
        taskDao.createTask(task);
        
        // If this is a subtask, update parent completion
        if (task.getParentId() != null) {
            updateParentTaskCompletion(task.getParentId());
        }
    }
    
    @Override
    public Task getTaskById(int taskId) {
        return taskDao.getTaskById(taskId);
    }
    
    @Override
    public void updateTask(Task task) {
        if (task.getTitle() == null || task.getTitle().trim().isEmpty()) {
            throw new IllegalArgumentException("Tiêu đề task không được để trống");
        }
        
        task.setUpdatedAt(new Date());
        taskDao.updateTask(task);
        
        // If this is a subtask, update parent completion
        if (task.getParentId() != null) {
            updateParentTaskCompletion(task.getParentId());
        }
    }
    
    @Override
    public void deleteTask(int taskId) {
        Task task = taskDao.getTaskById(taskId);
        if (task == null) {
            throw new IllegalArgumentException("Task không tồn tại");
        }
        
        Integer parentId = task.getParentId();
        taskDao.deleteTask(taskId);
        
        // If this was a subtask, update parent completion
        if (parentId != null) {
            updateParentTaskCompletion(parentId);
        }
    }
    
    @Override
    public List<Task> getAllTasksByUserId(int userId) {
        return taskDao.getAllTasksByUserId(userId);
    }
    
    @Override
    public List<Task> getCompletedTasksByUserId(int userId) {
        return taskDao.getCompletedTasksByUserId(userId);
    }
    
    @Override
    public List<Task> getIncompleteTasksByUserId(int userId) {
        return taskDao.getIncompleteTasksByUserId(userId);
    }
    
    @Override
    public List<Task> getPinnedTasksByUserId(int userId) {
        return taskDao.getPinnedTasksByUserId(userId);
    }
    
    @Override
    public List<Task> getSubtasksByParentId(int parentId) {
        return taskDao.getSubtasksByParentId(parentId);
    }
    
    @Override
    public void toggleTaskStatus(int taskId) {
        Task task = taskDao.getTaskById(taskId);
        if (task == null) {
            throw new IllegalArgumentException("Task không tồn tại");
        }
        
        String newStatus = "DONE".equals(task.getStatus()) ? "TODO" : "DONE";
        task.setStatus(newStatus);
        task.setUpdatedAt(new Date());
        
        taskDao.updateTask(task);
        
        // If this is a subtask, update parent completion
        if (task.getParentId() != null) {
            updateParentTaskCompletion(task.getParentId());
        }
    }
    
    @Override
    public void toggleTaskPin(int taskId, int userId) throws Exception {
        Task task = taskDao.getTaskById(taskId);
        if (task == null) {
            throw new IllegalArgumentException("Task không tồn tại");
        }
        
        // If trying to pin and already at limit
        if (!task.isPinned() && !canPinTask(userId)) {
            throw new Exception("Chỉ có thể ghim tối đa 3 task!");
        }
        
        task.setPinned(!task.isPinned());
        task.setUpdatedAt(new Date());
        
        taskDao.updateTask(task);
    }
    
    @Override
    public boolean canPinTask(int userId) {
        int pinnedCount = taskDao.getPinnedTasksCount(userId);
        return pinnedCount < 3;
    }
    
    @Override
    public void updateParentTaskCompletion(int parentId) {
        // This method is called when subtasks change
        // The completion is calculated dynamically in the DAO queries
        // But we can update the parent's updated_at timestamp
        Task parentTask = taskDao.getTaskById(parentId);
        if (parentTask != null) {
            parentTask.setUpdatedAt(new Date());
            taskDao.updateTask(parentTask);
        }
    }
}