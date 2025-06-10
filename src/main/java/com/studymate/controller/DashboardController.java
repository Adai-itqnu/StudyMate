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
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class DashboardController {

    private final PostService postService = new PostServiceImpl();
    private final UserService userService = new UserServiceImpl();

    @GetMapping("/dashboard")
    public String showDashboard(HttpSession session, Model model) throws Exception {
        // 1. Kiểm tra đã login chưa
        User current = (User) session.getAttribute("currentUser");
        if (current == null) {
            return "redirect:/login";
        }
        // 2. Lấy danh sách bài viết
        List<Post> posts = postService.findAll();
        model.addAttribute("posts", posts);
        // 3. Lấy gợi ý theo dõi (ví dụ: tất cả user trừ chính user)
        List<User> suggestions = userService.findAll();
        suggestions.removeIf(u -> u.getUserId() == current.getUserId());
        model.addAttribute("suggestions", suggestions);
        
     // **Thêm token vào model**
        model.addAttribute("csrfToken", session.getAttribute("csrfToken"));
        

        return "dashboard";   // sẽ forward đến WEB-INF/views/dashboard.jsp
    }
}
