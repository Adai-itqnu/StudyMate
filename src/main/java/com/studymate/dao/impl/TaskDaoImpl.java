package com.studymate.dao.impl;

import com.studymate.dao.TaskDao;
import com.studymate.model.Task;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TaskDaoImpl implements TaskDao {
    private Connection connection;

    public TaskDaoImpl(Connection connection) {
        this.connection = connection;
    }

    @Override
    public List<Task> getTasksByUser(int userId, boolean completed) {
        List<Task> tasks = new ArrayList<>();
        String sql = "SELECT * FROM tasks WHERE user_id = ? AND status = ? ORDER BY is_pinned DESC, due_date ASC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, completed ? "DONE" : "PENDING");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Task task = mapRowToTask(rs);
                tasks.add(task);
            }
        } catch (SQLException e) {
            System.err.println("Error getting tasks by user: " + e.getMessage());
            e.printStackTrace();
        }
        return tasks;
    }

    @Override
    public Task getTaskById(int taskId) {
        String sql = "SELECT * FROM tasks WHERE task_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapRowToTask(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error getting task by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public void addTask(Task task) {
        String sql = "INSERT INTO tasks (user_id, title, description, due_date, status, is_pinned, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";
        try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, task.getUserId());
            ps.setString(2, task.getTitle());
            ps.setString(3, task.getDescription() != null ? task.getDescription() : "");
            
            if (task.getDueDate() != null) {
                ps.setDate(4, new java.sql.Date(task.getDueDate().getTime()));
            } else {
                ps.setNull(4, Types.DATE);
            }
            
            ps.setString(5, task.getStatus() != null ? task.getStatus() : "PENDING");
            ps.setBoolean(6, task.isPinned());
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("Rows affected: " + rowsAffected);
            
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                task.setTaskId(rs.getInt(1));
                System.out.println("Generated task ID: " + task.getTaskId());
            }
        } catch (SQLException e) {
            System.err.println("Error adding task: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to add task", e);
        }
    }

    @Override
    public void updateTask(Task task) {
        String sql = "UPDATE tasks SET title=?, description=?, due_date=?, status=?, is_pinned=?, updated_at=CURRENT_TIMESTAMP WHERE task_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, task.getTitle());
            ps.setString(2, task.getDescription() != null ? task.getDescription() : "");
            
            if (task.getDueDate() != null) {
                ps.setDate(3, new java.sql.Date(task.getDueDate().getTime()));
            } else {
                ps.setNull(3, Types.DATE);
            }
            
            ps.setString(4, task.getStatus());
            ps.setBoolean(5, task.isPinned());
            ps.setInt(6, task.getTaskId());
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("Update task - Rows affected: " + rowsAffected);
            
        } catch (SQLException e) {
            System.err.println("Error updating task: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to update task", e);
        }
    }

    @Override
    public void deleteTask(int taskId) {
        String sql = "DELETE FROM tasks WHERE task_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, taskId);
            int rowsAffected = ps.executeUpdate();
            System.out.println("Delete task - Rows affected: " + rowsAffected);
        } catch (SQLException e) {
            System.err.println("Error deleting task: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("Failed to delete task", e);
        }
    }

    @Override
    public void pinTask(int taskId, boolean pinned, int userId) throws Exception {
        // Kiểm tra giới hạn ghim chỉ khi đang ghim task
        if (pinned && countPinnedTasks(userId) >= 3) {
            throw new Exception("Chỉ được ghim tối đa 3 task!");
        }
        
        String sql = "UPDATE tasks SET is_pinned=?, updated_at=CURRENT_TIMESTAMP WHERE task_id=? AND user_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, pinned);
            ps.setInt(2, taskId);
            ps.setInt(3, userId);
            
            int rowsAffected = ps.executeUpdate();
            System.out.println("Pin task - Rows affected: " + rowsAffected);
            
            if (rowsAffected == 0) {
                throw new Exception("Task không tồn tại hoặc bạn không có quyền thay đổi task này!");
            }
            
        } catch (SQLException e) {
            System.err.println("Error pinning task: " + e.getMessage());
            e.printStackTrace();
            throw new Exception("Lỗi khi ghim/bỏ ghim task: " + e.getMessage());
        }
    }

    @Override
    public int countPinnedTasks(int userId) {
        String sql = "SELECT COUNT(*) FROM tasks WHERE user_id=? AND is_pinned=TRUE AND status='PENDING'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("Pinned tasks count for user " + userId + ": " + count);
                return count;
            }
        } catch (SQLException e) {
            System.err.println("Error counting pinned tasks: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    private Task mapRowToTask(ResultSet rs) throws SQLException {
        Task task = new Task();
        task.setTaskId(rs.getInt("task_id"));
        task.setUserId(rs.getInt("user_id"));
        task.setTitle(rs.getString("title"));
        task.setDescription(rs.getString("description"));
        
        java.sql.Date dueDate = rs.getDate("due_date");
        if (dueDate != null) {
            task.setDueDate(new java.util.Date(dueDate.getTime()));
        }
        
        task.setStatus(rs.getString("status"));
        task.setPinned(rs.getBoolean("is_pinned"));
        task.setCreatedAt(rs.getTimestamp("created_at"));
        task.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        return task;
    }
}