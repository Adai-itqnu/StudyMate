package com.studymate.dao.impl;

import com.studymate.dao.LikeDao;
import com.studymate.util.DBConnectionUtil;

import java.sql.*;

public class LikeDaoImpl implements LikeDao {
    private static final String INSERT_SQL = "INSERT INTO likes (user_id, post_id) VALUES (?, ?)";
    private static final String DELETE_SQL = "DELETE FROM likes WHERE user_id=? AND post_id=?";
    private static final String COUNT_SQL  = "SELECT COUNT(*) FROM likes WHERE post_id=?";

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
}