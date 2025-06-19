package com.studymate.model;

import java.util.List;

public class Room {
    private int roomId;
    private int userId; // Người tạo nhóm
    private String name;
    private String location;
    private List<User> members; // Danh sách thành viên

    // Constructors
    public Room() {
    }

    public Room(int roomId, int userId, String name, String location) {
        this.roomId = roomId;
        this.userId = userId;
        this.name = name;
        this.location = location;
    }

    // Getters and Setters
    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public List<User> getMembers() {
        return members;
    }

    public void setMembers(List<User> members) {
        this.members = members;
    }

    @Override
    public String toString() {
        return "Room{" +
               "roomId=" + roomId +
               ", userId=" + userId +
               ", name='" + name + '\'' +
               ", location='" + location + '\'' +
               '}';
    }
}