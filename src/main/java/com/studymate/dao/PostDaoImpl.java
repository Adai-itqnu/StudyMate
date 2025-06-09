package com.studymate.dao;

import com.studymate.dao.PostDao;
import com.studymate.model.Post;
import com.studymate.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PostDaoImpl implements PostDao {
    private static final String SELECT_ALL = "SELECT * FROM posts ORDER BY created_at DESC";
    private static final String DELETE_BY_ID = "DELETE FROM posts WHERE post_id = ?";

    @Override
    public List<Post> findAll() throws Exception {
        List<Post> list = new ArrayList<>();
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_ALL);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    @Override
    public boolean delete(int postId) throws Exception {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_BY_ID)) {
            ps.setInt(1, postId);
            return ps.executeUpdate() > 0;
        }
    }

    /** Ánh xạ ResultSet thành Post */
    private Post mapRow(ResultSet rs) throws SQLException {
        Post p = new Post();
        p.setPostId(rs.getInt("post_id"));
        p.setUserId(rs.getInt("user_id"));
        p.setTitle(rs.getString("title"));
        p.setBody(rs.getString("body"));
        p.setPrivacy(rs.getString("privacy"));
        p.setStatus(rs.getString("status"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        p.setUpdatedAt(rs.getTimestamp("updated_at"));
        return p;
    }
}
