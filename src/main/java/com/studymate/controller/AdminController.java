package com.studymate.controller;

import com.studymate.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin")
public class AdminController {
    
    @Autowired
    private AdminService adminService;
    
    // Login page - GET
    @GetMapping("/login")
    public String showLoginPage(HttpSession session) {
        // Nếu đã login rồi thì redirect về dashboard
        if (Boolean.TRUE.equals(session.getAttribute("adminLoggedIn"))) {
            return "redirect:/admin/dashboard";
        }
        return "admin/admin_login";
    }
    
    // Login process - POST
    @PostMapping("/login")
    public String processLogin(@RequestParam("username") String username, 
                             @RequestParam("password") String password,
                             Model model, 
                             HttpSession session) {
        
        if (adminService.authenticate(username, password)) {
            session.setAttribute("adminLoggedIn", true);
            session.setAttribute("adminUsername", username);
            return "redirect:/admin/dashboard";
        } else {
            model.addAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng!");
            return "admin/admin_login";
        }
    }
    
    // Dashboard - GET
    @GetMapping("/dashboard")
    public String showDashboard(Model model, HttpSession session) {
        if (!isAuthenticated(session)) {
            return "redirect:/admin/login";
        }
        
        // Mock data
        model.addAttribute("totalUsers", 100);
        model.addAttribute("totalPosts", 250);
        model.addAttribute("pendingReports", 5);
        model.addAttribute("pendingTeachers", 3);
        
        return "admin/admin_home";
    }
    
    // Logout - GET
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
        return "redirect:/admin/login";
    }
    
    private boolean isAuthenticated(HttpSession session) {
        return session != null && Boolean.TRUE.equals(session.getAttribute("adminLoggedIn"));
    }
}