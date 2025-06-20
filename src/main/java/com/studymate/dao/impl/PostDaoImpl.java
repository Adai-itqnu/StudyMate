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
    
    private static final String INSERT_SQL =
      "INSERT INTO posts (user_id, title, body, privacy, status) VALUES (?,?,?,?, 'PUBLISHED')";
    private static final String SELECT_ALL =
      "SELECT * FROM posts ORDER BY created_at DESC";
    private static final String DELETE_ATTACHMENTS_SQL = "DELETE FROM attachments WHERE post_id = ?";
    private static final String DELETE_POST_SQL = "DELETE FROM posts WHERE post_id = ?";

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
        }	
        return posts;
    }
    
    @Override
    public boolean delete(int postId) throws Exception {
        Connection conn = null;
        try {
            conn = DBConnectionUtil.getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction
            
            
            // Bước 2: Xóa comments (nếu có foreign key constraint) 
            try (PreparedStatement psComments = conn.prepareStatement("DELETE FROM comments WHERE post_id = ?")) {
                psComments.setInt(1, postId);
                psComments.executeUpdate();
            }
            
            // Bước 3: Xóa likes (nếu có foreign key constraint)
            try (PreparedStatement psLikes = conn.prepareStatement("DELETE FROM likes WHERE post_id = ?")) {
                psLikes.setInt(1, postId);
                psLikes.executeUpdate();
            }
            
            // Bước 4: Xóa attachments
            try (PreparedStatement psAttachments = conn.prepareStatement(DELETE_ATTACHMENTS_SQL)) {
                psAttachments.setInt(1, postId);
                psAttachments.executeUpdate();
            }
            
            // Bước 5: Xóa post
            try (PreparedStatement psPost = conn.prepareStatement(DELETE_POST_SQL)) {
                psPost.setInt(1, postId);
                int result = psPost.executeUpdate();
                
                if (result > 0) {
                    conn.commit(); // Commit transaction nếu thành công
                    return true;
                } else {
                    conn.rollback(); // Rollback nếu không xóa được post
                    return false;
                }
            }
            
        } catch (Exception e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback nếu có lỗi
                } catch (SQLException rollbackEx) {
                    // Log rollback exception
                    e.addSuppressed(rollbackEx);
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Restore auto-commit
                    conn.close();
                } catch (SQLException closeEx) {
                    // Log close exception but don't throw
                    System.err.println("Error closing connection: " + closeEx.getMessage());
                }
            }
        }
    }
    
    @Override
    public Post findById(int postId) {
        Post post = null;
        String sql = "SELECT * FROM posts WHERE post_id = ?";
        
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, postId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                post = new Post();
                post.setPostId(postId);
                post.setTitle(rs.getString("title"));
                post.setBody(rs.getString("body"));
                post.setCreatedAt(rs.getTimestamp("created_at"));
                // Thêm các field cần thiết khác
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return post;
    }

}
