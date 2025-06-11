package com.studymate.dao.impl;

import com.studymate.dao.ShareDao;
import com.studymate.model.Share;
import com.studymate.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ShareDaoImpl implements ShareDao {
    private static final String INSERT_SQL =
            "INSERT INTO shares (user_id, post_id, created_at) VALUES (?, ?, CURRENT_TIMESTAMP)";
    private static final String SELECT_BY_POST = "SELECT * FROM shares WHERE post_id=? ORDER BY created_at DESC";
    private static final String DELETE_BY_POST = "DELETE FROM shares WHERE post_id = ?";
    
    @Override
    public int create(Share share) throws Exception {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 INSERT_SQL, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, share.getUserId());
            ps.setInt(2, share.getPostId());
            int affected = ps.executeUpdate();
            if (affected == 0) throw new SQLException("Tạo share thất bại");
            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getInt(1) : -1;
            }
        }
    }

    @Override
    public List<Share> findByPostId(int postId) throws Exception {
        List<Share> list = new ArrayList<>();
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_POST)) {
            ps.setInt(1, postId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Share s = new Share();
                    s.setShareId(rs.getInt("share_id"));
                    s.setUserId(rs.getInt("user_id"));
                    s.setPostId(rs.getInt("post_id"));
                    s.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(s);
                }
            }
        }
        return list;
    }
    @Override
    public boolean deleteByPostId(int postId) throws Exception {
      try (Connection conn = DBConnectionUtil.getConnection();
           PreparedStatement ps = conn.prepareStatement(DELETE_BY_POST)) {
        ps.setInt(1, postId);
        return ps.executeUpdate() > 0;
      }
    }
}
