package com.studymate.controller;

import com.studymate.model.Post;
import com.studymate.model.User;
import com.studymate.service.PostService;
import com.studymate.service.UserService;
import com.studymate.service.SearchService;
import com.studymate.service.impl.PostServiceImpl;
import com.studymate.service.impl.UserServiceImpl;
import com.studymate.service.impl.SearchServiceImpl;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class DashboardController {

    private final PostService postService = new PostServiceImpl();
    private final UserService userService = new UserServiceImpl();
    private final SearchService searchService = new SearchServiceImpl();

    @GetMapping("/dashboard")
    public String showDashboard(
            @RequestParam(name = "search", required = false) String searchKeyword,
            HttpSession session, 
            Model model) throws Exception {
        
        // 1. Kiểm tra đã login chưa
        User current = (User) session.getAttribute("currentUser");
        if (current == null) {
            return "redirect:/login";
        }
        
        // 2. Lấy danh sách bài viết (đã được uncomment)
        List<Post> posts = postService.findAll();
        model.addAttribute("posts", posts);
        
        // 3. Xử lý tìm kiếm nếu có
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            List<User> searchResults = searchService.searchUsers(searchKeyword.trim());
            model.addAttribute("searchResults", searchResults);
            model.addAttribute("searchKeyword", searchKeyword);
        }
        
        // 4. Lấy gợi ý theo dõi (ví dụ: tất cả user trừ chính user)
        List<User> suggestions = userService.findAll();
        suggestions.removeIf(u -> u.getUserId() == current.getUserId());
        model.addAttribute("suggestions", suggestions);
        
        // 5. Thêm token vào model
      //  model.addAttribute("csrfToken", session.getAttribute("csrfToken"));
        
        // 6. Thêm current user vào model
        model.addAttribute("currentUser", current);

        return "dashboard";   // sẽ forward đến WEB-INF/views/dashboard.jsp
    }
}