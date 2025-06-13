package com.studymate.controller;

import com.studymate.service.SearchService;
import com.studymate.model.User;
import com.studymate.model.Post;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;
import java.util.List;

@RestController
@RequestMapping("/api/search")
public class SearchController {
    
    @Autowired
    private SearchService searchService;
    
    // Tìm kiếm tổng hợp
    @GetMapping
    public ResponseEntity<Map<String, Object>> search(
            @RequestParam String q,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                return ResponseEntity.ok(response);
            }
            
            if (q == null || q.trim().isEmpty()) {
                response.put("success", false);
                response.put("message", "Từ khóa tìm kiếm không được để trống");
                return ResponseEntity.ok(response);
            }
            
            SearchService.SearchResult result = searchService.searchAll(q.trim());
            
            response.put("success", true);
            response.put("keyword", q.trim());
            response.put("users", result.getUsers());
            response.put("posts", result.getPosts());
            response.put("userCount", result.getUsers().size());
            response.put("postCount", result.getPosts().size());
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }
    
    // Tìm kiếm người dùng
    @GetMapping("/users")
    public ResponseEntity<Map<String, Object>> searchUsers(
            @RequestParam String q,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                return ResponseEntity.ok(response);
            }
            
            if (q == null || q.trim().isEmpty()) {
                response.put("success", false);
                response.put("message", "Từ khóa tìm kiếm không được để trống");
                return ResponseEntity.ok(response);
            }
            
            List<User> users = searchService.searchUsers(q.trim());
            
            response.put("success", true);
            response.put("keyword", q.trim());
            response.put("users", users);
            response.put("count", users.size());
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }
    
    // Tìm kiếm bài viết
    @GetMapping("/posts")
    public ResponseEntity<Map<String, Object>> searchPosts(
            @RequestParam String q,
            HttpSession session) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            User currentUser = (User) session.getAttribute("user");
            if (currentUser == null) {
                response.put("success", false);
                response.put("message", "Vui lòng đăng nhập");
                return ResponseEntity.ok(response);
            }
            
            if (q == null || q.trim().isEmpty()) {
                response.put("success", false);
                response.put("message", "Từ khóa tìm kiếm không được để trống");
                return ResponseEntity.ok(response);
            }
            
            List<Post> posts = searchService.searchPosts(q.trim());
            
            response.put("success", true);
            response.put("keyword", q.trim());
            response.put("posts", posts);
            response.put("count", posts.size());
            
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        return ResponseEntity.ok(response);
    }
}