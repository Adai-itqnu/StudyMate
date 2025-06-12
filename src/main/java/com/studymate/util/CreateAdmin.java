package com.studymate.util;

import com.studymate.model.User;
import com.studymate.service.UserService;
import com.studymate.service.impl.UserServiceImpl;
import java.text.SimpleDateFormat;

public class CreateAdmin {
    
    public static void main(String[] args) {
        try {
            UserService userService = new UserServiceImpl();
            
            // Kiểm tra admin đã tồn tại chưa
            try {
                User existingAdmin = userService.login("admin@studymate.com", "admin123");
                if (existingAdmin != null) {
                    System.out.println("✅ Admin đã tồn tại, có thể đăng nhập!");
                    System.out.println("Email: admin@studymate.com");
                    System.out.println("Password: admin123");
                    return;
                }
            } catch (Exception e) {
                // Admin chưa tồn tại, tiếp tục tạo
            }
            
            // Tạo admin mới
            User admin = new User();
            admin.setFullName("Admin StudyMate");
            admin.setUsername("admin");
            admin.setEmail("admin@studymate.com");
            admin.setPassword("admin123"); // Sẽ được hash tự động trong register()
            admin.setRole("ADMIN");
            admin.setStatus("ACTIVE");
            admin.setSystemAdmin(true);
            admin.setPhone("0123456789");
            admin.setBio("Quản trị viên hệ thống");
            
            // Set ngày sinh
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            admin.setDateOfBirth(sdf.parse("1990-01-01"));
            
            // Tạo admin
            int adminId = userService.register(admin);
            
            System.out.println("🎉 Tạo admin thành công!");
            System.out.println("ID: " + adminId);
            System.out.println("Email: admin@studymate.com");
            System.out.println("Password: admin123");
            System.out.println("Role: ADMIN");
            System.out.println("System Admin: true");
            
            // Test đăng nhập
            User loginTest = userService.login("admin@studymate.com", "admin123");
            if (loginTest != null) {
                System.out.println("✅ Test đăng nhập thành công!");
            } else {
                System.out.println("❌ Test đăng nhập thất bại!");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Lỗi khi tạo admin: " + e.getMessage());
            e.printStackTrace();
        }
    }
}