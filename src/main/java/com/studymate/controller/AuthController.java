package com.studymate.controller;

import com.studymate.model.User;
import com.studymate.service.UserService;
import com.studymate.service.impl.UserServiceImpl;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class AuthController {
    private final UserService userService = new UserServiceImpl();

    @GetMapping("/login")
    public String loginForm() {
        return "login";
    }

    @PostMapping("/login")
    public String doLogin(
        @RequestParam String username,
        @RequestParam String password,
        HttpServletRequest request,
        Model model
    ) {
        try {
            User u = userService.login(username, password);	
            if (u != null) {
                request.getSession().invalidate();
                HttpSession newSession = request.getSession(true);
                newSession.setAttribute("currentUser", u);
                
                // Kiểm tra quyền admin (cả role và systemAdmin)
                if ("ADMIN".equals(u.getRole()) || u.isSystemAdmin()) {
                    // Set thêm adminUser cho AdminController
                    newSession.setAttribute("adminUser", u);
                    return "redirect:/admin/dashboard";
                }
                
                // User thường
                return "redirect:/dashboard";
            } else {
                model.addAttribute("error", "Email hoặc mật khẩu không đúng");
                return "login";
            }
        } catch (Exception ex) {
            model.addAttribute("error", ex.getMessage());
            return "login";
        }
    }

    @GetMapping("/register")
    public String registerForm() {
        return "register";
    }

    @PostMapping("/register")
    public String doRegister(
        @RequestParam String fullName,
        @RequestParam String username,
        @RequestParam String email,
        @RequestParam(required=false) String phone,
        @RequestParam(required=false) @DateTimeFormat(pattern="yyyy-MM-dd") String dateOfBirth,
        @RequestParam String password,
        @RequestParam String confirmPassword,
        Model model
    ) {
        try {
            // Validation
            if (fullName == null || fullName.trim().isEmpty()) {
                throw new Exception("Họ và tên không được để trống");
            }
            if (username == null || username.trim().isEmpty()) {
                throw new Exception("Username không được để trống");
            }
            if (email == null || email.trim().isEmpty()) {
                throw new Exception("Email không được để trống");
            }
            if (password == null || password.trim().isEmpty()) {
                throw new Exception("Mật khẩu không được để trống");
            }
            if (!password.equals(confirmPassword)) {
                throw new Exception("Mật khẩu không khớp");
            }
            
            User u = new User();
            u.setFullName(fullName.trim());
            u.setUsername(username.trim());
            u.setEmail(email.trim());
            u.setPhone(phone != null ? phone.trim() : null);
            
            // Xử lý date of birth
            if (dateOfBirth != null && !dateOfBirth.trim().isEmpty()) {
                try {
                    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
                    Date dob = sdf.parse(dateOfBirth);
                    u.setDateOfBirth(dob);
                } catch (Exception e) {
                    throw new Exception("Định dạng ngày sinh không hợp lệ");
                }
            }
            
            u.setPassword(password);
            u.setRole("USER");
            u.setStatus("ACTIVE");
            
            userService.register(u);
            model.addAttribute("message", "Đăng ký thành công. Mời đăng nhập!");
            return "login";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            // Giữ lại dữ liệu đã nhập
            model.addAttribute("fullName", fullName);
            model.addAttribute("username", username);
            model.addAttribute("email", email);
            model.addAttribute("phone", phone);
            model.addAttribute("dateOfBirth", dateOfBirth);
            return "register";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}