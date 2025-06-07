package com.studymate.model;

import java.util.Date;
import org.springframework.security.crypto.bcrypt.BCrypt;

public class User {
    private int id;
    private String fullName;
    private String username;
    private String password;
    private String email;
    private String role;
    private String avatar;
    private String bio;
    private String phone;
    private Date dateOfBirth;
    private String school;
    private Date createdAt;
    private Date updatedAt;

    // Constructors
    public User() {}

    public User(int id, String fullName, String username, String email, String role) {
        this.id = id;
        this.fullName = fullName;
        this.username = username;
        this.email = email;
        this.role = role;
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    
    public void setPassword(String password) { 
        if (password != null && !password.trim().isEmpty()) {
            // Chỉ hash nếu password chưa được hash (không bắt đầu bằng $2a$)
            if (!password.startsWith("$2a$")) {
                this.password = BCrypt.hashpw(password, BCrypt.gensalt());
            } else {
                this.password = password; // Đã được hash rồi
            }
        }
    }
    
    // Method để set password đã được hash sẵn (dùng khi load từ DB)
    public void setHashedPassword(String hashedPassword) {
        this.password = hashedPassword;
    }
    
    // Static method to check password (since the original one required an instance)
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        if (plainPassword == null || hashedPassword == null) {
            return false;
        }
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            System.err.println("Error checking password: " + e.getMessage());
            return false;
        }
    }
    
    // Instance method to check password 
    public boolean checkPassword(String plainPassword) {
        return checkPassword(plainPassword, this.password);
    }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getSchool() { return school; }
    public void setSchool(String school) { this.school = school; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
    
    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", fullName='" + fullName + '\'' +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", role='" + role + '\'' +
                '}';
    }
}