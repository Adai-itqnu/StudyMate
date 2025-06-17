package com.studymate.controller;

import com.studymate.model.Task;
import com.studymate.service.TaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/tasks")
public class TaskController {
    
    @Autowired
    private TaskService taskService;
    
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
    
    /**
     * Hiển thị trang chính với danh sách tasks
     */
    @GetMapping
    public String listTasks(Model model, @RequestParam(defaultValue = "1") int userId) {
        try {
            List<Task> allTasks = taskService.getAllTasksByUserId(userId);
            List<Task> completedTasks = taskService.getCompletedTasksByUserId(userId);
            List<Task> incompleteTasks = taskService.getIncompleteTasksByUserId(userId);
            List<Task> pinnedTasks = taskService.getPinnedTasksByUserId(userId);
            
            model.addAttribute("allTasks", allTasks);
            model.addAttribute("completedTasks", completedTasks);
            model.addAttribute("incompleteTasks", incompleteTasks);
            model.addAttribute("pinnedTasks", pinnedTasks);
            model.addAttribute("userId", userId);
            model.addAttribute("newTask", new Task());
            
            return "tasks/index";
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Có lỗi xảy ra khi tải danh sách tasks!");
            return "error";
        }
    }
    
    /**
     * Tạo task mới
     */
    @PostMapping("/create")
    public String createTask(@ModelAttribute Task task, 
                           @RequestParam(required = false) String dueDateStr,
                           @RequestParam(defaultValue = "1") int userId,
                           RedirectAttributes redirectAttributes) {
        try {
            // Parse due date if provided
            if (dueDateStr != null && !dueDateStr.trim().isEmpty()) {
                Date dueDate = dateFormat.parse(dueDateStr);
                task.setDueDate(dueDate);
            }
            
            task.setUserId(userId);
            task.setStatus("TODO");
            task.setCreatedAt(new Date());
            task.setUpdatedAt(new Date());
            
            taskService.createTask(task);
            redirectAttributes.addFlashAttribute("successMessage", "Task đã được tạo thành công!");
            
        } catch (ParseException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Định dạng ngày không hợp lệ!");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Có lỗi xảy ra khi tạo task!");
        }
        
        return "redirect:/tasks?userId=" + userId;
    }
    
    /**
     * Tạo subtask
     */
//    @PostMapping("/createSubtask")
//    public String createSubtask(@ModelAttribute Task subtask,
//                              @RequestParam(required = false) String dueDateStr,
//                              @RequestParam int parentId,
//                              @RequestParam(defaultValue = "1") int userId,
//                              RedirectAttributes redirectAttributes) {
//        try {
//            // Parse due date if provided
//            if (dueDateStr != null && !dueDateStr.trim().isEmpty()) {
//                Date dueDate = dateFormat.parse(dueDateStr);
//                subtask.setDueDate(dueDate);
//            }
//            
//            subtask.setUserId(userId);
//            subtask.setParentId(parentId);
//            subtask.setStatus("TODO");
//            subtask.setCreatedAt(new Date());
//            subtask.setUpdatedAt(new Date());
//            
//            taskService.createTask(subtask);
//            redirectAttributes.addFlashAttribute("successMessage", "Subtask đã được tạo thành công!");
//            
//        } catch (ParseException e) {
//            redirectAttributes.addFlashAttribute("errorMessage", "Định dạng ngày không hợp lệ!");
//        }
//    }
}