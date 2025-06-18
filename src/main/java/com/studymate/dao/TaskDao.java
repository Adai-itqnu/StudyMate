package com.studymate.dao;

import com.studymate.model.Task;
import java.util.List;

public interface TaskDao {
    List<Task> getTasksByUser(int userId, boolean completed);
    Task getTaskById(int taskId);
    void addTask(Task task);
    void updateTask(Task task);
    void deleteTask(int taskId);
    void pinTask(int taskId, boolean pinned, int userId) throws Exception;
    int countPinnedTasks(int userId);
}