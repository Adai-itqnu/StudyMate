package com.studymate.controller;

import com.studymate.model.School;
import com.studymate.model.User;
import com.studymate.service.SchoolService;
import com.studymate.service.UserService;
import com.studymate.service.impl.SchoolServiceImpl;
import com.studymate.service.impl.UserServiceImpl;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("/profile/settings")
public class ProfileSettingsController {

    private final UserService userService;
    private final SchoolService schoolService;

    public ProfileSettingsController() {
        this.userService = new UserServiceImpl();
        this.schoolService = new SchoolServiceImpl();
    }

    @GetMapping
    public String showSettings(HttpSession session, Model model) {
        System.out.println("ProfileSettingsController: showSettings method called");
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            System.out.println("User not found in session, redirecting to login");
            return "redirect:/login";
        }
        
        try {
            // Lấy danh sách trường học từ database
            List<School> schools = schoolService.getAllSchools();
            if (schools == null || schools.isEmpty()) {
                System.out.println("No schools found, creating empty list");
                schools = new java.util.ArrayList<>();
            }
            
            System.out.println("Loading profile settings for user: " + currentUser.getUsername());
            System.out.println("Found " + schools.size() + " schools");
            
            model.addAttribute("user", currentUser);
            model.addAttribute("schools", schools);
            
        } catch (Exception e) {
            System.err.println("Error loading schools: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("user", currentUser);
            model.addAttribute("schools", new java.util.ArrayList<>());
        }
        
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
        
        System.out.println("ProfileSettingsController: updateProfile method called");
        System.out.println("Selected school ID: " + schoolId);
        
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

            // Email format validation
            if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
                redirectAttributes.addFlashAttribute("error", "Email không hợp lệ");
                return "redirect:/profile/settings";
            }

            // Validate school ID nếu cần
            if (schoolId > 0) {
                try {
                    School selectedSchool = schoolService.getSchoolById(schoolId);
                    if (selectedSchool == null) {
                        redirectAttributes.addFlashAttribute("error", "Trường học được chọn không hợp lệ");
                        return "redirect:/profile/settings";
                    }
                } catch (Exception e) {
                    System.err.println("Error validating school: " + e.getMessage());
                    redirectAttributes.addFlashAttribute("error", "Lỗi khi kiểm tra thông tin trường học");
                    return "redirect:/profile/settings";
                }
            }

            // Update user info
            currentUser.setFullName(fullName.trim());
            currentUser.setUsername(username.trim());
            currentUser.setEmail(email.trim());
            currentUser.setPhone(phone != null && !phone.trim().isEmpty() ? phone.trim() : null);
            currentUser.setBio(bio != null && !bio.trim().isEmpty() ? bio.trim() : null);
            currentUser.setAvatarUrl(avatarUrl != null && !avatarUrl.trim().isEmpty() ? avatarUrl.trim() : null);
            currentUser.setSchoolId(schoolId);

            // Parse date of birth
            if (dateOfBirth != null && !dateOfBirth.trim().isEmpty()) {
                try {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date dob = sdf.parse(dateOfBirth);
                    currentUser.setDateOfBirth(dob);
                } catch (Exception e) {
                    System.err.println("Error parsing date: " + e.getMessage());
                    redirectAttributes.addFlashAttribute("error", "Định dạng ngày sinh không hợp lệ");
                    return "redirect:/profile/settings";
                }
            }

            // Set updated timestamp
            currentUser.setUpdatedAt(new Date());

            boolean success = userService.updateUser(currentUser);
            
            if (success) {
                // Update session
                session.setAttribute("currentUser", currentUser);
                redirectAttributes.addFlashAttribute("success", "Cập nhật thông tin thành công!");
                
                // Log tên trường học để debug
                if (schoolId > 0) {
                    try {
                        School selectedSchool = schoolService.getSchoolById(schoolId);
                        if (selectedSchool != null) {
                            System.out.println("User updated school to: " + selectedSchool.getName());
                        }
                    } catch (Exception e) {
                        System.err.println("Error logging school name: " + e.getMessage());
                    }
                }
            } else {
                redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra khi cập nhật thông tin");
            }

        } catch (Exception e) {
            System.err.println("Error updating profile: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Lỗi hệ thống: " + e.getMessage());
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
        
        System.out.println("ProfileSettingsController: changePassword method called");
        
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
                redirectAttributes.addFlashAttribute("passwordError", "Mật khẩu cũ không đúng hoặc có lỗi xảy ra");
            }

        } catch (Exception e) {
            System.err.println("Error changing password: " + e.getMessage());
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("passwordError", "Lỗi hệ thống: " + e.getMessage());
        }

        return "redirect:/profile/settings";
    }
}