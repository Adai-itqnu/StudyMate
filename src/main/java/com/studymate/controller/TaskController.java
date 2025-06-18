package com.studymate.controller;

import com.studymate.dao.impl.TaskDaoImpl;
import com.studymate.model.Task;
import com.studymate.service.TaskService;
import com.studymate.service.impl.TaskServiceImpl;
import com.studymate.util.DBConnectionUtil;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/tasks")
public class TaskController extends HttpServlet {
    private TaskService taskService;

    @Override
    public void init() throws ServletException {
        try {
            // Sử dụng DBConnectionUtil để lấy connection
            Connection connection = DBConnectionUtil.getConnection();
            
            // Khởi tạo DAO và Service
            TaskDaoImpl taskDao = new TaskDaoImpl(connection);
            this.taskService = new TaskServiceImpl(taskDao);
            
            System.out.println("TaskController initialized successfully");
            
        } catch (SQLException e) {
            System.err.println("Cannot initialize TaskService: " + e.getMessage());
            throw new ServletException("Cannot initialize TaskService: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Set encoding để xử lý tiếng Việt
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        
        // Lấy userId từ session (sửa phần này)
        HttpSession session = req.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            userId = 1; // fallback cho testing
        }
        
        try {
            List<Task> todoTasks = taskService.getTasksByUser(userId, false);
            List<Task> doneTasks = taskService.getTasksByUser(userId, true);
            
            System.out.println("TODO tasks: " + todoTasks.size());
            System.out.println("DONE tasks: " + doneTasks.size());
            
            req.setAttribute("todoTasks", todoTasks);
            req.setAttribute("doneTasks", doneTasks);
            
            // Thêm success message nếu có
            String success = req.getParameter("success");
            if (success != null) {
                req.setAttribute("success", success);
            }
            
        } catch (Exception e) {
            System.err.println("Error loading tasks: " + e.getMessage());
            req.setAttribute("error", "Không thể tải danh sách task: " + e.getMessage());
            e.printStackTrace();
        }
        
        RequestDispatcher dispatcher = req.getRequestDispatcher("/WEB-INF/views/task.jsp");
        dispatcher.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Set encoding để xử lý tiếng Việt
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        
        String action = req.getParameter("action");
        
        // Lấy userId từ session
        HttpSession session = req.getSession();
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            userId = 1; // fallback cho testing
        }
        
        System.out.println("Action received: " + action);
        
        String redirectUrl = req.getContextPath() + "/tasks";
        
        try {
            switch (action) {
                case "add":
                    handleAddTask(req, userId);
                    redirectUrl += "?success=" + java.net.URLEncoder.encode("Tạo task thành công!", "UTF-8");
                    break;
                    
                case "update":
                    handleUpdateTask(req);
                    redirectUrl += "?success=" + java.net.URLEncoder.encode("Cập nhật task thành công!", "UTF-8");
                    break;
                    
                case "delete":
                    handleDeleteTask(req);
                    redirectUrl += "?success=" + java.net.URLEncoder.encode("Xóa task thành công!", "UTF-8");
                    break;
                    
                case "pin":
                    String pinMessage = handlePinTask(req, userId);
                    redirectUrl += "?success=" + java.net.URLEncoder.encode(pinMessage, "UTF-8");
                    break;
                    
                case "complete":
                    handleCompleteTask(req);
                    redirectUrl += "?success=" + java.net.URLEncoder.encode("Đánh dấu hoàn thành task thành công!", "UTF-8");
                    break;
                    
                case "uncomplete":
                    handleUncompleteTask(req);
                    redirectUrl += "?success=" + java.net.URLEncoder.encode("Chuyển task về TODO thành công!", "UTF-8");
                    break;
                    
                default:
                    redirectUrl += "?error=" + java.net.URLEncoder.encode("Hành động không hợp lệ!", "UTF-8");
                    break;
            }
            
        } catch (NumberFormatException e) {
            System.err.println("Number format error: " + e.getMessage());
            redirectUrl += "?error=" + java.net.URLEncoder.encode("Dữ liệu không hợp lệ!", "UTF-8");
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("Error processing request: " + e.getMessage());
            redirectUrl += "?error=" + java.net.URLEncoder.encode("Lỗi: " + e.getMessage(), "UTF-8");
            e.printStackTrace();
        }
        
        // Redirect để tránh duplicate submission
        resp.sendRedirect(redirectUrl);
    }
    
    private void handleAddTask(HttpServletRequest req, int userId) throws Exception {
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String dueDateStr = req.getParameter("dueDate");
        
        System.out.println("Creating task - Title: " + title + ", Description: " + description + ", DueDate: " + dueDateStr);
        
        // Validate required fields
        if (title == null || title.trim().isEmpty()) {
            throw new Exception("Tên task không được để trống");
        }
        
        if (title.trim().length() > 255) {
            throw new Exception("Tên task không được vượt quá 255 ký tự");
        }
        
        if (description != null && description.trim().length() > 500) {
            throw new Exception("Mô tả không được vượt quá 500 ký tự");
        }
        
        // Tạo task mới
        Task task = new Task();
        task.setUserId(userId);
        task.setTitle(title.trim());
        task.setDescription(description != null ? description.trim() : "");
        task.setStatus("PENDING");
        task.setPinned(false);
        task.setCreatedAt(new Date());
        task.setUpdatedAt(new Date());
        
        // Xử lý due date
        if (dueDateStr != null && !dueDateStr.trim().isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date dueDate = sdf.parse(dueDateStr);
                task.setDueDate(dueDate);
                System.out.println("Due date parsed: " + dueDate);
            } catch (ParseException e) {
                System.out.println("Date parsing error: " + e.getMessage());
                // Không throw exception, chỉ set null
                task.setDueDate(null);
            }
        } else {
            task.setDueDate(null);
        }
        
        taskService.addTask(task);
        System.out.println("Task created successfully with ID: " + task.getTaskId());
    }
    
    private void handleUpdateTask(HttpServletRequest req) throws Exception {
        String taskIdStr = req.getParameter("taskId");
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            throw new Exception("Task ID không hợp lệ");
        }
        
        int taskId = Integer.parseInt(taskIdStr);
        Task task = taskService.getTaskById(taskId);
        
        if (task == null) {
            throw new Exception("Task không tồn tại");
        }
        
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String dueDateStr = req.getParameter("dueDate");
        
        System.out.println("Updating task - ID: " + taskId + ", Title: " + title + ", Description: " + description + ", DueDate: " + dueDateStr);
        
        if (title == null || title.trim().isEmpty()) {
            throw new Exception("Tên task không được để trống");
        }
        
        if (title.trim().length() > 255) {
            throw new Exception("Tên task không được vượt quá 255 ký tự");
        }
        
        if (description != null && description.trim().length() > 500) {
            throw new Exception("Mô tả không được vượt quá 500 ký tự");
        }
        
        task.setTitle(title.trim());
        task.setDescription(description != null ? description.trim() : "");
        
        // Xử lý due date
        if (dueDateStr != null && !dueDateStr.trim().isEmpty()) {
            try {
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date dueDate = sdf.parse(dueDateStr);
                task.setDueDate(dueDate);
                System.out.println("Due date updated: " + dueDate);
            } catch (ParseException e) {
                System.out.println("Date parsing error: " + e.getMessage());
                // Không throw exception, giữ nguyên due date cũ
            }
        } else {
            task.setDueDate(null);
        }
        
        task.setUpdatedAt(new Date());
        taskService.updateTask(task);
        System.out.println("Task updated successfully: " + taskId);
    }
    
    private void handleDeleteTask(HttpServletRequest req) throws Exception {
        String taskIdStr = req.getParameter("taskId");
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            throw new Exception("Task ID không hợp lệ");
        }
        
        int taskId = Integer.parseInt(taskIdStr);
        
        // Kiểm tra task tồn tại
        Task task = taskService.getTaskById(taskId);
        if (task == null) {
            throw new Exception("Task không tồn tại");
        }
        
        taskService.deleteTask(taskId);
        System.out.println("Task deleted successfully: " + taskId);
    }
    
    private String handlePinTask(HttpServletRequest req, int userId) throws Exception {
        String taskIdStr = req.getParameter("taskId");
        String pinnedStr = req.getParameter("pinned");
        
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            throw new Exception("Task ID không hợp lệ");
        }
        
        if (pinnedStr == null) {
            throw new Exception("Trạng thái ghim không hợp lệ");
        }
        
        int taskId = Integer.parseInt(taskIdStr);
        boolean pinned = Boolean.parseBoolean(pinnedStr);
        
        System.out.println("Pin task - ID: " + taskId + ", Pinned: " + pinned + ", User: " + userId);
        
        // Kiểm tra task tồn tại
        Task task = taskService.getTaskById(taskId);
        if (task == null) {
            throw new Exception("Task không tồn tại");
        }
        
        // Kiểm tra quyền sở hữu task
        if (task.getUserId() != userId) {
            throw new Exception("Bạn không có quyền thực hiện thao tác này");
        }
        
        // Nếu đang ghim, kiểm tra số lượng task đã ghim
//        if (pinned) {
//            List<Task> pinnedTasks = taskService.getPinnedTasksByUser(userId);
//            if (pinnedTasks.size() >= 3) {
//                throw new Exception("Bạn chỉ có thể ghim tối đa 3 task!");
//            }
//        }
        
        taskService.pinTask(taskId, pinned, userId);
        System.out.println("Task pin status updated successfully");
        
        return pinned ? "Ghim task thành công!" : "Bỏ ghim task thành công!";
    }
    
    private void handleCompleteTask(HttpServletRequest req) throws Exception {
        String taskIdStr = req.getParameter("taskId");
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            throw new Exception("Task ID không hợp lệ");
        }
        
        int taskId = Integer.parseInt(taskIdStr);
        Task task = taskService.getTaskById(taskId);
        
        if (task == null) {
            throw new Exception("Task không tồn tại");
        }
        
        if ("DONE".equals(task.getStatus())) {
            throw new Exception("Task đã được hoàn thành trước đó");
        }
        
        task.setStatus("DONE");
        task.setUpdatedAt(new Date());
        taskService.updateTask(task);
        System.out.println("Task completed successfully: " + taskId);
    }
    
    private void handleUncompleteTask(HttpServletRequest req) throws Exception {
        String taskIdStr = req.getParameter("taskId");
        if (taskIdStr == null || taskIdStr.trim().isEmpty()) {
            throw new Exception("Task ID không hợp lệ");
        }
        
        int taskId = Integer.parseInt(taskIdStr);
        Task task = taskService.getTaskById(taskId);
        
        if (task == null) {
            throw new Exception("Task không tồn tại");
        }
        
        if ("PENDING".equals(task.getStatus())) {
            throw new Exception("Task đang ở trạng thái chưa hoàn thành");
        }
        
        task.setStatus("PENDING");
        task.setUpdatedAt(new Date());
        taskService.updateTask(task);
        System.out.println("Task uncompleted successfully: " + taskId);
    }
}