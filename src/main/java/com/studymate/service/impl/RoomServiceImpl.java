package com.studymate.service.impl;

import com.studymate.dao.RoomDao;
import com.studymate.dao.impl.RoomDaoImpl;
import com.studymate.model.Room;
import com.studymate.model.User;
import com.studymate.service.RoomService;

import java.util.List;

public class RoomServiceImpl implements RoomService {

    private final RoomDao roomDao = new RoomDaoImpl();

    @Override
    public List<Room> findAllRooms() throws Exception {
        return roomDao.findAll();
    }

    @Override
    public Room findRoomById(int roomId) throws Exception {
        return roomDao.findById(roomId);
    }

    @Override
    public void createRoom(Room room) throws Exception {
        roomDao.save(room);
    }

    @Override
    public void updateRoom(Room room) throws Exception {
        roomDao.update(room);
    }

    @Override
    public void deleteRoom(int roomId) throws Exception {
        roomDao.delete(roomId);
    }

    @Override
    public List<User> findMembersByRoomId(int roomId) throws Exception {
        return roomDao.findMembersByRoomId(roomId);
    }

    @Override
    public void addMember(int roomId, int userId) throws Exception {
        roomDao.addMember(roomId, userId);
    }

    @Override
    public void removeMember(int roomId, int userId) throws Exception {
        roomDao.removeMember(roomId, userId);
    }
}