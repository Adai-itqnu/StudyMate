package com.studymate.dao.impl;

import com.studymate.dao.PostDao;
import com.studymate.model.Post;
import com.studymate.util.DBConnectionUtil;

import com.studymate.dao.*;
import com.studymate.model.*;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PostDaoImpl implements PostDao {
	
    private final AttachmentDao attachmentDao = new AttachmentDaoImpl();
    private final LikeDao likeDao             = new LikeDaoImpl();
    private final CommentDao commentDao       = new CommentDaoImpl();
    private final ShareDao shareDao           = new ShareDaoImpl();
    private static final String INSERT_SQL =
      "INSERT INTO posts (user_id, title, body, privacy, status) VALUES (?,?,?,?, 'PUBLISHED')";
    private static final String SELECT_ALL =
      "SELECT * FROM posts ORDER BY created_at DESC";
    private static final String DELETE_SQL       = "DELETE FROM posts WHERE post_id = ?";

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
    
    @Override
    public List<Post> findAllWithDetails() throws Exception {
        // 1) Lấy list cơ bản
        List<Post> posts = findAll();
        // 2) Với mỗi post nạp thêm chi tiết
        for (Post p : posts) {
            int pid = p.getPostId();
            // attachments
            p.setAttachments(attachmentDao.findByPostId(pid));
            // like count
            p.setLikeCount(likeDao.countByPostId(pid));
            // comments + count
            List<Comment> cmts = commentDao.findByPostId(pid);
            p.setComments(cmts);
            p.setCommentCount(cmts.size());
            // shares
            p.setShares(shareDao.findByPostId(pid));
        }
        return posts;
    }
    @Override
    public boolean delete(int postId) throws Exception {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(DELETE_SQL)) {
            ps.setInt(1, postId);
            return ps.executeUpdate() > 0;
        }
    }
}
