package com.studymate.controller;

import com.studymate.dao.PostDAO;
import com.studymate.model.Post;
import com.studymate.model.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/post")
public class PostController {

    @Autowired
    private PostDAO postDAO;

    /**
     * Hiển thị danh sách bài đăng trên dashboard
     */
    @GetMapping("/dashboard")
    public String showDashboard(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        // Lấy danh sách bài đăng từ những người mà user đang theo dõi
        List<Post> posts = postDAO.getFeedPosts(currentUser.getId(), 10); // Lấy 10 bài đăng mới nhất
        model.addAttribute("posts", posts);
        model.addAttribute("user", currentUser);

        return "dashboard";
    }

    /**
     * Xử lý tạo bài đăng mới
     */
    @PostMapping("/create")
    public String createPost(
            @RequestParam String content,
            @RequestParam(required = false) Integer subjectId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        Post post = new Post();
        post.setUser(currentUser);
        post.setTitle("Bài đăng từ " + currentUser.getFullName()); // Title mặc định
        post.setContent(content);
        if (subjectId != null) {
            post.setSubjectId(subjectId);
        } else {
            post.setSubjectId(0); // Không liên quan đến môn học cụ thể
        }
        // Hiện tại chưa xử lý file upload, nên để filePath và fileType là null
        post.setFilePath(null);
        post.setFileType(null);

        if (postDAO.createPost(post)) {
            redirectAttributes.addFlashAttribute("message", "Đăng bài thành công!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Đăng bài thất bại. Vui lòng thử lại.");
        }

        return "redirect:/post/dashboard";
    }

    /**
     * Xử lý thích/bỏ thích bài đăng
     */
    @PostMapping("/like")
    @ResponseBody
    public String toggleLike(@RequestParam int postId, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return "error";
        }

        if (postDAO.toggleLike(postId, currentUser.getId())) {
            return "success";
        }
        return "error";
    }

    /**
     * Kiểm tra xem người dùng đã thích bài đăng chưa
     */
    @GetMapping("/isLiked")
    @ResponseBody
    public boolean isLiked(@RequestParam int postId, HttpSession session) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return false;
        }
        return postDAO.isLikedByUser(postId, currentUser.getId());
    }
}