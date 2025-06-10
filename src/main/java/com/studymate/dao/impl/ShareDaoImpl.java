package com.studymate.dao.impl;

import com.studymate.dao.ShareDao;
import com.studymate.model.Share;
import com.studymate.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ShareDaoImpl implements ShareDao {
    private static final String INSERT_SQL = "INSERT INTO shares (user_id, post_id) VALUES (?, ?)";
    private static final String SELECT_BY_POST = "SELECT * FROM shares WHERE post_id=? ORDER BY created_at DESC";

    @Override
    public int create(int userId, int postId) throws Exception {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, userId);
            ps.setInt(2, postId);
            int affected = ps.executeUpdate();
            if (affected == 0) throw new SQLException("Chia sẻ thất bại");
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
}
