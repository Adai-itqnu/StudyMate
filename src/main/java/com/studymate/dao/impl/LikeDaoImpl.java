package com.studymate.dao.impl;

import com.studymate.dao.LikeDao;
import com.studymate.util.DBConnectionUtil;

import java.sql.*;

public class LikeDaoImpl implements LikeDao {
    private static final String INSERT_SQL = "INSERT INTO likes (user_id, post_id) VALUES (?, ?)";
    private static final String DELETE_SQL = "DELETE FROM likes WHERE user_id=? AND post_id=?";
    private static final String COUNT_SQL  = "SELECT COUNT(*) FROM likes WHERE post_id=?";
    private static final String DELETE_BY_POST = "DELETE FROM likes WHERE post_id = ?";
    @Override
    public boolean create(int userId, int postId) throws Exception {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {
            ps.setInt(1, userId);
            ps.setInt(2, postId);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(int userId, int postId) throws Exception {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_SQL)) {
            ps.setInt(1, userId);
            ps.setInt(2, postId);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public int countByPost(int postId) throws Exception {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT_SQL)) {
            ps.setInt(1, postId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    @Override
    public int countByPostId(int pid) {
        try {
            return countByPost(pid);
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
    
    @Override
    public boolean deleteByPostId(int postId) throws Exception {
      try (Connection conn = DBConnectionUtil.getConnection();
           PreparedStatement ps = conn.prepareStatement(DELETE_BY_POST)) {
        ps.setInt(1, postId);
        return ps.executeUpdate() > 0;
      }
    }
   
    @Override
    public boolean toggleLike(int userId, int postId) {
        try {
            if (isLiked(userId, postId)) {
                // Unlike
                String sql = "DELETE FROM likes WHERE user_id = ? AND post_id = ?";
                try (Connection conn = DBConnectionUtil.getConnection();
                     PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    
                    pstmt.setInt(1, userId);
                    pstmt.setInt(2, postId);
                    return pstmt.executeUpdate() > 0;
                }
            } else {
                // Like
                String sql = "INSERT INTO likes (user_id, post_id) VALUES (?, ?)";
                try (Connection conn = DBConnectionUtil.getConnection();
                     PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    
                    pstmt.setInt(1, userId);
                    pstmt.setInt(2, postId);
                    return pstmt.executeUpdate() > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean isLiked(int userId, int postId) {
        String sql = "SELECT COUNT(*) FROM likes WHERE user_id = ? AND post_id = ?";
        
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            pstmt.setInt(2, postId);
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    @Override
    public int getLikeCount(int postId) {
        String sql = "SELECT COUNT(*) FROM likes WHERE post_id = ?";
        
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, postId);
            
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
}
