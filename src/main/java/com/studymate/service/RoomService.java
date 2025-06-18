package com.studymate.service;

import com.studymate.model.Room;
import java.util.List;

public interface RoomService {
    // Lấy tất cả các phòng
    List<Room> findAllRooms() throws Exception;

    // Lấy phòng theo ID
    Room findRoomById(int roomId) throws Exception;

    // Tạo phòng mới
    void createRoom(Room room) throws Exception;
    
    List<Room> getAllRooms() throws Exception;
    
    Room getRoomById(int id) throws Exception;
} 	