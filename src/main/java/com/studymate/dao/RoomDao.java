package com.studymate.dao;

import com.studymate.model.Room;
import java.util.List;

public interface RoomDao {
    // Lấy tất cả các phòng
    List<Room> findAll() throws Exception;

    // Lấy phòng theo ID
    Room findById(int roomId) throws Exception;

    // Lưu phòng mới
    void save(Room room) throws Exception;
} 