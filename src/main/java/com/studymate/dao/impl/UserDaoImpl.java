package com.studymate.dao.impl;

import com.studymate.dao.UserDao;
import com.studymate.model.User;
import com.studymate.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDaoImpl implements UserDao {
    @Override
    public int create(User user) throws Exception {
        String sql = "INSERT INTO users " +
                     "(fullname, username, password, role, avatar_url, bio, phone, email, date_of_birth, school_id, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getUsername());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole());
            ps.setString(5, user.getAvatarUrl());
            ps.setString(6, user.getBio());
            ps.setString(7, user.getPhone());
            ps.setString(8, user.getEmail());
            if (user.getDateOfBirth() != null) {
                ps.setDate(9, new java.sql.Date(user.getDateOfBirth().getTime()));
            } else {
                ps.setNull(9, Types.DATE);
            }
            // Nếu schoolId <= 0 (không chọn), gán NULL để tránh lỗi FK
            if (user.getSchoolId() > 0) {
                ps.setInt(10, user.getSchoolId());
            } else {
                ps.setNull(10, Types.INTEGER);
            }
            ps.setString(11, user.getStatus());

            int affected = ps.executeUpdate();
            if (affected == 0) throw new SQLException("Tạo user thất bại, không có dòng nào bị ảnh hưởng");
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                } else {
                    throw new SQLException("Tạo user thất bại, không lấy được ID");
                }
            }
        }
    }

    @Override
    public boolean update(User user) throws Exception {
        String sql = "UPDATE users SET fullname=?, username=?, password=?, role=?, avatar_url=?, bio=?, phone=?, email=?, date_of_birth=?, school_id=?, status=? " +
                     "WHERE user_id=?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getUsername());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole());
            ps.setString(5, user.getAvatarUrl());
            ps.setString(6, user.getBio());
            ps.setString(7, user.getPhone());
            ps.setString(8, user.getEmail());
            if (user.getDateOfBirth() != null) {
                ps.setDate(9, new java.sql.Date(user.getDateOfBirth().getTime()));
            } else {
                ps.setNull(9, Types.DATE);
            }
            // Xử lý optional school_id
            if (user.getSchoolId() > 0) {
                ps.setInt(10, user.getSchoolId());
            } else {
                ps.setNull(10, Types.INTEGER);
            }
            ps.setString(11, user.getStatus());
            ps.setInt(12, user.getUserId());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(int userId) throws Exception {
        String sql = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public User findById(int userId) throws Exception {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToUser(rs);
                }
                return null;
            }
        }
    }

    @Override
    public User findByEmail(String email) throws Exception {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRowToUser(rs);
                }
                return null;
            }
        }
    }

    @Override
    public List<User> findAll() throws Exception {
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        List<User> list = new ArrayList<>();
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRowToUser(rs));
            }
        }
        return list;
    }

    private User mapRowToUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setFullName(rs.getString("fullname"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setRole(rs.getString("role"));
        u.setAvatarUrl(rs.getString("avatar_url"));
        u.setBio(rs.getString("bio"));
        u.setPhone(rs.getString("phone"));
        u.setEmail(rs.getString("email"));
        u.setDateOfBirth(rs.getDate("date_of_birth"));
        // Nếu cột school_id là NULL, getInt trả về 0
        int sid = rs.getInt("school_id");
        u.setSchoolId(rs.wasNull() ? 0 : sid);
        u.setCreatedAt(rs.getTimestamp("created_at"));
        u.setUpdatedAt(rs.getTimestamp("updated_at"));
        u.setStatus(rs.getString("status"));
        u.setSystemAdmin(rs.getBoolean("is_system_admin")); // admin
        return u;
    }
}
