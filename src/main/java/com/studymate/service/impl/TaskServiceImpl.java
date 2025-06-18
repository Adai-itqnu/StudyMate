package com.studymate.service.impl;

import com.studymate.dao.TaskDao;
import com.studymate.model.Task;
import com.studymate.service.TaskService;

import java.util.List;

public class TaskServiceImpl implements TaskService {
    private TaskDao taskDAO;

    public TaskServiceImpl(TaskDao taskDAO) {
        this.taskDAO = taskDAO;
    }

    @Override
    public List<Task> getTasksByUser(int userId, boolean completed) {
        return taskDAO.getTasksByUser(userId, completed);
    }

    @Override
    public Task getTaskById(int taskId) {
        return taskDAO.getTaskById(taskId);
    }

    @Override
    public void addTask(Task task) {
        taskDAO.addTask(task);
    }

    @Override
    public void updateTask(Task task) {
        taskDAO.updateTask(task);
    }

    @Override
    public void deleteTask(int taskId) {
        taskDAO.deleteTask(taskId);
    }

    @Override
    public void pinTask(int taskId, boolean pinned, int userId) throws Exception {
        taskDAO.pinTask(taskId, pinned, userId);
    }

    @Override
    public int countPinnedTasks(int userId) {
        return taskDAO.countPinnedTasks(userId);
    }
}