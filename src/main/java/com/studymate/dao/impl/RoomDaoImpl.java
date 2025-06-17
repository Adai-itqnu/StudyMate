package com.studymate.dao.impl;

import com.studymate.dao.RoomDao;
import com.studymate.model.Room;
import com.studymate.util.DBConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class RoomDaoImpl implements RoomDao {

    @Override
    public List<Room> findAll() throws Exception {
        String sql = "SELECT * FROM rooms ORDER BY name";
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
        String sql = "SELECT * FROM rooms WHERE room_id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToRoom(rs);
                }
                return null;
            }
        }
    }

    @Override
    public void save(Room room) throws Exception {
        String sql = "INSERT INTO rooms (name, location) VALUES (?, ?)";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, room.getName());
            ps.setString(2, room.getLocation());
            int affectedRows = ps.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating room failed, no rows affected.");
            }

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    room.setRoomId(generatedKeys.getInt(1));
                }
                else {
                    throw new SQLException("Creating room failed, no ID obtained.");
                }
            }
        }
    }

    private Room mapRowToRoom(ResultSet rs) throws SQLException {
        Room room = new Room();
        room.setRoomId(rs.getInt("room_id"));
        room.setName(rs.getString("name"));
        room.setLocation(rs.getString("location"));
        return room;
    }
} 