package com.studymate.dao.impl;

import com.studymate.dao.RoomDao;
import com.studymate.model.Room;
import com.studymate.model.User;
import com.studymate.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomDaoImpl implements RoomDao {

	@Override
    public List<Room> findAll() throws Exception {
        String sql = "SELECT r.*, u.fullName AS creator_name FROM rooms r JOIN users u ON r.user_id = u.user_id ORDER BY r.name";
        List<Room> rooms = new ArrayList<>();
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                rooms.add(mapRowToRoom(rs));
            }
        }
        return rooms;
    }

	@Override
    public Room findById(int roomId) throws Exception {
        String sql = "SELECT r.*, u.fullName AS creator_name FROM rooms r JOIN users u ON r.user_id = u.user_id WHERE r.room_id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Room room = mapRowToRoom(rs);
                    room.setMembers(findMembersByRoomId(roomId));
                    return room;
                }
                return null;
            }
        }
    }

    @Override
    public void save(Room room) throws Exception {
        String sql = "INSERT INTO rooms (user_id, name, location) VALUES (?, ?, ?)";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, room.getUserId());
            ps.setString(2, room.getName());
            ps.setString(3, room.getLocation());
            int affectedRows = ps.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating room failed, no rows affected.");
            }

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    room.setRoomId(generatedKeys.getInt(1));
                } else {
                    throw new SQLException("Creating room failed, no ID obtained.");
                }
            }
        }
    }

    @Override
    public void update(Room room) throws Exception {
        String sql = "UPDATE rooms SET name = ?, location = ? WHERE room_id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, room.getName());
            ps.setString(2, room.getLocation());
            ps.setInt(3, room.getRoomId());
            ps.executeUpdate();
        }
    }

    @Override
    public void delete(int roomId) throws Exception {
        String sql = "DELETE FROM rooms WHERE room_id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.executeUpdate();
        }
    }

    @Override
    public List<User> findMembersByRoomId(int roomId) throws Exception {
        String sql = "SELECT u.* FROM users u JOIN room_members rm ON u.user_id = rm.user_id WHERE rm.room_id = ?";
        List<User> members = new ArrayList<>();
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("fullname"));
                    user.setUsername(rs.getString("username"));
                    user.setAvatarUrl(rs.getString("avatar_url"));
                    members.add(user);
                }
            }
        }
        return members;
    }

    @Override
    public void addMember(int roomId, int userId) throws Exception {
        String sql = "INSERT INTO room_members (room_id, user_id) VALUES (?, ?)";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    @Override
    public void removeMember(int roomId, int userId) throws Exception {
        String sql = "DELETE FROM room_members WHERE room_id = ? AND user_id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    private Room mapRowToRoom(ResultSet rs) throws SQLException {
        Room room = new Room();
        room.setRoomId(rs.getInt("room_id"));
        room.setUserId(rs.getInt("user_id"));
        room.setName(rs.getString("name"));
        room.setLocation(rs.getString("location"));
        return room;
    }
}