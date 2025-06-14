package com.studymate.controller;

import com.studymate.model.Post;
import com.studymate.model.User;
import com.studymate.service.PostService;
import com.studymate.service.UserService;
import com.studymate.service.impl.PostServiceImpl;
import com.studymate.service.impl.UserServiceImpl;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin")
public class AdminController {
    private final UserService userService = new UserServiceImpl();
    private final PostService postService = new PostServiceImpl();

    // Middleware kiểm tra quyền admin
    private boolean isAdmin(HttpSession session) {
        User u = (User) session.getAttribute("currentUser");
        return u != null && (u.isSystemAdmin() || "ADMIN".equals(u.getRole()));
    }

    // 0. Trang dashboard chính
    @GetMapping({"", "/", "/dashboard"})
    public String dashboard(HttpSession session, Model model) throws Exception {
        if (!isAdmin(session)) {
            return "redirect:/login";
        }
        
        try {
            List<User> allUsers = userService.findAll();
            List<Post> allPosts = null;
            
            try {
                allPosts = postService.findAllWithDetails();
            } catch (Exception e) {
                allPosts = java.util.Collections.emptyList();
            }
            
            model.addAttribute("totalUsers", allUsers.size());
            model.addAttribute("totalPosts", allPosts.size());
            model.addAttribute("users", allUsers);
            model.addAttribute("posts", allPosts);
            
        } catch (Exception e) {
            model.addAttribute("totalUsers", 0);
            model.addAttribute("totalPosts", 0);
            model.addAttribute("users", java.util.Collections.emptyList());
            model.addAttribute("posts", java.util.Collections.emptyList());
        }
        
        return "admin/dashboard";
    }

    // 1. Trang quản lý user
    @GetMapping("/users")
    public String listUsers(HttpSession session, Model model) throws Exception {
        if (!isAdmin(session)) return "redirect:/login";
        List<User> users = userService.findAll();
        model.addAttribute("users", users);
        return "admin/users";
    }

    // 1.1. Tìm kiếm users
    @GetMapping("/users/search")
    public String searchUsers(
        @RequestParam(required = false) String keyword,
        HttpSession session, 
        Model model
    ) throws Exception {
        if (!isAdmin(session)) return "redirect:/login";
        
        List<User> users;
        if (keyword != null && !keyword.trim().isEmpty()) {
            users = userService.findAll().stream()
                .filter(u -> u.getFullName().toLowerCase().contains(keyword.toLowerCase()) ||
                           u.getUsername().toLowerCase().contains(keyword.toLowerCase()) ||
                           u.getEmail().toLowerCase().contains(keyword.toLowerCase()))
                .collect(Collectors.toList());
        } else {
            users = userService.findAll();
        }
        
        model.addAttribute("users", users);
        model.addAttribute("keyword", keyword);
        return "admin/users";
    }

    // 2. Xoá user
    @PostMapping("/users/delete")
    public String deleteUser(
        @RequestParam int userId,
        HttpSession session
    ) throws Exception {
        if (!isAdmin(session)) return "redirect:/login";
        userService.deleteUser(userId);
        return "redirect:/admin/users";
    }

    // 3. Trang quản lý post
    @GetMapping("/posts")
    public String listPosts(HttpSession session, Model model) throws Exception {
        if (!isAdmin(session)) return "redirect:/login";
        List<Post> posts = postService.findAllWithDetails();
        model.addAttribute("posts", posts);
        return "admin/posts";
    }

    // 3.1. Tìm kiếm posts
    @GetMapping("/posts/search")
    public String searchPosts(
        @RequestParam(required = false) String keyword,
        HttpSession session, 
        Model model
    ) throws Exception {
        if (!isAdmin(session)) return "redirect:/login";
        
        List<Post> posts;
        if (keyword != null && !keyword.trim().isEmpty()) {
            posts = postService.findAllWithDetails().stream()
                .filter(p -> (p.getTitle() != null && p.getTitle().toLowerCase().contains(keyword.toLowerCase())) ||
                           (p.getBody() != null && p.getBody().toLowerCase().contains(keyword.toLowerCase())))
                .collect(Collectors.toList());
        } else {
            posts = postService.findAllWithDetails();
        }
        
        model.addAttribute("posts", posts);
        model.addAttribute("keyword", keyword);
        return "admin/posts";
    }

    // 4. Xoá post
    @PostMapping("/posts/delete")
    public String deletePost(
        @RequestParam int postId,
        HttpSession session
    ) throws Exception {
        if (!isAdmin(session)) return "redirect:/login";
        postService.delete(postId);
        return "redirect:/admin/posts";
    }

    // 5. Logout
    @GetMapping("/logout")
    public String logoutAdmin(HttpSession session) {
        session.invalidate();
        return "redirect:/login";
    }
}