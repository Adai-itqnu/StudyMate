package com.studymate.service.impl;

import com.studymate.dao.RoomDao;
import com.studymate.model.Room;
import com.studymate.service.RoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.util.List;

@Service
public class RoomServiceImpl implements RoomService {

    @Autowired
    private RoomDao roomDao;

    @Override
    public void addRoom(Room room) {
        try {
            roomDao.addRoom(room);
        } catch (SQLException e) {
            throw new RuntimeException("Error adding room", e);
        }
    }

    @Override
    public List<Room> getAllRooms() {
        try {
            return roomDao.getAllRooms();
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving all rooms", e);
        }
    }

    @Override
    public Room getRoomById(int roomId) {
        try {
            return roomDao.getRoomById(roomId);
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving room by ID", e);
        }
    }

    @Override
    public void updateRoom(Room room) {
        try {
            roomDao.updateRoom(room);
        } catch (SQLException e) {
            throw new RuntimeException("Error updating room", e);
        }
    }

    @Override
    public void deleteRoom(int roomId) {
        try {
            roomDao.deleteRoom(roomId);
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting room", e);
        }
    }

    @Override
    public List<Room> getRoomsByHostId(int hostId) {
        try {
            return roomDao.getRoomsByHostId(hostId);
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving rooms by host ID", e);
        }
    }
} 