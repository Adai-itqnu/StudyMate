package com.studymate.service.impl;

import com.studymate.dao.ScheduleDao;
import com.studymate.dao.impl.ScheduleDaoImpl;
import com.studymate.model.Schedule;
import com.studymate.service.ScheduleService;

import java.sql.Time;
import java.util.*;

public class ScheduleServiceImpl implements ScheduleService {
    private ScheduleDao scheduleDAO;
    
    public ScheduleServiceImpl() {
        this.scheduleDAO = new ScheduleDaoImpl();
    }
    
    @Override
    public List<Schedule> getAllSchedules() {
        return scheduleDAO.getAllSchedules();
    }
    
    @Override
    public List<Schedule> getSchedulesByUserId(int userId) {
        return scheduleDAO.getSchedulesByUserId(userId);
    }
    
    @Override
    public Schedule getScheduleById(int scheduleId) {
        return scheduleDAO.getScheduleById(scheduleId);
    }
    
    @Override
    public boolean createSchedule(Schedule schedule) {
        if (!validateSchedule(schedule)) {
            return false;
        }
        return scheduleDAO.addSchedule(schedule);
    }
    
    @Override
    public boolean updateSchedule(Schedule schedule) {
        if (!validateSchedule(schedule)) {
            return false;
        }
        return scheduleDAO.updateSchedule(schedule);
    }
    
    @Override
    public boolean deleteSchedule(int scheduleId) {
        return scheduleDAO.deleteSchedule(scheduleId);
    }
    
    @Override
    public Map<String, List<Schedule>> getWeeklyScheduleGrid(int userId) {
        List<Schedule> allSchedules = scheduleDAO.getSchedulesByUserId(userId);
        Map<String, List<Schedule>> weeklyGrid = new LinkedHashMap<>();
        
        String[] days = {"Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7"};
        
        for (int i = 0; i < days.length; i++) {
            List<Schedule> daySchedules = new ArrayList<>();
            for (Schedule schedule : allSchedules) {
                if (schedule.getDayOfWeek() == (i + 2)) { // Thứ 2 = 2, Thứ 3 = 3, etc.
                    daySchedules.add(schedule);
                }
            }
            // Sắp xếp theo thời gian bắt đầu
            daySchedules.sort((s1, s2) -> s1.getStartTime().compareTo(s2.getStartTime()));
            weeklyGrid.put(days[i], daySchedules);
        }
        
        return weeklyGrid;
    }
    
    @Override
    public boolean validateSchedule(Schedule schedule) {
        // Kiểm tra dữ liệu cơ bản
        if (schedule.getUserId() <= 0 || schedule.getSubjectId() <= 0 || 
            schedule.getRoomId() <= 0 || schedule.getDayOfWeek() < 2 || 
            schedule.getDayOfWeek() > 7) {
            return false;
        }
        
        // Kiểm tra thời gian
        if (schedule.getStartTime() == null || schedule.getEndTime() == null) {
            return false;
        }
        
        if (schedule.getStartTime().compareTo(schedule.getEndTime()) >= 0) {
            return false;
        }
        
        // Kiểm tra thời gian trong khung giờ học hợp lý (7:00 - 22:00)
        Time minTime = Time.valueOf("07:00:00");
        Time maxTime = Time.valueOf("22:00:00");
        
        if (schedule.getStartTime().before(minTime) || 
            schedule.getEndTime().after(maxTime)) {
            return false;
        }
        
        return true;
    }
    
    @Override
    public List<Schedule> getSchedulesByDay(int userId, int dayOfWeek) {
        List<Schedule> allSchedules = scheduleDAO.getSchedulesByUserId(userId);
        List<Schedule> daySchedules = new ArrayList<>();
        
        for (Schedule schedule : allSchedules) {
            if (schedule.getDayOfWeek() == dayOfWeek) {
                daySchedules.add(schedule);
            }
        }
        
        // Sắp xếp theo thời gian
        daySchedules.sort((s1, s2) -> s1.getStartTime().compareTo(s2.getStartTime()));
        return daySchedules;
    }
}