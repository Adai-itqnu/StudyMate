package com.studymate.service.impl;

import com.studymate.dao.RoomDao;
import com.studymate.dao.impl.RoomDaoImpl;
import com.studymate.model.Room;
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
} 