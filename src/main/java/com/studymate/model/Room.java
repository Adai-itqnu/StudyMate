package com.studymate.model;

public class Room {
    private int roomId;
    private String name;
    private String location;

    // Constructors
    public Room() {
    }

    public Room(int roomId, String name, String location) {
        this.roomId = roomId;
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

    @Override
    public String toString() {
        return "Room{" +
               "roomId=" + roomId +
               ", name='" + name + '\'' +
               ", location='" + location + '\'' +
               '}';
    }
} 