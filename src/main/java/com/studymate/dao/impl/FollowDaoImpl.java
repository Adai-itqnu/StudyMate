package com.studymate.dao.impl;

import com.studymate.dao.FollowDao;
import com.studymate.model.User;
import com.studymate.util.DBConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FollowDaoImpl implements FollowDao {
    private static final String INSERT_SQL = "INSERT INTO follows (follower_id, followee_id) VALUES (?, ?)";
    private static final String DELETE_SQL = "DELETE FROM follows WHERE follower_id=? AND followee_id=?";
    private static final String SELECT_FOLLOWERS =
        "SELECT u.* FROM users u JOIN follows f ON u.user_id=f.follower_id WHERE f.followee_id=?";
    private static final String SELECT_FOLLOWEES =
        "SELECT u.* FROM users u JOIN follows f ON u.user_id=f.followee_id WHERE f.follower_id=?";
    private static final String CHECK_FOLLOWING = 
        "SELECT COUNT(*) FROM follows WHERE follower_id=? AND followee_id=?";

    @Override
    public boolean create(int followerId, int followeeId) throws Exception {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL)) {
            ps.setInt(1, followerId);
            ps.setInt(2, followeeId);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(int followerId, int followeeId) throws Exception {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_SQL)) {
            ps.setInt(1, followerId);
            ps.setInt(2, followeeId);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public List<User> findFollowers(int userId) throws Exception {
        List<User> list = new ArrayList<>();
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_FOLLOWERS)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }

    @Override
    public List<User> findFollowees(int userId) throws Exception {
        List<User> list = new ArrayList<>();
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_FOLLOWEES)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }
        return list;
    }
    
    @Override
    public boolean isFollowing(int followerId, int followeeId) throws Exception {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(CHECK_FOLLOWING)) {
            ps.setInt(1, followerId);
            ps.setInt(2, followeeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setFullName(rs.getString("fullname"));
        u.setUsername(rs.getString("username"));
        u.setEmail(rs.getString("email"));
        u.setAvatarUrl(rs.getString("avatar_url"));
        return u;
    }
}