package com.studymate.dao.impl;

import com.studymate.dao.ScheduleDao;
import com.studymate.model.Schedule;
import com.studymate.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ScheduleDaoImpl implements ScheduleDao {
    
    @Override
    public List<Schedule> getAllSchedules() {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT * FROM schedules ORDER BY dayOfWeek, startTime";
        
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                schedules.add(mapResultSetToSchedule(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return schedules;
    }
    
    @Override
    public List<Schedule> getSchedulesByUserId(int userId) {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT * FROM schedules WHERE userId = ? ORDER BY dayOfWeek, startTime";
        
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                schedules.add(mapResultSetToSchedule(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return schedules;
    }
    
    @Override
    public Schedule getScheduleById(int scheduleId) {
        String sql = "SELECT * FROM schedules WHERE scheduleId = ?";
        
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, scheduleId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToSchedule(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    @Override
    public boolean addSchedule(Schedule schedule) {
        if (hasConflict(schedule)) {
            return false;
        }
        
        String sql = "INSERT INTO schedules (userId, subjectId, roomId, dayOfWeek, startTime, endTime, createdAt, updatedAt) VALUES (?, ?, ?, ?, ?, ?, NOW(), NOW())";
        
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, schedule.getUserId());
            stmt.setInt(2, schedule.getSubjectId());
            stmt.setInt(3, schedule.getRoomId());
            stmt.setInt(4, schedule.getDayOfWeek());
            stmt.setTime(5, schedule.getStartTime());
            stmt.setTime(6, schedule.getEndTime());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    @Override
    public boolean updateSchedule(Schedule schedule) {
        if (hasConflict(schedule)) {
            return false;
        }
        
        String sql = "UPDATE schedules SET userId=?, subjectId=?, roomId=?, dayOfWeek=?, startTime=?, endTime=?, updatedAt=NOW() WHERE scheduleId=?";
        
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, schedule.getUserId());
            stmt.setInt(2, schedule.getSubjectId());
            stmt.setInt(3, schedule.getRoomId());
            stmt.setInt(4, schedule.getDayOfWeek());
            stmt.setTime(5, schedule.getStartTime());
            stmt.setTime(6, schedule.getEndTime());
            stmt.setInt(7, schedule.getScheduleId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    @Override
    public boolean deleteSchedule(int scheduleId) {
        String sql = "DELETE FROM schedules WHERE scheduleId = ?";
        
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, scheduleId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    @Override
    public List<Schedule> getSchedulesByDayAndTime(int dayOfWeek, String startTime, String endTime) {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT * FROM schedules WHERE dayOfWeek = ? AND startTime >= ? AND endTime <= ? ORDER BY startTime";
        
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, dayOfWeek);
            stmt.setString(2, startTime);
            stmt.setString(3, endTime);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                schedules.add(mapResultSetToSchedule(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return schedules;
    }
    
    @Override
    public boolean hasConflict(Schedule schedule) {
        String sql = "SELECT COUNT(*) FROM schedules WHERE userId = ? AND dayOfWeek = ? AND scheduleId != ? AND ((startTime <= ? AND endTime > ?) OR (startTime < ? AND endTime >= ?))";
        
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, schedule.getUserId());
            stmt.setInt(2, schedule.getDayOfWeek());
            stmt.setInt(3, schedule.getScheduleId());
            stmt.setTime(4, schedule.getStartTime());
            stmt.setTime(5, schedule.getStartTime());
            stmt.setTime(6, schedule.getEndTime());
            stmt.setTime(7, schedule.getEndTime());
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private Schedule mapResultSetToSchedule(ResultSet rs) throws SQLException {
        Schedule schedule = new Schedule();
        schedule.setScheduleId(rs.getInt("scheduleId"));
        schedule.setUserId(rs.getInt("userId"));
        schedule.setSubjectId(rs.getInt("subjectId"));
        schedule.setRoomId(rs.getInt("roomId"));
        schedule.setDayOfWeek(rs.getInt("dayOfWeek"));
        schedule.setStartTime(rs.getTime("startTime"));
        schedule.setEndTime(rs.getTime("endTime"));
        schedule.setCreatedAt(rs.getTimestamp("createdAt"));
        schedule.setUpdatedAt(rs.getTimestamp("updatedAt"));
        return schedule;
    }
}