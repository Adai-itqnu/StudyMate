package com.studymate.controller;

import com.studymate.service.LikeService;
import com.studymate.service.CommentService;
import com.studymate.service.ShareService;
import com.studymate.model.User;
import com.studymate.model.Comment;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;
import java.util.List;

@RestController
@RequestMapping("/api/interactions")
public class InteractionController {
    
    @Autowired
    private LikeService likeService;
    
    @Autowired
    private CommentService commentService;
    
    @Autowired
    private ShareService shareService;
    
    // LIKE ACTIONS
    @PostMapping("/like/{postId}")
    public ResponseEntity<Map<String, Object>> likePost(
            @PathVariable int postId, 
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                return ResponseEntity.ok(response);
            }
            
            boolean result = likeService.toggleLike(currentUser.getUserId(), postId);
            int likeCount = likeService.getLikeCount(postId);
            boolean isLiked = likeService.isLiked(currentUser.getUserId(), postId);
            
            response.put("success", true);
            response.put("action", result ? "liked" : "unliked");
            response.put("likeCount", likeCount);
            response.put("isLiked", isLiked);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/like/{postId}/count")
    public ResponseEntity<Map<String, Object>> getLikeCount(@PathVariable int postId) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            int count = likeService.getLikeCount(postId);
            response.put("success", true);
            response.put("likeCount", count);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }
    
    // COMMENT ACTIONS
    @PostMapping("/comment/{postId}")
    public ResponseEntity<Map<String, Object>> addComment(
            @PathVariable int postId,
            @RequestParam String content,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                return ResponseEntity.ok(response);
            }
            
            if (content == null || content.trim().isEmpty()) {
                response.put("success", false);
                response.put("message", "Nội dung bình luận không được để trống");
                return ResponseEntity.ok(response);
            }
            
            Comment comment = commentService.addComment(currentUser.getUserId(), postId, content.trim());
            
            if (comment != null) {
                response.put("success", true);
                response.put("message", "Đã thêm bình luận");
                response.put("comment", comment);
            } else {
                response.put("success", false);
                response.put("message", "Không thể thêm bình luận");
            }
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/comment/{postId}")
    public ResponseEntity<Map<String, Object>> getComments(@PathVariable int postId) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            List<Comment> comments = commentService.getCommentsByPost(postId);
            response.put("success", true);
            response.put("comments", comments);
            response.put("count", comments.size());
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }
    
    @DeleteMapping("/comment/{commentId}")
    public ResponseEntity<Map<String, Object>> deleteComment(
            @PathVariable int commentId,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                return ResponseEntity.ok(response);
            }
            
            boolean result = commentService.deleteComment(commentId, currentUser.getUserId());
            
            if (result) {
                response.put("success", true);
                response.put("message", "Đã xóa bình luận");
            } else {
                response.put("success", false);
                response.put("message", "Không thể xóa bình luận");
            }
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }
    
    // SHARE ACTIONS
    @PostMapping("/share/{postId}")
    public ResponseEntity<Map<String, Object>> sharePost(
            @PathVariable int postId,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                return ResponseEntity.ok(response);
            }
            
            boolean result = shareService.sharePost(currentUser.getUserId(), postId);
            
            if (result) {
                int shareCount = shareService.getShareCount(postId);
                response.put("success", true);
                response.put("message", "Đã chia sẻ bài viết");
                response.put("shareCount", shareCount);
            } else {
                response.put("success", false);
                response.put("message", "Không thể chia sẻ bài viết");
            }
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }
    
    @GetMapping("/share/{postId}/count")
    public ResponseEntity<Map<String, Object>> getShareCount(@PathVariable int postId) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            int count = shareService.getShareCount(postId);
            response.put("success", true);
            response.put("shareCount", count);
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }
}