package com.studymate.controller;

import com.studymate.model.Schedule;
import com.studymate.service.ScheduleService;
import com.studymate.service.impl.ScheduleServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Time;
import java.util.List;
import java.util.Map;

public class ScheduleController extends HttpServlet {
    private ScheduleService scheduleService;
    
    @Override
    public void init() throws ServletException {
        scheduleService = new ScheduleServiceImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "list":
                showScheduleList(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteSchedule(request, response);
                break;
            case "grid":
                showScheduleGrid(request, response);
                break;
            default:
                showScheduleList(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        switch (action) {
            case "add":
                addSchedule(request, response);
                break;
            case "update":
                updateSchedule(request, response);
                break;
            default:
                showScheduleList(request, response);
        }
    }
    
    private void showScheduleList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId != null) {
            List<Schedule> schedules = scheduleService.getSchedulesByUserId(userId);
            request.setAttribute("schedules", schedules);
        }
        
        request.getRequestDispatcher("/WEB-INF/views/schedule/list.jsp").forward(request, response);
    }
    
    private void showScheduleGrid(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        if (userId != null) {
            Map<String, List<Schedule>> weeklyGrid = scheduleService.getWeeklyScheduleGrid(userId);
            request.setAttribute("weeklyGrid", weeklyGrid);
        }
        
        request.getRequestDispatcher("/WEB-INF/views/schedule/grid.jsp").forward(request, response);
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/schedule/add.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int scheduleId = Integer.parseInt(request.getParameter("id"));
        Schedule schedule = scheduleService.getScheduleById(scheduleId);
        
        if (schedule != null) {
            request.setAttribute("schedule", schedule);
            request.getRequestDispatcher("/WEB-INF/views/schedule/edit.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/schedule?action=list");
        }
    }
    
    private void addSchedule(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            Schedule schedule = createScheduleFromRequest(request);
            
            if (scheduleService.createSchedule(schedule)) {
                request.setAttribute("message", "Thêm lịch học thành công!");
                response.sendRedirect(request.getContextPath() + "/schedule?action=grid");
            } else {
                request.setAttribute("error", "Không thể thêm lịch học. Có thể bị trung thời gian!");
                request.getRequestDispatcher("/WEB-INF/views/schedule/add.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ!");
            request.getRequestDispatcher("/WEB-INF/views/schedule/add.jsp").forward(request, response);
        }
    }
    
    private void updateSchedule(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            Schedule schedule = createScheduleFromRequest(request);
            schedule.setScheduleId(Integer.parseInt(request.getParameter("scheduleId")));
            
            if (scheduleService.updateSchedule(schedule)) {
                request.setAttribute("message", "Cập nhật lịch học thành công!");
                response.sendRedirect(request.getContextPath() + "/schedule?action=grid");
            } else {
                request.setAttribute("error", "Không thể cập nhật lịch học. Có thể bị trung thời gian!");
                request.setAttribute("schedule", schedule);
                request.getRequestDispatcher("/WEB-INF/views/schedule/edit.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Dữ liệu không hợp lệ!");
            showEditForm(request, response);
        }
    }
    
    private void deleteSchedule(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        int scheduleId = Integer.parseInt(request.getParameter("id"));
        
        if (scheduleService.deleteSchedule(scheduleId)) {
            request.setAttribute("message", "Xóa lịch học thành công!");
        } else {
            request.setAttribute("error", "Không thể xóa lịch học!");
        }
        
        response.sendRedirect(request.getContextPath() + "/schedule?action=grid");
    }
    
    private Schedule createScheduleFromRequest(HttpServletRequest request) {
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        
        Schedule schedule = new Schedule();
        schedule.setUserId(userId != null ? userId : 0);
        schedule.setSubjectId(Integer.parseInt(request.getParameter("subjectId")));
        schedule.setRoomId(Integer.parseInt(request.getParameter("roomId")));
        schedule.setDayOfWeek(Integer.parseInt(request.getParameter("dayOfWeek")));
        schedule.setStartTime(Time.valueOf(request.getParameter("startTime") + ":00"));
        schedule.setEndTime(Time.valueOf(request.getParameter("endTime") + ":00"));
        
        return schedule;
    }
}