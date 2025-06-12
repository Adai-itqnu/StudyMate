package com.studymate.controller;

import com.studymate.model.User;
import com.studymate.service.UserService;
import com.studymate.service.impl.UserServiceImpl;
import com.studymate.model.Post;
import com.studymate.service.PostService;
import com.studymate.service.impl.PostServiceImpl;
import com.studymate.model.Report;
import com.studymate.service.ReportService;
import com.studymate.service.impl.ReportServiceImpl;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class AdminController {
    private final UserService userService = new UserServiceImpl();
    private final PostService postService = new PostServiceImpl();
    private final ReportService reportService = new ReportServiceImpl();

    // Admin dashboard
    @GetMapping("/admin/dashboard")
    public String adminDashboard(HttpSession session, Model model) throws Exception {
        // Kiểm tra quyền
        User admin = (User) session.getAttribute("adminUser");
        if (admin == null) {
            return "redirect:/admin/login";
        }
        // Lấy danh sách users, posts, reports
        List<User> users = userService.findAll();
    //    List<Post> posts = postService.findAllWithDetails();
        List<Report> reports = reportService.findAll();
        
        model.addAttribute("users", users);
   //     model.addAttribute("posts", posts);
        model.addAttribute("reports", reports);
        return "admin/dashboard";  // WEB-INF/views/admin/dashboard.jsp
    }
}
