package com.studymate.model;

import java.sql.Time;
import java.util.Date;

public class Schedule {
    private int scheduleId;
    private int userId;
    private String subject;
    private String room;
    private int dayOfWeek;
    private Time startTime;
    private Time endTime;
    private Date createdAt;
    private Date updatedAt;

    // Constructor
    public Schedule() {}

    public Schedule(int userId, String subject, String room, int dayOfWeek, Time startTime, Time endTime) {
        this.userId = userId;
        this.subject = subject;
        this.room = room;
        this.dayOfWeek = dayOfWeek;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    // Getters and Setters
    public int getScheduleId() { return scheduleId; }
    public void setScheduleId(int scheduleId) { this.scheduleId = scheduleId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }
    public String getRoom() { return room; }
    public void setRoom(String room) { this.room = room; }
    public int getDayOfWeek() { return dayOfWeek; }
    public void setDayOfWeek(int dayOfWeek) { this.dayOfWeek = dayOfWeek; }
    public Time getStartTime() { return startTime; }
    public void setStartTime(Time startTime) { this.startTime = startTime; }
    public Time getEndTime() { return endTime; }
    public void setEndTime(Time endTime) { this.endTime = endTime; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "Schedule{scheduleId=" + scheduleId + ", userId=" + userId +
               ", subject='" + subject + "', room='" + room + "', dayOfWeek=" + dayOfWeek +
               ", startTime=" + startTime + ", endTime=" + endTime +
               ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + '}';
    }
}