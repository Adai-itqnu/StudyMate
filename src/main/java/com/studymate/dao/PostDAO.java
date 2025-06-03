package com.studymate.dao;

import com.studymate.model.Post;
import com.studymate.model.Comment;
import com.studymate.model.User;
import com.studymate.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;

@Repository
public class PostDAO {
    
    /**
     * Lấy danh sách bài đăng cho trang dashboard
     * @param limit Số lượng bài đăng cần lấy
     * @return Danh sách bài đăng
     */
    public List<Post> getRecentPosts(int limit) {
        List<Post> posts = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT p.*, u.username, u.full_name, u.avatar, " +
                         "(SELECT COUNT(*) FROM post_likes WHERE post_id = p.id) AS like_count, " +
                         "(SELECT COUNT(*) FROM post_comments WHERE post_id = p.id) AS comment_count " +
                         "FROM forum_posts p " +
                         "JOIN users u ON p.user_id = u.id " +
                         "ORDER BY p.created_at DESC LIMIT ?";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Post post = new Post();
                post.setId(rs.getInt("id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setFilePath(rs.getString("file_path"));
                post.setFileType(rs.getString("file_type"));
                post.setViewCount(rs.getInt("view_count"));
                post.setCreatedAt(rs.getTimestamp("created_at"));
                post.setLikeCount(rs.getInt("like_count"));
                post.setCommentCount(rs.getInt("comment_count"));
                
                // Thông tin người đăng
                User user = new User();
                user.setId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setAvatar(rs.getString("avatar"));
                post.setUser(user);
                
                // Lấy comments cho bài đăng
           //     post.setComments(getCommentsForPost(post.getId(), 2, conn)); // Lấy 2 comments mới nhất
                
                posts.add(post);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return posts;
    }
    
    /**
     * Lấy danh sách bài đăng của người dùng và những người họ theo dõi
     * @param userId ID của người dùng hiện tại
     * @param limit Số lượng bài đăng cần lấy
     * @return Danh sách bài đăng
     */
    public List<Post> getFeedPosts(int userId, int limit) {
        List<Post> posts = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT p.*, u.username, u.full_name, u.avatar, " +
                         "(SELECT COUNT(*) FROM post_likes WHERE post_id = p.id) AS like_count, " +
                         "(SELECT COUNT(*) FROM post_comments WHERE post_id = p.id) AS comment_count " +
                         "FROM forum_posts p " +
                         "JOIN users u ON p.user_id = u.id " +
                         "WHERE p.user_id = ? OR p.user_id IN (SELECT followed_user_id FROM follows WHERE following_user_id = ?) " +
                         "ORDER BY p.created_at DESC LIMIT ?";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setInt(2, userId);
            stmt.setInt(3, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Post post = new Post();
                post.setId(rs.getInt("id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setFilePath(rs.getString("file_path"));
                post.setFileType(rs.getString("file_type"));
                post.setViewCount(rs.getInt("view_count"));
                post.setCreatedAt(rs.getTimestamp("created_at"));
                post.setLikeCount(rs.getInt("like_count"));
                post.setCommentCount(rs.getInt("comment_count"));
                
                // Thông tin người đăng
                User user = new User();
                user.setId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setAvatar(rs.getString("avatar"));
                post.setUser(user);
                
                // Lấy comments cho bài đăng
             //   post.setComments(getCommentsForPost(post.getId(), 2, conn)); // Lấy 2 comments mới nhất
                
                posts.add(post);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return posts;
    }
    
    /**
     * Lấy danh sách bình luận cho một bài đăng
     * @param postId ID của bài đăng
     * @param limit Số lượng bình luận cần lấy
     * @param conn Connection đến database (để tái sử dụng connection)
     * @return Danh sách bình luận
     */
    private List<Comment> getCommentsForPost(int postId, int limit, Connection conn) {
        List<Comment> comments = new ArrayList<>();
        try {
            String sql = "SELECT c.*, u.username, u.full_name, u.avatar " +
                         "FROM post_comments c " +
                         "JOIN users u ON c.user_id = u.id " +
                         "WHERE c.post_id = ? " +
                         "ORDER BY c.created_at DESC LIMIT ?";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, postId);
            stmt.setInt(2, limit);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Comment comment = new Comment();
                comment.setId(rs.getInt("id"));
                comment.setContent(rs.getString("content"));
                comment.setCreatedAt(rs.getTimestamp("created_at"));
                
                // Thông tin người bình luận
                User user = new User();
                user.setId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setFullName(rs.getString("full_name"));
                user.setAvatar(rs.getString("avatar"));
                comment.setUser(user);
                
                comments.add(comment);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return comments;
    }
    
    /**
     * Tạo bài đăng mới
     * @param post Đối tượng bài đăng cần tạo
     * @return true nếu tạo thành công, false nếu thất bại
     */
    public boolean createPost(Post post) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO forum_posts (user_id, subject_id, title, content, file_path, file_type) " +
                         "VALUES (?, ?, ?, ?, ?, ?)";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, post.getUser().getId());
            if (post.getSubjectId() > 0) {
                stmt.setInt(2, post.getSubjectId());
            } else {
                stmt.setNull(2, java.sql.Types.INTEGER);
            }
            stmt.setString(3, post.getTitle());
            stmt.setString(4, post.getContent());
            stmt.setString(5, post.getFilePath());
            stmt.setString(6, post.getFileType());
            
            int row = stmt.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Tạo bình luận mới
     * @param comment Đối tượng bình luận cần tạo
     * @param postId ID của bài đăng được bình luận
     * @return true nếu tạo thành công, false nếu thất bại
     */
    public boolean createComment(Comment comment, int postId) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO post_comments (post_id, user_id, content) VALUES (?, ?, ?)";
            
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, postId);
            stmt.setInt(2, comment.getUser().getId());
            stmt.setString(3, comment.getContent());
            
            int row = stmt.executeUpdate();
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Thích hoặc bỏ thích một bài đăng
     * @param postId ID của bài đăng
     * @param userId ID của người dùng thực hiện hành động
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean toggleLike(int postId, int userId) {
        try (Connection conn = DBConnection.getConnection()) {
            // Kiểm tra xem người dùng đã thích bài đăng chưa
            String checkSql = "SELECT COUNT(*) FROM post_likes WHERE post_id = ? AND user_id = ?";
            PreparedStatement checkStmt = conn.prepareStatement(checkSql);
            checkStmt.setInt(1, postId);
            checkStmt.setInt(2, userId);
            ResultSet rs = checkStmt.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                // Đã thích, thực hiện bỏ thích
                String deleteSql = "DELETE FROM post_likes WHERE post_id = ? AND user_id = ?";
                PreparedStatement deleteStmt = conn.prepareStatement(deleteSql);
                deleteStmt.setInt(1, postId);
                deleteStmt.setInt(2, userId);
                deleteStmt.executeUpdate();
            } else {
                // Chưa thích, thực hiện thích
                String insertSql = "INSERT INTO post_likes (post_id, user_id) VALUES (?, ?)";
                PreparedStatement insertStmt = conn.prepareStatement(insertSql);
                insertStmt.setInt(1, postId);
                insertStmt.setInt(2, userId);
                insertStmt.executeUpdate();
            }
            
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Kiểm tra xem người dùng đã thích bài đăng chưa
     * @param postId ID của bài đăng
     * @param userId ID của người dùng
     * @return true nếu đã thích, false nếu chưa thích
     */
    public boolean isLikedByUser(int postId, int userId) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT COUNT(*) FROM post_likes WHERE post_id = ? AND user_id = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, postId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next() && rs.getInt(1) > 0) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}