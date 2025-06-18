package com.studymate.dao;

import com.studymate.model.Schedule;

import java.util.List;

public interface ScheduleDao {
    List<Schedule> getSchedulesByUserId(int userId);
    Schedule getScheduleById(int scheduleId);
    boolean addSchedule(Schedule schedule);
    boolean updateSchedule(Schedule schedule);
    boolean deleteSchedule(int scheduleId);
    boolean hasConflict(Schedule schedule);
}