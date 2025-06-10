package com.studymate.controller;

import com.studymate.model.Post;
import com.studymate.model.User;
import com.studymate.service.PostService;
import com.studymate.service.impl.PostServiceImpl;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@Controller
@RequestMapping("/posts")
public class PostController {
    private final PostService postService = new PostServiceImpl();

    @PostMapping("/create")
    public String createPost(
            @RequestParam String title,
            @RequestParam String body,
            @RequestParam(required=false) MultipartFile attachment,
            @RequestParam String privacy,
            @RequestParam String csrfToken,
            HttpServletRequest request,
            HttpSession session,
            Model model
    ) throws Exception {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) {
            return "redirect:/login";
        }
        Post p = new Post();
        p.setUserId(current.getUserId());
        p.setTitle(title);
        p.setBody(body);
        p.setPrivacy(privacy);
        // Gọi service để lưu bài và xử lý attachment
        postService.create(p, attachment);
        return "redirect:/dashboard";
    }
}