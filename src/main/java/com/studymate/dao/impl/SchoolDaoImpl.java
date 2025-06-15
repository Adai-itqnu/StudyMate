package com.studymate.dao.impl;

import com.studymate.dao.SchoolDao;
import com.studymate.model.School;
import com.studymate.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SchoolDaoImpl implements SchoolDao {

    @Override
    public List<School> getAllSchools() {
        List<School> schools = new ArrayList<>();
        String sql = "SELECT school_id, name FROM schools ORDER BY name";
        
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                School school = new School();
                school.setSchoolId(rs.getInt("school_id"));
                school.setName(rs.getString("name"));
                schools.add(school);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting all schools: " + e.getMessage());
            e.printStackTrace();
        }
        
        return schools;
    }

    @Override
    public School getSchoolById(int schoolId) {
        String sql = "SELECT school_id, name FROM schools WHERE school_id = ?";
        
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, schoolId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                School school = new School();
                school.setSchoolId(rs.getInt("school_id"));
                school.setName(rs.getString("name"));
                return school;
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting school by id: " + e.getMessage());
            e.printStackTrace();
        }
        
        return null;
    }

    @Override
    public boolean addSchool(School school) {
        String sql = "INSERT INTO schools (name) VALUES (?)";
        
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, school.getName());
            int rowsAffected = stmt.executeUpdate();
            
            if (rowsAffected > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    school.setSchoolId(generatedKeys.getInt(1));
                }
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("Error adding school: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }

    @Override
    public boolean updateSchool(School school) {
        String sql = "UPDATE schools SET name = ? WHERE school_id = ?";
        
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, school.getName());
            stmt.setInt(2, school.getSchoolId());
            
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating school: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }

    @Override
    public boolean deleteSchool(int schoolId) {
        String sql = "DELETE FROM schools WHERE school_id = ?";
        
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, schoolId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Error deleting school: " + e.getMessage());
            e.printStackTrace();
        }
        
        return false;
    }
}