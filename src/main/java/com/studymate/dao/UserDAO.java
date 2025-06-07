package com.studymate.dao;

import com.studymate.model.User;
import com.studymate.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

@Repository
public class UserDAO {

    public boolean registerUser(User user) {
        try (Connection conn = DBConnection.getConnection()) {
            // Kiểm tra username đã tồn tại chưa
            String checkUsername = "SELECT COUNT(*) FROM users WHERE username = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkUsername);
            checkStmt.setString(1, user.getUsername());
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return false; // Username đã tồn tại
            }
            
            // Kiểm tra email đã tồn tại chưa
            String checkEmail = "SELECT COUNT(*) FROM users WHERE email = ?";
            checkStmt = conn.prepareStatement(checkEmail);
            checkStmt.setString(1, user.getEmail());
            rs = checkStmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return false; // Email đã tồn tại
            }
            
            // Thêm người dùng mới với đầy đủ các trường
            String sql = "INSERT INTO users (full_name, username, password, email, phone, date_of_birth, role) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getUsername());
            stmt.setString(3, user.getPassword()); // Password đã được hash trong model User.java
            stmt.setString(4, user.getEmail());
            stmt.setString(5, user.getPhone()); // Thêm số điện thoại
            
            // Xử lý ngày sinh
            if (user.getDateOfBirth() != null) {
                stmt.setDate(6, new java.sql.Date(user.getDateOfBirth().getTime()));
            } else {
                stmt.setNull(6, Types.DATE);
            }
            
            stmt.setString(7, user.getRole() == null ? "STUDENT" : user.getRole());
            
            int row = stmt.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public User login(String username, String password) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM users WHERE username = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String storedPassword = rs.getString("password");
                if (User.checkPassword(password, storedPassword)) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setUsername(rs.getString("username"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone")); // Thêm phone
                    
                    // Xử lý date_of_birth
                    Date dateOfBirth = rs.getDate("date_of_birth");
                    if (dateOfBirth != null) {
                        user.setDateOfBirth(new java.util.Date(dateOfBirth.getTime()));
                    }
                    
                    user.setRole(rs.getString("role"));
                    user.setBio(rs.getString("bio"));
                    user.setAvatar(rs.getString("avatar"));
                    user.setSchool(rs.getString("school"));
                    return user;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public User getUserById(int userId) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM users WHERE id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone")); // Thêm phone
                
                // Xử lý date_of_birth
                Date dateOfBirth = rs.getDate("date_of_birth");
                if (dateOfBirth != null) {
                    user.setDateOfBirth(new java.util.Date(dateOfBirth.getTime()));
                }
                
                user.setRole(rs.getString("role"));
                user.setBio(rs.getString("bio"));
                user.setAvatar(rs.getString("avatar"));
                user.setSchool(rs.getString("school"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public User getUserByUsername(String username) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM users WHERE username = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                
                Date dateOfBirth = rs.getDate("date_of_birth");
                if (dateOfBirth != null) {
                    user.setDateOfBirth(new java.util.Date(dateOfBirth.getTime()));
                }
                
                user.setRole(rs.getString("role"));
                user.setBio(rs.getString("bio"));
                user.setAvatar(rs.getString("avatar"));
                user.setSchool(rs.getString("school"));
                return user;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public boolean followUser(int followingId, int followedId) {
        try (Connection conn = DBConnection.getConnection()) {
            // Kiểm tra đã follow chưa
            String checkSql = "SELECT COUNT(*) FROM follows WHERE following_user_id = ? AND followed_user_id = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, followingId);
            checkStmt.setInt(2, followedId);
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return false; // Đã follow rồi
            }
            
            // Thêm mối quan hệ follow
            String sql = "INSERT INTO follows (following_user_id, followed_user_id) VALUES (?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, followingId);
            stmt.setInt(2, followedId);
            int row = stmt.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean unfollowUser(int followingId, int followedId) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "DELETE FROM follows WHERE following_user_id = ? AND followed_user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, followingId);
            stmt.setInt(2, followedId);
            int row = stmt.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public List<User> getFollowers(int userId) {
        List<User> followers = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT u.* FROM users u " +
                         "JOIN follows f ON u.id = f.following_user_id " +
                         "WHERE f.followed_user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                
                Date dateOfBirth = rs.getDate("date_of_birth");
                if (dateOfBirth != null) {
                    user.setDateOfBirth(new java.util.Date(dateOfBirth.getTime()));
                }
                
                user.setAvatar(rs.getString("avatar"));
                followers.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return followers;
    }
    
    public List<User> getFollowing(int userId) {
        List<User> following = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT u.* FROM users u " +
                         "JOIN follows f ON u.id = f.followed_user_id " +
                         "WHERE f.following_user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                
                Date dateOfBirth = rs.getDate("date_of_birth");
                if (dateOfBirth != null) {
                    user.setDateOfBirth(new java.util.Date(dateOfBirth.getTime()));
                }
                
                user.setAvatar(rs.getString("avatar"));
                following.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return following;
    }
    
    public boolean isFollowing(int followingId, int followedId) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT COUNT(*) FROM follows WHERE following_user_id = ? AND followed_user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, followingId);
            stmt.setInt(2, followedId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<User> searchUsers(String keyword) {
        List<User> users = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM users WHERE username LIKE ? OR full_name LIKE ? LIMIT 20";
            PreparedStatement stmt = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPhone(rs.getString("phone"));
                
                Date dateOfBirth = rs.getDate("date_of_birth");
                if (dateOfBirth != null) {
                    user.setDateOfBirth(new java.util.Date(dateOfBirth.getTime()));
                }
                
                user.setAvatar(rs.getString("avatar"));
                users.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return users;
    }
}