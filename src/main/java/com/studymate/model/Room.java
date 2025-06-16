package com.studymate.model;

import java.sql.Timestamp;

public class Room {
    private int roomId;
    private int hostId;
    private String roomName;
    private String description;
    private Timestamp createdAt;

    // Constructors
    public Room() {
    }

    public Room(int roomId, int hostId, String roomName, String description, Timestamp createdAt) {
        this.roomId = roomId;
        this.hostId = hostId;
        this.roomName = roomName;
        this.description = description;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getHostId() {
        return hostId;
    }

    public void setHostId(int hostId) {
        this.hostId = hostId;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Room{" +
               "roomId=" + roomId +
               ", hostId=" + hostId +
               ", roomName='" + roomName + '\'' +
               ", description='" + description + '\'' +
               ", createdAt=" + createdAt +
               '}'';
    }
} 