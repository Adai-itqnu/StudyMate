package com.studymate.service;

import com.studymate.model.Admin;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class AdminService {
    
    @Autowired(required = false)
    private JdbcTemplate jdbcTemplate;
    
    private BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
    
    // Mock data cho testing
    private List<Admin> mockAdmins = new ArrayList<>();
    
    public AdminService() {
        // Khởi tạo mock data
        Admin admin = new Admin();
        admin.setId(1);
        admin.setUserId(1);
        admin.setAdminLevel("SUPER_ADMIN");
        admin.setCreatedAt(LocalDateTime.now());
        admin.setUpdatedAt(LocalDateTime.now());
        mockAdmins.add(admin);
    }
    
    public List<Admin> getAllAdmins() {
        return mockAdmins;
    }
    
    public Optional<Admin> getAdminById(int id) {
        return mockAdmins.stream()
                .filter(admin -> admin.getId() == id)
                .findFirst();
    }
    
    public Optional<Admin> getAdminByUserId(int userId) {
        return mockAdmins.stream()
                .filter(admin -> admin.getUserId() == userId)
                .findFirst();
    }
    
    public void createAdmin(Admin admin) {
        admin.setCreatedAt(LocalDateTime.now());
        admin.setUpdatedAt(LocalDateTime.now());
        mockAdmins.add(admin);
    }
    
    public void updateAdmin(Admin admin) {
        admin.setUpdatedAt(LocalDateTime.now());
        // Update logic here
    }
    
    public void deleteAdmin(int id) {
        mockAdmins.removeIf(admin -> admin.getId() == id);
    }
    
    public void updateLastLogin(int adminId) {
        // Update last login logic
    }
    
    public boolean hasPermission(int adminId, String permission) {
        Optional<Admin> adminOpt = getAdminById(adminId);
        if (adminOpt.isPresent()) {
            Admin admin = adminOpt.get();
            return "SUPER_ADMIN".equals(admin.getAdminLevel());
        }
        return false;
    }
    
    public boolean authenticate(String username, String password) {
        try {
            if (jdbcTemplate != null) {
                // Authenticate với database
                String sql = "SELECT password FROM users WHERE username = ? AND is_system_admin = TRUE AND status = 'ACTIVE'";
                
                List<String> passwords = jdbcTemplate.query(sql, 
                    (rs, rowNum) -> rs.getString("password"), 
                    username);
                
                if (!passwords.isEmpty()) {
                    String hashedPassword = passwords.get(0);
                    return passwordEncoder.matches(password, hashedPassword);
                }
            }
        } catch (Exception e) {
            System.err.println("Database authentication failed: " + e.getMessage());
            // Fallback to hardcoded for testing
        }
        
        // Fallback authentication cho testing
        return "admin".equals(username) && "dai06092004".equals(password);
    }
}