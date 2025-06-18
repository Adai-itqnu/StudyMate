package com.studymate.service.impl;

import com.studymate.dao.ScheduleDao;
import com.studymate.dao.impl.ScheduleDaoImpl;
import com.studymate.model.Schedule;
import com.studymate.service.ScheduleService;

import java.sql.Time;
import java.util.*;

public class ScheduleServiceImpl implements ScheduleService {
    private final ScheduleDao scheduleDao;

    public ScheduleServiceImpl() {
        this.scheduleDao = new ScheduleDaoImpl();
    }

    @Override
    public List<Schedule> getSchedulesByUserId(int userId) {
        return scheduleDao.getSchedulesByUserId(userId);
    }

    @Override
    public Schedule getScheduleById(int scheduleId) {
        return scheduleDao.getScheduleById(scheduleId);
    }

    @Override
    public boolean createSchedule(Schedule schedule) {
        return validateSchedule(schedule) && scheduleDao.addSchedule(schedule);
    }

    @Override
    public boolean updateSchedule(Schedule schedule) {
        return validateSchedule(schedule) && scheduleDao.updateSchedule(schedule);
    }

    @Override
    public boolean deleteSchedule(int scheduleId) {
        return scheduleDao.deleteSchedule(scheduleId);
    }

    @Override
    public Map<String, List<Schedule>> getWeeklyScheduleGrid(int userId) {
        List<Schedule> schedules = scheduleDao.getSchedulesByUserId(userId);
        Map<String, List<Schedule>> weeklyGrid = new LinkedHashMap<>();
        String[] days = {"Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7", "Chủ nhật"};

        for (int i = 0; i < days.length; i++) {
            List<Schedule> daySchedules = new ArrayList<>();
            for (Schedule schedule : schedules) {
                if (schedule.getDayOfWeek() == (i + 1)) {
                    daySchedules.add(schedule);
                }
            }
            daySchedules.sort(Comparator.comparing(Schedule::getStartTime));
            weeklyGrid.put(days[i], daySchedules);
        }
        return weeklyGrid;
    }

    @Override
    public boolean validateSchedule(Schedule schedule) {
        if (schedule.getUserId() <= 0 ||
            schedule.getSubject() == null || schedule.getSubject().trim().isEmpty() ||
            schedule.getRoom() == null || schedule.getRoom().trim().isEmpty() ||
            schedule.getDayOfWeek() < 1 || schedule.getDayOfWeek() > 7 ||
            schedule.getStartTime() == null || schedule.getEndTime() == null) {
            return false;
        }
        if (schedule.getSubject().length() > 250 || schedule.getRoom().length() > 250) {
            return false;
        }
        if (schedule.getStartTime().compareTo(schedule.getEndTime()) >= 0) {
            return false;
        }
        Time minTime = Time.valueOf("07:00:00");
        Time maxTime = Time.valueOf("22:00:00");
        return !schedule.getStartTime().before(minTime) && !schedule.getEndTime().after(maxTime);
    }
}