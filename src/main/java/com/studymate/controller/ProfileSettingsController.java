package com.studymate.controller;

import com.studymate.model.User;
import com.studymate.service.UserService;
import com.studymate.service.impl.UserServiceImpl;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.text.SimpleDateFormat;
import java.util.Date;

@Controller
@RequestMapping("/profile/settings")
public class ProfileSettingsController {

    private final UserService userService = new UserServiceImpl();

    @GetMapping
    public String showSettings(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        model.addAttribute("user", currentUser);
        return "profile-settings";
    }

    @PostMapping("/update")
    public String updateProfile(
            @RequestParam String fullName,
            @RequestParam String username,
            @RequestParam String email,
            @RequestParam(required = false) String phone,
            @RequestParam(required = false) String bio,
            @RequestParam(required = false) String avatarUrl,
            @RequestParam(required = false) String dateOfBirth,
            @RequestParam(defaultValue = "0") int schoolId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return "redirect:/login";
            }

            // Validate input
            if (fullName == null || fullName.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Họ tên không được để trống");
                return "redirect:/profile/settings";
            }
            
            if (username == null || username.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Username không được để trống");
                return "redirect:/profile/settings";
            }
            
            if (email == null || email.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Email không được để trống");
                return "redirect:/profile/settings";
            }

            // Update user info
            currentUser.setFullName(fullName.trim());
            currentUser.setUsername(username.trim());
            currentUser.setEmail(email.trim());
            currentUser.setPhone(phone != null ? phone.trim() : null);
            currentUser.setBio(bio != null ? bio.trim() : null);
            currentUser.setAvatarUrl(avatarUrl != null ? avatarUrl.trim() : null);
            currentUser.setSchoolId(schoolId);

            // Parse date of birth
            if (dateOfBirth != null && !dateOfBirth.trim().isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date dob = sdf.parse(dateOfBirth);
                    currentUser.setDateOfBirth(dob);
                } catch (Exception e) {
                    redirectAttributes.addFlashAttribute("error", "Định dạng ngày sinh không hợp lệ");
                    return "redirect:/profile/settings";
                }
            }

            boolean success = userService.updateUser(currentUser);
            
            if (success) {
                // Update session
                session.setAttribute("currentUser", currentUser);
                redirectAttributes.addFlashAttribute("success", "Cập nhật thông tin thành công!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra khi cập nhật thông tin");
            }

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/profile/settings";
    }

    @PostMapping("/change-password")
    public String changePassword(
            @RequestParam String oldPassword,
            @RequestParam String newPassword,
            @RequestParam String confirmPassword,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return "redirect:/login";
            }

            // Validate input
            if (oldPassword == null || oldPassword.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("passwordError", "Mật khẩu cũ không được để trống");
                return "redirect:/profile/settings";
            }
            
            if (newPassword == null || newPassword.length() < 6) {
                redirectAttributes.addFlashAttribute("passwordError", "Mật khẩu mới phải có ít nhất 6 ký tự");
                return "redirect:/profile/settings";
            }
            
            if (!newPassword.equals(confirmPassword)) {
                redirectAttributes.addFlashAttribute("passwordError", "Mật khẩu mới và xác nhận mật khẩu không khớp");
                return "redirect:/profile/settings";
            }

            boolean success = userService.updatePassword(currentUser.getUserId(), oldPassword, newPassword);
            
            if (success) {
                redirectAttributes.addFlashAttribute("passwordSuccess", "Đổi mật khẩu thành công!");
            } else {
                redirectAttributes.addFlashAttribute("passwordError", "Có lỗi xảy ra khi đổi mật khẩu");
            }

        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("passwordError", e.getMessage());
        }

        return "redirect:/profile/settings";
    }
}