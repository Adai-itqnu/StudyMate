package com.studymate.dao.impl;

import com.studymate.dao.CommentDao;
import com.studymate.model.Comment;
import com.studymate.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDaoImpl implements CommentDao {
    private static final String INSERT_SQL = "INSERT INTO comments (user_id, post_id, content) VALUES (?, ?, ?)";
    private static final String DELETE_SQL = "DELETE FROM comments WHERE comment_id=?";
    private static final String SELECT_BY_POST = "SELECT * FROM comments WHERE post_id=? ORDER BY created_at ASC";
    private static final String DELETE_BY_POST = "DELETE FROM comments WHERE post_id = ?";
    @Override
    public int create(Comment comment) throws Exception {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, comment.getUserId());
            ps.setInt(2, comment.getPostId());
            ps.setString(3, comment.getContent());
            int affected = ps.executeUpdate();
            if (affected == 0) throw new SQLException("Thêm bình luận thất bại");
            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getInt(1) : -1;
            }
        }
    }

    @Override
    public boolean delete(int commentId) throws Exception {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_SQL)) {
            ps.setInt(1, commentId);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public List<Comment> findByPostId(int postId) throws Exception {
        List<Comment> list = new ArrayList<>();
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_POST)) {
            ps.setInt(1, postId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Comment c = new Comment();
                    c.setCommentId(rs.getInt("comment_id"));
                    c.setUserId(rs.getInt("user_id"));
                    c.setPostId(rs.getInt("post_id"));
                    c.setContent(rs.getString("content"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(c);
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