package com.studymate.dao.impl;

import com.studymate.dao.PostDao;
import com.studymate.model.Post;
import com.studymate.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PostDaoImpl implements PostDao {
    private static final String INSERT_SQL =
      "INSERT INTO posts (user_id, title, body, privacy, status) VALUES (?,?,?,?, 'PUBLISHED')";
    private static final String SELECT_ALL =
      "SELECT * FROM posts ORDER BY created_at DESC";

    @Override
    public int create(Post post) throws Exception {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 INSERT_SQL, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, post.getUserId());
            ps.setString(2, post.getTitle());
            ps.setString(3, post.getBody());
            ps.setString(4, post.getPrivacy());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getInt(1) : -1;
            }
        }
    }

    @Override
    public List<Post> findAll() throws Exception {
        List<Post> list = new ArrayList<>();
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Post p = new Post();
                p.setPostId(rs.getInt("post_id"));
                p.setUserId(rs.getInt("user_id"));
                p.setTitle(rs.getString("title"));
                p.setBody(rs.getString("body"));
                p.setPrivacy(rs.getString("privacy"));
                p.setStatus(rs.getString("status"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(p);
            }
        }
        return list;
    }
}
