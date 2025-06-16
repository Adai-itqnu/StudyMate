package com.studymate.controller;

import com.studymate.model.Post;
import com.studymate.model.User;
import com.studymate.model.Comment;
import com.studymate.service.PostService;
import com.studymate.service.UserService;
import com.studymate.service.FollowService;
import com.studymate.service.LikeService;
import com.studymate.service.CommentService;
import com.studymate.service.ShareService;
import com.studymate.service.SearchService;
import com.studymate.service.impl.PostServiceImpl;
import com.studymate.service.impl.UserServiceImpl;
import com.studymate.service.impl.FollowServiceImpl;
import com.studymate.service.impl.LikeServiceImpl;
import com.studymate.service.impl.CommentServiceImpl;
import com.studymate.service.impl.ShareServiceImpl;
import com.studymate.service.impl.SearchServiceImpl;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

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
    private final ShareService shareService = new ShareServiceImpl();
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

        // Lấy thông tin user được xem
        User profileUser = userService.findById(userId);
        if (profileUser == null) {
            return "redirect:/dashboard";
        }

        // Lấy bài viết của user này
        List<Post> userPosts = postService.findAll().stream()
            .filter(p -> p.getUserId() == userId)
            .collect(Collectors.toList());

        // Đếm like, comment, share cho từng bài
        for (Post post : userPosts) {
            post.setLikeCount(likeService.countLikes(post.getPostId()));
            List<Comment> comments = commentService.getCommentsByPost(post.getPostId());
            for (Comment comment : comments) {
                comment.setLikeCount(likeService.countCommentLikes(comment.getCommentId()));
            }
            post.setComments(comments);
            post.setShares(shareService.getSharesByPost(post.getPostId()));
        }

        // Lấy thông tin theo dõi
        List<User> followers = followService.getFollowers(userId);
        List<User> followees = followService.getFollowees(userId);
        
        // Kiểm tra xem current user có đang theo dõi profile user không
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
    @ResponseBody
    public String followUser(@PathVariable int userId, HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return "error";
            }

            followService.follow(currentUser.getUserId(), userId);
            return "success";
        } catch (Exception e) {
            return "error";
        }
    }

    @PostMapping("/unfollow/{userId}")
    @ResponseBody
    public String unfollowUser(@PathVariable int userId, HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return "error";
            }

            followService.unfollow(currentUser.getUserId(), userId);
            return "success";
        } catch (Exception e) {
            return "error";
        }
    }

    @PostMapping("/like/{postId}")
    @ResponseBody
    public String likePost(@PathVariable int postId, HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return "error";
            }

            likeService.likePost(currentUser.getUserId(), postId);
            return "success";
        } catch (Exception e) {
            return "error";
        }
    }

    @PostMapping("/unlike/{postId}")
    @ResponseBody
    public String unlikePost(@PathVariable int postId, HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return "error";
            }

            likeService.unlikePost(currentUser.getUserId(), postId);
            return "success";
        } catch (Exception e) {
            return "error";
        }
    }

    @PostMapping("/like-comment/{commentId}")
    @ResponseBody
    public String likeComment(@PathVariable int commentId, HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return "error";
            }
            likeService.likeComment(currentUser.getUserId(), commentId);
            return "success";
        } catch (Exception e) {
            return "error";
        }
    }

    @PostMapping("/unlike-comment/{commentId}")
    @ResponseBody
    public String unlikeComment(@PathVariable int commentId, HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return "error";
            }
            likeService.unlikeComment(currentUser.getUserId(), commentId);
            return "success";
        } catch (Exception e) {
            return "error";
        }
    }

    @PostMapping("/share/{postId}")
    @ResponseBody
    public String sharePost(@PathVariable int postId, HttpSession session) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                return "error";
            }

            shareService.sharePost(currentUser.getUserId(), postId);
            return "success";
        } catch (Exception e) {
            return "error";
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