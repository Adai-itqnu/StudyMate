package com.studymate.repository;

import com.studymate.model.Admin;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class AdminRepository {
    
    private JdbcTemplate jdbcTemplate;
    
    public void setJdbcTemplate(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }
    
    private final RowMapper<Admin> adminRowMapper = new RowMapper<Admin>() {
        @Override
        public Admin mapRow(ResultSet rs, int rowNum) throws SQLException {
            Admin admin = new Admin();
            admin.setId(rs.getInt("id"));
            admin.setUserId(rs.getInt("user_id"));
            admin.setAdminLevel(rs.getString("admin_level"));
            admin.setPermissions(rs.getString("permissions"));
            admin.setLastLogin(rs.getTimestamp("last_login").toLocalDateTime());
            admin.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
            admin.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
            return admin;
        }
    };
    
    public List<Admin> findAll() {
        String sql = "SELECT * FROM system_admins";
        return jdbcTemplate.query(sql, adminRowMapper);
    }
    
    public Optional<Admin> findById(int id) {
        String sql = "SELECT * FROM system_admins WHERE id = ?";
        List<Admin> admins = jdbcTemplate.query(sql, adminRowMapper, id);
        return admins.isEmpty() ? Optional.empty() : Optional.of(admins.get(0));
    }
    
    public Optional<Admin> findByUserId(int userId) {
        String sql = "SELECT * FROM system_admins WHERE user_id = ?";
        List<Admin> admins = jdbcTemplate.query(sql, adminRowMapper, userId);
        return admins.isEmpty() ? Optional.empty() : Optional.of(admins.get(0));
    }
    
    public void save(Admin admin) {
        String sql = "INSERT INTO system_admins (user_id, admin_level, permissions, last_login) " +
                    "VALUES (?, ?, ?, ?)";
        jdbcTemplate.update(sql, 
            admin.getUserId(),
            admin.getAdminLevel(),
            admin.getPermissions(),
            admin.getLastLogin()
        );
    }
    
    public void update(Admin admin) {
        String sql = "UPDATE system_admins SET admin_level = ?, permissions = ?, last_login = ? " +
                    "WHERE id = ?";
        jdbcTemplate.update(sql,
            admin.getAdminLevel(),
            admin.getPermissions(),
            admin.getLastLogin(),
            admin.getId()
        );
    }
    
    public void delete(int id) {
        String sql = "DELETE FROM system_admins WHERE id = ?";
        jdbcTemplate.update(sql, id);
    }
    
    public void updateLastLogin(int adminId) {
        String sql = "UPDATE system_admins SET last_login = CURRENT_TIMESTAMP WHERE id = ?";
        jdbcTemplate.update(sql, adminId);
    }
}