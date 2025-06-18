package com.studymate.dao.impl;

import com.studymate.dao.ScheduleDao;
import com.studymate.model.Schedule;
import com.studymate.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ScheduleDaoImpl implements ScheduleDao {

    @Override
    public List<Schedule> getSchedulesByUserId(int userId) {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT * FROM schedules WHERE user_id = ? ORDER BY day_of_week, start_time";

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
        String sql = "SELECT * FROM schedules WHERE schedule_id = ?";

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
        String sql = "INSERT INTO schedules (user_id, subject, room, day_of_week, start_time, end_time, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, NOW(), NOW())";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, schedule.getUserId());
            stmt.setString(2, schedule.getSubject());
            stmt.setString(3, schedule.getRoom());
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
        String sql = "UPDATE schedules SET subject=?, room=?, day_of_week=?, start_time=?, end_time=?, updated_at=NOW() " +
                     "WHERE schedule_id=?";

        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, schedule.getSubject());
            stmt.setString(2, schedule.getRoom());
            stmt.setInt(3, schedule.getDayOfWeek());
            stmt.setTime(4, schedule.getStartTime());
            stmt.setTime(5, schedule.getEndTime());
            stmt.setInt(6, schedule.getScheduleId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean deleteSchedule(int scheduleId) {
        String sql = "DELETE FROM schedules WHERE schedule_id = ?";

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
    public boolean hasConflict(Schedule schedule) {
        String sql = "SELECT COUNT(*) FROM schedules WHERE user_id = ? AND day_of_week = ? AND schedule_id != ? AND " +
                     "((start_time <= ? AND end_time > ?) OR (start_time < ? AND end_time >= ?))";

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
        schedule.setScheduleId(rs.getInt("schedule_id"));
        schedule.setUserId(rs.getInt("user_id"));
        schedule.setSubject(rs.getString("subject"));
        schedule.setRoom(rs.getString("room"));
        schedule.setDayOfWeek(rs.getInt("day_of_week"));
        schedule.setStartTime(rs.getTime("start_time"));
        schedule.setEndTime(rs.getTime("end_time"));
        schedule.setCreatedAt(rs.getTimestamp("created_at"));
        schedule.setUpdatedAt(rs.getTimestamp("updated_at"));
        return schedule;
    }
}