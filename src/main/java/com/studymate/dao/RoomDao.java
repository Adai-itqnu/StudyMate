package com.studymate.dao;

import com.studymate.model.Room;

import java.sql.SQLException;
import java.util.List;

public interface RoomDao {
    void addRoom(Room room) throws SQLException;
    List<Room> getAllRooms() throws SQLException;
    Room getRoomById(int roomId) throws SQLException;
    void updateRoom(Room room) throws SQLException;
    void deleteRoom(int roomId) throws SQLException;
    List<Room> getRoomsByHostId(int hostId) throws SQLException;
} 