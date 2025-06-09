package com.studymate.controller;

import com.studymate.model.User;
import com.studymate.service.UserService;
import com.studymate.service.UserServiceImpl;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class AuthController {
	private final UserService userService = new UserServiceImpl();

  @GetMapping("/register")
  public String showRegister(Model model, HttpServletRequest req) {
      model.addAttribute("csrfToken", req.getSession().getAttribute("csrfToken"));
      return "register";
  }

  @PostMapping("/register")
  public String doRegister(
      @RequestParam String fullName,
      @RequestParam String username,
      @RequestParam String email,
      @RequestParam(required=false) String phone,
      @RequestParam(required=false) @DateTimeFormat(iso=DateTimeFormat.ISO.DATE) Date dateOfBirth,
      @RequestParam String password,
      @RequestParam String confirmPassword,
      @RequestParam String csrfToken,
      Model model,
      HttpServletRequest req
  ) {
      try {
          // CSRF token đã được CsrfFilter kiểm tra trước

          // 1. Kiểm tra mật khẩu khớp
          if (!password.equals(confirmPassword)) {
              throw new Exception("Mật khẩu và xác nhận mật khẩu không khớp");
          }

          // 2. Tạo user object
          User u = new User();
          u.setFullName(fullName);
          u.setUsername(username);
          u.setEmail(email);
          u.setPhone(phone);
          u.setDateOfBirth(dateOfBirth);
          u.setPassword(password);      // service sẽ hash
          u.setRole("USER");
          u.setStatus("ACTIVE");

          // 3. Gọi service đăng ký
          userService.register(u);

          model.addAttribute("message", "Đăng ký thành công! Vui lòng đăng nhập.");
          return "login";
      } catch (Exception e) {
          model.addAttribute("error", e.getMessage());
          // Giữ lại giá trị Người dùng đã nhập
          model.addAttribute("fullName", fullName);
          model.addAttribute("username", username);
          model.addAttribute("email", email);
          model.addAttribute("phone", phone);
          model.addAttribute("dateOfBirth", new SimpleDateFormat("yyyy-MM-dd").format(dateOfBirth));
          model.addAttribute("csrfToken", req.getSession().getAttribute("csrfToken"));
          return "register";
      }
  }

  @GetMapping("/login")
  public String showLogin(Model m, HttpSession s) {
    m.addAttribute("csrfToken", s.getAttribute("csrfToken"));
    return "login";
  }

  @PostMapping("/login")
  public String doLogin(
      @RequestParam String email,
      @RequestParam String password,
      @RequestParam String csrfToken,
      HttpServletRequest request,  
      Model model
  ) {
      try {
          User u = userService.login(email, password);
          if (u != null) {
              // 1. Đánh dấu session cũ hết hiệu lực
              request.getSession().invalidate();
              // 2. Tạo session mới
              HttpSession newSession = request.getSession(true);
              newSession.setAttribute("currentUser", u);
              return "redirect:/";
          } else {
              model.addAttribute("error", "Sai email hoặc mật khẩu");
              // Lấy lại token CSRF để hiển thị form
              model.addAttribute("csrfToken", request.getSession().getAttribute("csrfToken"));
              return "login";
          }
      } catch (Exception ex) {
          model.addAttribute("error", ex.getMessage());
          model.addAttribute("csrfToken", request.getSession().getAttribute("csrfToken"));
          return "login";
      }
  }


  @GetMapping("/logout")
  public String logout(HttpSession session) {
    session.invalidate();
    return "redirect:/login";
  }
}