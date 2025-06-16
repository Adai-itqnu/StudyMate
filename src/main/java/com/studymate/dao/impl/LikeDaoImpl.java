package com.studymate.dao.impl;

import com.studymate.dao.LikeDao;
import com.studymate.util.DBConnectionUtil;

import java.sql.*;

public class LikeDaoImpl implements LikeDao {
    private static final String INSERT_SQL = "INSERT INTO likes (user_id, post_id) VALUES (?, ?)";
    private static final String DELETE_SQL = "DELETE FROM likes WHERE user_id=? AND post_id=? AND comment_id IS NULL";
    private static final String COUNT_SQL = "SELECT COUNT(*) FROM likes WHERE post_id=? AND comment_id IS NULL";
    private static final String DELETE_BY_POST = "DELETE FROM likes WHERE post_id = ?";
    private static final String INSERT_COMMENT_LIKE_SQL = "INSERT INTO likes (user_id, comment_id) VALUES (?, ?)";
    private static final String DELETE_COMMENT_LIKE_SQL = "DELETE FROM likes WHERE user_id=? AND comment_id=?";
    private static final String COUNT_COMMENT_SQL = "SELECT COUNT(*) FROM likes WHERE comment_id=?";

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
    public boolean createCommentLike(int userId, int commentId) throws Exception {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_COMMENT_LIKE_SQL)) {
            ps.setInt(1, userId);
            ps.setInt(2, commentId);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean deleteCommentLike(int userId, int commentId) throws Exception {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_COMMENT_LIKE_SQL)) {
            ps.setInt(1, userId);
            ps.setInt(2, commentId);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public int countByComment(int commentId) throws Exception {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(COUNT_COMMENT_SQL)) {
            ps.setInt(1, commentId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }
}