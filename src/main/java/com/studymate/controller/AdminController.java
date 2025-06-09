package com.studymate.controller;

import com.studymate.model.User;
import com.studymate.service.UserService;
import com.studymate.service.UserServiceImpl;
import com.studymate.model.Post;
import com.studymate.service.PostService;
import com.studymate.service.PostServiceImpl;
import com.studymate.model.Report;
import com.studymate.service.ReportService;
import com.studymate.service.ReportServiceImpl;
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

    // GET admin login form
    @GetMapping("/admin/login")
    public String showAdminLogin(Model model, HttpServletRequest req) {
        model.addAttribute("csrfToken", req.getSession().getAttribute("csrfToken"));
        return "admin/login";  // WEB-INF/views/admin/login.jsp
    }

    // POST admin login
    @PostMapping("/admin/login")
    public String doAdminLogin(
        @RequestParam String email,
        @RequestParam String password,
        @RequestParam String csrfToken,
        HttpServletRequest request,
        Model model
    ) {
        try {
            User u = userService.login(email, password);
            if (u != null && "ADMIN".equals(u.getRole())) {
                // invalidate old session
                request.getSession().invalidate();
                HttpSession session = request.getSession(true);
                session.setAttribute("adminUser", u);
                return "redirect:/admin/dashboard";
            } else {
                model.addAttribute("error", "Email hoặc mật khẩu không đúng hoặc không có quyền ADMIN");
                model.addAttribute("csrfToken", request.getSession().getAttribute("csrfToken"));
                return "admin/login";
            }
        } catch (Exception ex) {
            model.addAttribute("error", ex.getMessage());
            model.addAttribute("csrfToken", request.getSession().getAttribute("csrfToken"));
            return "admin/login";
        }
    }

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
        List<Post> posts = postService.findAll();
        List<Report> reports = reportService.findAll();
        
        model.addAttribute("users", users);
        model.addAttribute("posts", posts);
        model.addAttribute("reports", reports);
        return "admin/dashboard";  // WEB-INF/views/admin/dashboard.jsp
    }
}
