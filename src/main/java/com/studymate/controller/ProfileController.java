package com.studymate.controller;

import com.studymate.model.Post;
import com.studymate.model.User;
import com.studymate.service.PostService;
import com.studymate.service.UserService;
import com.studymate.service.FollowService;
import com.studymate.service.LikeService;
import com.studymate.service.CommentService;
import com.studymate.service.SearchService;
import com.studymate.service.impl.PostServiceImpl;
import com.studymate.service.impl.UserServiceImpl;
import com.studymate.service.impl.FollowServiceImpl;
import com.studymate.service.impl.LikeServiceImpl;
import com.studymate.service.impl.CommentServiceImpl;
import com.studymate.service.impl.SearchServiceImpl;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/profile")
public class ProfileController {

    private final PostService postService = new PostServiceImpl();
    private final UserService userService = new UserServiceImpl();
    private final FollowService followService = new FollowServiceImpl();
    private final LikeService likeService = new LikeServiceImpl();
    private final CommentService commentService = new CommentServiceImpl();
    private final SearchService searchService = new SearchServiceImpl();

    @GetMapping
    public String showMyProfile(HttpSession session, Model model) throws Exception {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        
        return showProfile(currentUser.getUserId(), session, model);
    }

    @GetMapping("/{userId}")
    public String showProfile(@PathVariable int userId, HttpSession session, Model model) throws Exception {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        User profileUser = userService.findById(userId);
        if (profileUser == null) {
            return "redirect:/dashboard";
        }

        List<Post> userPosts = postService.findAll().stream()
            .filter(p -> p.getUserId() == userId)
            .collect(Collectors.toList());

        for (Post post : userPosts) {
            post.setLikeCount(likeService.countLikes(post.getPostId()));
            post.setComments(commentService.getCommentsByPost(post.getPostId()));
        }

        List<User> followers = followService.getFollowers(userId);
        List<User> followees = followService.getFollowees(userId);
        
        boolean isFollowing = followers.stream()
            .anyMatch(f -> f.getUserId() == currentUser.getUserId());

        model.addAttribute("profileUser", profileUser);
        model.addAttribute("userPosts", userPosts);
        model.addAttribute("followers", followers);
        model.addAttribute("followees", followees);
        model.addAttribute("isFollowing", isFollowing);
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("isOwnProfile", currentUser.getUserId() == userId);

        return "profile";
    }

    @PostMapping("/follow/{userId}")
    public String followUser(
        @PathVariable int userId, 
        HttpSession session,
        RedirectAttributes redirectAttributes
    ) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return "redirect:/login";
            }

            if (currentUser.getUserId() == userId) {
                redirectAttributes.addFlashAttribute("error", "Không thể theo dõi chính mình");
                return "redirect:/profile/" + userId;
            }

            boolean followed = followService.follow(currentUser.getUserId(), userId);
            if (followed) {
                redirectAttributes.addFlashAttribute("message", "Đã theo dõi thành công!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Không thể theo dõi");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        return "redirect:/profile/" + userId;
    }

    @PostMapping("/unfollow/{userId}")
    public String unfollowUser(
        @PathVariable int userId, 
        HttpSession session,
        RedirectAttributes redirectAttributes
    ) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return "redirect:/login";
            }

            boolean unfollowed = followService.unfollow(currentUser.getUserId(), userId);
            if (unfollowed) {
                redirectAttributes.addFlashAttribute("message", "Đã hủy theo dõi");
            } else {
                redirectAttributes.addFlashAttribute("error", "Không thể hủy theo dõi");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        return "redirect:/profile/" + userId;
    }

    @PostMapping("/like/{postId}")
    public String likePost(
        @PathVariable int postId, 
        @RequestParam(required = false) Integer profileUserId,
        HttpSession session,
        RedirectAttributes redirectAttributes
    ) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return "redirect:/login";
            }

            boolean isLiked = likeService.isLiked(currentUser.getUserId(), postId);
            
            if (isLiked) {
                boolean unliked = likeService.unlikePost(currentUser.getUserId(), postId);
                if (unliked) {
                    redirectAttributes.addFlashAttribute("message", "Đã bỏ like bài viết");
                } else {
                    redirectAttributes.addFlashAttribute("error", "Không thể bỏ like");
                }
            } else {
                boolean liked = likeService.likePost(currentUser.getUserId(), postId);
                if (liked) {
                    redirectAttributes.addFlashAttribute("message", "Đã like bài viết");
                } else {
                    redirectAttributes.addFlashAttribute("error", "Không thể like bài viết");
                }
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        // Redirect về profile của user được chỉ định hoặc về profile hiện tại
        if (profileUserId != null) {
            return "redirect:/profile/" + profileUserId;
        } else {
            return "redirect:/profile";
        }
    }

    @PostMapping("/share/{postId}")
    public String sharePost(
        @PathVariable int postId,
        @RequestParam(required = false) Integer profileUserId,
        HttpSession session,
        RedirectAttributes redirectAttributes
    ) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return "redirect:/login";
            }

            // Lấy thông tin bài viết gốc
            Post originalPost = postService.findById(postId);
            if (originalPost == null) {
                redirectAttributes.addFlashAttribute("error", "Bài viết không tồn tại");
                return "redirect:/profile";
            }

            // Kiểm tra không được share bài viết của chính mình
            if (originalPost.getUserId() == currentUser.getUserId()) {
                redirectAttributes.addFlashAttribute("error", "Không thể chia sẻ bài viết của chính mình");
                return "redirect:/profile";
            }

            // Tạo bài viết share mới
            Post sharedPost = new Post();
            sharedPost.setUserId(currentUser.getUserId());
            sharedPost.setTitle("Đã chia sẻ: " + originalPost.getTitle());
            sharedPost.setBody("Chia sẻ từ User " + originalPost.getUserId() + ":\n\n" + originalPost.getBody());
            sharedPost.setPrivacy("PUBLIC");
            
            int newPostId = postService.create(sharedPost, null);

            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        // Redirect về profile của user được chỉ định hoặc về profile hiện tại
        if (profileUserId != null) {
            return "redirect:/profile/" + profileUserId;
        } else {
            return "redirect:/profile";
        }
    }

    @GetMapping("/search")
    public String search(
            @RequestParam(required = false) String query,
            @RequestParam(defaultValue = "users") String type,
            HttpSession session,
            Model model) throws Exception {
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }

        if (query != null && !query.trim().isEmpty()) {
            if ("users".equals(type)) {
                List<User> searchResults = searchService.searchUsers(query.trim());
                model.addAttribute("userResults", searchResults);
            }
        }

        model.addAttribute("query", query);
        model.addAttribute("type", type);
        model.addAttribute("currentUser", currentUser);

        return "search";
    }
}