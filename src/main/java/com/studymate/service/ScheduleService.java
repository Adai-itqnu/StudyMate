package com.studymate.service;

import com.studymate.model.Schedule;
import java.util.List;
import java.util.Map;

public interface ScheduleService {
    List<Schedule> getAllSchedules();
    List<Schedule> getSchedulesByUserId(int userId);
    Schedule getScheduleById(int scheduleId);
    boolean createSchedule(Schedule schedule);
    boolean updateSchedule(Schedule schedule);
    boolean deleteSchedule(int scheduleId);
    Map<String, List<Schedule>> getWeeklyScheduleGrid(int userId);
    boolean validateSchedule(Schedule schedule);
    List<Schedule> getSchedulesByDay(int userId, int dayOfWeek);
}