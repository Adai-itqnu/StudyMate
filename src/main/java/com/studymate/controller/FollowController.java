package com.studymate.controller;

import com.studymate.service.FollowService;
import com.studymate.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;
import java.util.List;

@RestController
@RequestMapping("/api/follow")
public class FollowController {
    
    @Autowired
    private FollowService followService;
    
    // Theo dõi người dùng
    @PostMapping("/{userId}")
    public ResponseEntity<Map<String, Object>> followUser(
            @PathVariable int userId, 
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                return ResponseEntity.ok(response);
            }
            
            if (currentUser.getUserId() == userId) {
                response.put("success", false);
                response.put("message", "Không thể theo dõi chính mình");
                return ResponseEntity.ok(response);
            }
            
            boolean result = followService.followUser(currentUser.getUserId(), userId);
            
            if (result) {
                response.put("success", true);
                response.put("message", "Đã theo dõi thành công");
            } else {
                response.put("success", false);
                response.put("message", "Bạn đã theo dõi người này rồi");
            }
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }
    
    // Bỏ theo dõi
    @DeleteMapping("/{userId}")
    public ResponseEntity<Map<String, Object>> unfollowUser(
            @PathVariable int userId, 
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                return ResponseEntity.ok(response);
            }
            
            boolean result = followService.unfollowUser(currentUser.getUserId(), userId);
            
            if (result) {
                response.put("success", true);
                response.put("message", "Đã bỏ theo dõi");
            } else {
                response.put("success", false);
                response.put("message", "Bạn chưa theo dõi người này");
            }
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }
    
    // Lấy danh sách người theo dõi
    @GetMapping("/{userId}/followers")
    public ResponseEntity<Map<String, Object>> getFollowers(@PathVariable int userId) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            List<User> followers = followService.getFollowers(userId);
            response.put("success", true);
            response.put("followers", followers);
            response.put("count", followers.size());
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }
    
    // Lấy danh sách đang theo dõi
    @GetMapping("/{userId}/following")
    public ResponseEntity<Map<String, Object>> getFollowing(@PathVariable int userId) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            List<User> following = followService.getFollowing(userId);
            response.put("success", true);
            response.put("following", following);
            response.put("count", following.size());
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }
    
    // Kiểm tra có theo dõi không
    @GetMapping("/check/{userId}")
    public ResponseEntity<Map<String, Object>> checkFollowStatus(
            @PathVariable int userId, 
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                return ResponseEntity.ok(response);
            }
            
            boolean isFollowing = followService.isFollowing(currentUser.getUserId(), userId);
            response.put("success", true);
            response.put("isFollowing", isFollowing);
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }
}