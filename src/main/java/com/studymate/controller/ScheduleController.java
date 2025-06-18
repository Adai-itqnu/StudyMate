package com.studymate.controller;

import com.studymate.model.Schedule;
import com.studymate.service.ScheduleService;
import com.studymate.service.impl.ScheduleServiceImpl;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/schedule")
public class ScheduleController {
    private final ScheduleService scheduleService;

    public ScheduleController() {
        this.scheduleService = new ScheduleServiceImpl();
    }

    @GetMapping
    public String showSchedulePage(Model model, HttpSession session,
                                   @RequestParam(value = "success", required = false) String success,
                                   @RequestParam(value = "error", required = false) String error) {
        try {
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) userId = 1; // Fallback for testing
            List<Schedule> schedules = scheduleService.getSchedulesByUserId(userId);
            Map<String, List<Schedule>> weeklyGrid = scheduleService.getWeeklyScheduleGrid(userId);
            model.addAttribute("schedules", schedules);
            model.addAttribute("weeklyGrid", weeklyGrid);
            model.addAttribute("userId", userId);
            if (success != null) model.addAttribute("success", success);
            if (error != null) model.addAttribute("error", error);
        } catch (Exception e) {
            model.addAttribute("error", "Không thể tải lịch học: " + e.getMessage());
        }
        return "schedule";
    }

    @GetMapping("/{scheduleId}")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getScheduleById(@PathVariable int scheduleId) {
        try {
            Schedule schedule = scheduleService.getScheduleById(scheduleId);
            if (schedule == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                                    .body(Map.of("error", "Lịch học không tồn tại"));
            }
            Map<String, Object> response = new HashMap<>();
            response.put("scheduleId", schedule.getScheduleId());
            response.put("subject", schedule.getSubject());
            response.put("room", schedule.getRoom());
            response.put("dayOfWeek", schedule.getDayOfWeek());
            response.put("startTime", schedule.getStartTime().toString().substring(0, 5));
            response.put("endTime", schedule.getEndTime().toString().substring(0, 5));
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                                .body(Map.of("error", "Lỗi khi lấy thông tin lịch học: " + e.getMessage()));
        }
    }

    @PostMapping("/add")
    public String addSchedule(@RequestParam("subject") String subject,
                             @RequestParam("room") String room,
                             @RequestParam("dayOfWeek") int dayOfWeek,
                             @RequestParam("startTime") String startTime,
                             @RequestParam("endTime") String endTime,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        try {
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) userId = 1; // Fallback for testing
            if (subject == null || subject.trim().isEmpty() || room == null || room.trim().isEmpty()) {
                throw new Exception("Môn học hoặc phòng không được để trống");
            }
            String normalizedStartTime = normalizeTime(startTime);
            String normalizedEndTime = normalizeTime(endTime);
            Schedule schedule = new Schedule(userId, subject.trim(), room.trim(), dayOfWeek,
                                            Time.valueOf(normalizedStartTime), Time.valueOf(normalizedEndTime));
            if (!scheduleService.validateSchedule(schedule)) {
                throw new Exception("Dữ liệu không hợp lệ: kiểm tra thời gian hoặc thông tin nhập vào");
            }
            if (!scheduleService.createSchedule(schedule)) {
                throw new Exception("Xung đột thời gian với lịch học hiện có");
            }
            redirectAttributes.addFlashAttribute("success", "Thêm lịch học thành công!");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi định dạng thời gian: " + e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/schedule";
    }

    @PostMapping("/update")
    public String updateSchedule(@RequestParam("scheduleId") int scheduleId,
                                @RequestParam("subject") String subject,
                                @RequestParam("room") String room,
                                @RequestParam("dayOfWeek") int dayOfWeek,
                                @RequestParam("startTime") String startTime,
                                @RequestParam("endTime") String endTime,
                                RedirectAttributes redirectAttributes) {
        try {
            Schedule schedule = scheduleService.getScheduleById(scheduleId);
            if (schedule == null) {
                throw new Exception("Lịch học không tồn tại");
            }
            if (subject == null || subject.trim().isEmpty() || room == null || room.trim().isEmpty()) {
                throw new Exception("Môn học hoặc phòng không được để trống");
            }
            String normalizedStartTime = normalizeTime(startTime);
            String normalizedEndTime = normalizeTime(endTime);
            schedule.setSubject(subject.trim());
            schedule.setRoom(room.trim());
            schedule.setDayOfWeek(dayOfWeek);
            schedule.setStartTime(Time.valueOf(normalizedStartTime));
            schedule.setEndTime(Time.valueOf(normalizedEndTime));
            if (!scheduleService.validateSchedule(schedule)) {
                throw new Exception("Dữ liệu không hợp lệ: kiểm tra thời gian hoặc thông tin nhập vào");
            }
            if (!scheduleService.updateSchedule(schedule)) {
                throw new Exception("Xung đột thời gian với lịch học hiện có");
            }
            redirectAttributes.addFlashAttribute("success", "Cập nhật lịch học thành công!");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi định dạng thời gian: " + e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/schedule";
    }

    @PostMapping("/delete")
    public String deleteSchedule(@RequestParam("scheduleId") int scheduleId,
                                RedirectAttributes redirectAttributes) {
        try {
            if (!scheduleService.deleteSchedule(scheduleId)) {
                throw new Exception("Không thể xóa lịch học");
            }
            redirectAttributes.addFlashAttribute("success", "Xóa lịch học thành công!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Lỗi: " + e.getMessage());
        }
        return "redirect:/schedule";
    }

    private String normalizeTime(String time) {
        if (time == null || time.trim().isEmpty()) {
            throw new IllegalArgumentException("Thời gian không được để trống");
        }
        if (time.matches("\\d{2}:\\d{2}:\\d{2}")) {
            return time;
        }
        if (time.matches("\\d{2}:\\d{2}")) {
            return time + ":00";
        }
        try {
            SimpleDateFormat inputFormat = new SimpleDateFormat("hh:mm a");
            SimpleDateFormat outputFormat = new SimpleDateFormat("HH:mm:ss");
            return outputFormat.format(inputFormat.parse(time));
        } catch (Exception e) {
            throw new IllegalArgumentException("Định dạng thời gian không hợp lệ: " + time);
        }
    }
}