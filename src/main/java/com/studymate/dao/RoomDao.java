package com.studymate.dao;

import com.studymate.model.Room;
import com.studymate.model.User;
import java.util.List;

public interface RoomDao {
    List<Room> findAll() throws Exception;
    Room findById(int roomId) throws Exception;
    void save(Room room) throws Exception;
    void update(Room room) throws Exception;
    void delete(int roomId) throws Exception;
    List<User> findMembersByRoomId(int roomId) throws Exception;
    void addMember(int roomId, int userId) throws Exception;
    void removeMember(int roomId, int userId) throws Exception;
}