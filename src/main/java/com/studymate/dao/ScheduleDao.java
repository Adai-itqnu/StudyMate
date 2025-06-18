package com.studymate.dao;

import com.studymate.model.Schedule;
import java.util.List;

public interface ScheduleDao {
    List<Schedule> getAllSchedules();
    List<Schedule> getSchedulesByUserId(int userId);
    Schedule getScheduleById(int scheduleId);
    boolean addSchedule(Schedule schedule);
    boolean updateSchedule(Schedule schedule);
    boolean deleteSchedule(int scheduleId);
    List<Schedule> getSchedulesByDayAndTime(int dayOfWeek, String startTime, String endTime);
    boolean hasConflict(Schedule schedule);
}