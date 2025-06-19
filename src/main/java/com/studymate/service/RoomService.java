package com.studymate.service;

import com.studymate.model.Room;
import com.studymate.model.User;
import java.util.List;

public interface RoomService {
    List<Room> findAllRooms() throws Exception;
    Room findRoomById(int roomId) throws Exception;
    void createRoom(Room room) throws Exception;
    void updateRoom(Room room) throws Exception;
    void deleteRoom(int roomId) throws Exception;
    List<User> findMembersByRoomId(int roomId) throws Exception;
    void addMember(int roomId, int userId) throws Exception;
    void removeMember(int roomId, int userId) throws Exception;
}