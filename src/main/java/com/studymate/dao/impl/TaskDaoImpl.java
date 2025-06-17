package com.studymate.dao.impl;

import com.studymate.dao.TaskDao;
import com.studymate.model.Task;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;

@Repository
public class TaskDaoImpl implements TaskDao {
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    // RowMapper for Task
    private final RowMapper<Task> taskRowMapper = new RowMapper<Task>() {
        @Override
        public Task mapRow(ResultSet rs, int rowNum) throws SQLException {
            Task task = new Task();
            task.setTaskId(rs.getInt("task_id"));
            task.setUserId(rs.getInt("user_id"));
            task.setTitle(rs.getString("title"));
            task.setDescription(rs.getString("description"));
            task.setDueDate(rs.getTimestamp("due_date"));
            task.setStatus(rs.getString("status"));
            task.setPinned(rs.getBoolean("is_pinned"));
            
            // Handle nullable parent_id
            int parentId = rs.getInt("parent_id");
            if (rs.wasNull()) {
                task.setParentId(null);
            } else {
                task.setParentId(parentId);
            }
            
            task.setCreatedAt(rs.getTimestamp("created_at"));
            task.setUpdatedAt(rs.getTimestamp("updated_at"));
            
            // Set completion stats if available
            try {
                task.setTotalSubtasks(rs.getInt("total_subtasks"));
                task.setCompletedSubtasks(rs.getInt("completed_subtasks"));
            } catch (SQLException e) {
                // Columns may not exist in all queries
                task.setTotalSubtasks(0);
                task.setCompletedSubtasks(0);
            }
            
            return task;
        }
    };
    
    @Override
    public void createTask(Task task) {
        String sql = "INSERT INTO tasks (user_id, title, description, due_date, status, is_pinned, parent_id, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        KeyHolder keyHolder = new GeneratedKeyHolder();
        
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, task.getUserId());
            ps.setString(2, task.getTitle());
            ps.setString(3, task.getDescription());
            
            if (task.getDueDate() != null) {
                ps.setTimestamp(4, new java.sql.Timestamp(task.getDueDate().getTime()));
            } else {
                ps.setNull(4, java.sql.Types.TIMESTAMP);
            }
            
            ps.setString(5, task.getStatus());
            ps.setBoolean(6, task.isPinned());
            
            if (task.getParentId() != null) {
                ps.setInt(7, task.getParentId());
            } else {
                ps.setNull(7, java.sql.Types.INTEGER);
            }
            
            ps.setTimestamp(8, new java.sql.Timestamp(task.getCreatedAt().getTime()));
            ps.setTimestamp(9, new java.sql.Timestamp(task.getUpdatedAt().getTime()));
            
            return ps;
        }, keyHolder);
        
        // Set the generated task ID
        if (keyHolder.getKey() != null) {
            task.setTaskId(keyHolder.getKey().intValue());
        }
    }
    
    @Override
    public Task getTaskById(int taskId) {
        String sql = "SELECT * FROM tasks WHERE task_id = ?";
        
        try {
            Task task = jdbcTemplate.queryForObject(sql, taskRowMapper, taskId);
            
            // Load subtasks if this is a main task
            if (task != null && task.isMainTask()) {
                List<Task> subtasks = getSubtasksByParentId(taskId);
                task.setSubtasks(subtasks);
                
                // Update completion stats
                task.setTotalSubtasks(getTotalSubtasksCount(taskId));
                task.setCompletedSubtasks(getCompletedSubtasksCount(taskId));
            }
            
            return task;
        } catch (Exception e) {
            return null;
        }
    }
    
    @Override
    public void updateTask(Task task) {
        String sql = "UPDATE tasks SET title = ?, description = ?, due_date = ?, status = ?, is_pinned = ?, updated_at = ? " +
                    "WHERE task_id = ?";
        
        jdbcTemplate.update(sql,
            task.getTitle(),
            task.getDescription(),
            task.getDueDate() != null ? new java.sql.Timestamp(task.getDueDate().getTime()) : null,
            task.getStatus(),
            task.isPinned(),
            new java.sql.Timestamp(task.getUpdatedAt().getTime()),
            task.getTaskId()
        );
    }
    
    @Override
    public void deleteTask(int taskId) {
        // First delete all subtasks
        deleteSubtasksByParentId(taskId);
        
        // Then delete the main task
        String sql = "DELETE FROM tasks WHERE task_id = ?";
        jdbcTemplate.update(sql, taskId);
    }
    
    @Override
    public List<Task> getAllTasksByUserId(int userId) {
        String sql = "SELECT t.*, " +
                    "(SELECT COUNT(*) FROM tasks st WHERE st.parent_id = t.task_id) as total_subtasks, " +
                    "(SELECT COUNT(*) FROM tasks st WHERE st.parent_id = t.task_id AND st.status = 'DONE') as completed_subtasks " +
                    "FROM tasks t WHERE t.user_id = ? AND t.parent_id IS NULL " +
                    "ORDER BY t.is_pinned DESC, t.created_at DESC";
        
        List<Task> tasks = jdbcTemplate.query(sql, taskRowMapper, userId);
        
        // Load subtasks for each main task
        for (Task task : tasks) {
            List<Task> subtasks = getSubtasksByParentId(task.getTaskId());
            task.setSubtasks(subtasks);
        }
        
        return tasks;
    }
    
    @Override
    public List<Task> getCompletedTasksByUserId(int userId) {
        String sql = "SELECT t.*, " +
                    "(SELECT COUNT(*) FROM tasks st WHERE st.parent_id = t.task_id) as total_subtasks, " +
                    "(SELECT COUNT(*) FROM tasks st WHERE st.parent_id = t.task_id AND st.status = 'DONE') as completed_subtasks " +
                    "FROM tasks t WHERE t.user_id = ? AND t.parent_id IS NULL " +
                    "AND (t.status = 'DONE' OR " +
                    "((SELECT COUNT(*) FROM tasks st WHERE st.parent_id = t.task_id) > 0 AND " +
                    "(SELECT COUNT(*) FROM tasks st WHERE st.parent_id = t.task_id AND st.status = 'DONE') = " +
                    "(SELECT COUNT(*) FROM tasks st WHERE st.parent_id = t.task_id))) " +
                    "ORDER BY t.updated_at DESC";
        
        List<Task> tasks = jdbcTemplate.query(sql, taskRowMapper, userId);
        
        for (Task task : tasks) {
            List<Task> subtasks = getSubtasksByParentId(task.getTaskId());
            task.setSubtasks(subtasks);
        }
        
        return tasks;
    }
    
    @Override
    public List<Task> getIncompleteTasksByUserId(int userId) {
        String sql = "SELECT t.*, " +
                    "(SELECT COUNT(*) FROM tasks st WHERE st.parent_id = t.task_id) as total_subtasks, " +
                    "(SELECT COUNT(*) FROM tasks st WHERE st.parent_id = t.task_id AND st.status = 'DONE') as completed_subtasks " +
                    "FROM tasks t WHERE t.user_id = ? AND t.parent_id IS NULL " +
                    "AND NOT (t.status = 'DONE' OR " +
                    "((SELECT COUNT(*) FROM tasks st WHERE st.parent_id = t.task_id) > 0 AND " +
                    "(SELECT COUNT(*) FROM tasks st WHERE st.parent_id = t.task_id AND st.status = 'DONE') = " +
                    "(SELECT COUNT(*) FROM tasks st WHERE st.parent_id = t.task_id))) " +
                    "ORDER BY t.due_date ASC NULLS LAST, t.created_at DESC";
        
        List<Task> tasks = jdbcTemplate.query(sql, taskRowMapper, userId);
        
        for (Task task : tasks) {
            List<Task> subtasks = getSubtasksByParentId(task.getTaskId());
            task.setSubtasks(subtasks);
        }
        
        return tasks;
    }
    
    @Override
    public List<Task> getPinnedTasksByUserId(int userId) {
        String sql = "SELECT t.*, " +
                    "(SELECT COUNT(*) FROM tasks st WHERE st.parent_id = t.task_id) as total_subtasks, " +
                    "(SELECT COUNT(*) FROM tasks st WHERE st.parent_id = t.task_id AND st.status = 'DONE') as completed_subtasks " +
                    "FROM tasks t WHERE t.user_id = ? AND t.parent_id IS NULL AND t.is_pinned = true " +
                    "ORDER BY t.created_at DESC";
        
        List<Task> tasks = jdbcTemplate.query(sql, taskRowMapper, userId);
        
        for (Task task : tasks) {
            List<Task> subtasks = getSubtasksByParentId(task.getTaskId());
            task.setSubtasks(subtasks);
        }
        
        return tasks;
    }
    
    @Override
    public List<Task> getSubtasksByParentId(int parentId) {
        String sql = "SELECT * FROM tasks WHERE parent_id = ? ORDER BY created_at ASC";
        return jdbcTemplate.query(sql, taskRowMapper, parentId);
    }
    
    @Override
    public void deleteSubtasksByParentId(int parentId) {
        String sql = "DELETE FROM tasks WHERE parent_id = ?";
        jdbcTemplate.update(sql, parentId);
    }
    
    @Override
    public int getCompletedSubtasksCount(int parentId) {
        String sql = "SELECT COUNT(*) FROM tasks WHERE parent_id = ? AND status = 'DONE'";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, parentId);
        return count != null ? count : 0;
    }
    
    @Override
    public int getTotalSubtasksCount(int parentId) {
        String sql = "SELECT COUNT(*) FROM tasks WHERE parent_id = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, parentId);
        return count != null ? count : 0;
    }
    
    @Override
    public int getPinnedTasksCount(int userId) {
        String sql = "SELECT COUNT(*) FROM tasks WHERE user_id = ? AND parent_id IS NULL AND is_pinned = true";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, userId);
        return count != null ? count : 0;
    }
}