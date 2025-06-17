package com.studymate.controller;

import com.studymate.model.Post;
import com.studymate.model.User;
import com.studymate.service.PostService;
import com.studymate.service.UserService;
import com.studymate.service.SearchService;
import com.studymate.service.LikeService;
import com.studymate.service.CommentService;
import com.studymate.service.FollowService;
import com.studymate.service.impl.PostServiceImpl;
import com.studymate.service.impl.UserServiceImpl;
import com.studymate.service.impl.SearchServiceImpl;
import com.studymate.service.impl.LikeServiceImpl;
import com.studymate.service.impl.CommentServiceImpl;
import com.studymate.service.impl.FollowServiceImpl;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;
import java.util.ArrayList;

@Controller
public class DashboardController {

    private final PostService postService = new PostServiceImpl();
    private final UserService userService = new UserServiceImpl();
    private final SearchService searchService = new SearchServiceImpl();
    private final LikeService likeService = new LikeServiceImpl();
    private final CommentService commentService = new CommentServiceImpl();
    private final FollowService followService = new FollowServiceImpl();

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
        
        // 2. Lấy danh sách bài viết và lọc theo quyền riêng tư
        List<Post> allPosts = postService.findAll();
        List<Post> visiblePosts = new ArrayList<>();
        
        for (Post post : allPosts) {
            boolean canView = false;
            
            // Kiểm tra quyền xem bài viết
            switch (post.getPrivacy()) {
                case "PUBLIC":
                    // Bài viết công khai - tất cả mọi người đều xem được
                    canView = true;
                    break;
                    
                case "FOLLOWERS":
                    // Bài viết chỉ cho người theo dõi
                    if (post.getUserId() == current.getUserId()) {
                        canView = true;
                    } else {
                        canView = followService.isFollowing(current.getUserId(), post.getUserId());
                    }
                    break;
                    
                case "PRIVATE":
                    // Bài viết riêng tư - chỉ chủ sở hữu xem được
                    canView = (post.getUserId() == current.getUserId());
                    break;
                    
                default:
                    canView = true;
                    break;
            }
            
            // Nếu có quyền xem thì thêm vào danh sách
            if (canView) {
                visiblePosts.add(post);
            }
        }
        
        // 3. Cập nhật thông tin đầy đủ cho những bài viết có thể xem
        for (Post post : visiblePosts) {
            // Số lượt like
            post.setLikeCount(likeService.countLikes(post.getPostId()));
            
            // Kiểm tra user hiện tại đã like chưa
            post.setLikedByCurrentUser(likeService.isLiked(current.getUserId(), post.getPostId()));
            
            // Danh sách comment (chỉ lấy comment từ những user có quyền comment)
            post.setComments(commentService.getCommentsByPost(post.getPostId()));
            
            // Thông tin user đăng bài
            User postUser = userService.findById(post.getUserId());
            if (postUser != null) {
                post.setUserFullName(postUser.getFullName());
                post.setUserAvatar(postUser.getAvatarUrl());
            }
        }
        
        model.addAttribute("posts", visiblePosts);
        
        // 4. Xử lý tìm kiếm nếu có
        if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
            List<User> searchResults = searchService.searchUsers(searchKeyword.trim());
            model.addAttribute("searchResults", searchResults);
            model.addAttribute("searchKeyword", searchKeyword);
        }
        
        // 5. Lấy gợi ý theo dõi (loại trừ bản thân và những người đã theo dõi)
        List<User> allUsers = userService.findAll();
        List<User> suggestions = new ArrayList<>();
        
        for (User user : allUsers) {
            // Loại trừ bản thân
            if (user.getUserId() == current.getUserId()) {
                continue;
            }     
            
            suggestions.add(user);
        }
        
        // Cập nhật trạng thái follow cho từng suggestion
        for (User suggestion : suggestions) {
            boolean isFollowing = followService.isFollowing(current.getUserId(), suggestion.getUserId());
            suggestion.setFollowed(isFollowing);
        }
        
        model.addAttribute("suggestions", suggestions);
        
        // 6. Thêm current user vào model
        model.addAttribute("currentUser", current);

        return "dashboard";
    }
    
    /**
     * Helper method để kiểm tra quyền xem bài viết
     */
    private boolean canUserViewPost(User currentUser, Post post, FollowService followService) {
        if (currentUser == null || post == null) {
            return false;
        }
        
        // Chủ sở hữu bài viết luôn xem được
        if (post.getUserId() == currentUser.getUserId()) {
            return true;
        }
        
        // Kiểm tra theo privacy setting
        switch (post.getPrivacy()) {
            case "PUBLIC":
                return true;
                
            case "FOLLOWERS":
                try {
                    return followService.isFollowing(currentUser.getUserId(), post.getUserId());
                } catch (Exception e) {
                    e.printStackTrace();
                    return false; 
                }
                
            case "PRIVATE":
                return false; 
                
            default:
                return true;
        }
    }
}