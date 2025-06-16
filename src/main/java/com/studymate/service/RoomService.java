package com.studymate.service;

import com.studymate.model.Room;

import java.sql.SQLException;
import java.util.List;

public interface RoomService {
    void addRoom(Room room);
    List<Room> getAllRooms();
    Room getRoomById(int roomId);
    void updateRoom(Room room);
    void deleteRoom(int roomId);
    List<Room> getRoomsByHostId(int hostId);
} 