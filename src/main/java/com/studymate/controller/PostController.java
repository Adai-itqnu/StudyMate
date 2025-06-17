package com.studymate.controller;

import com.studymate.model.Attachment;
import com.studymate.model.Comment;
import com.studymate.model.Post;
import com.studymate.model.User;
import com.studymate.service.PostService;
import com.studymate.service.CommentService;
import com.studymate.service.LikeService;
import com.studymate.service.FollowService;
import com.studymate.service.UserService;
import com.studymate.service.impl.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.File;
import java.io.IOException;

@Controller
@RequestMapping("/posts")
public class PostController {
    private final PostService postService = new PostServiceImpl();
    private final CommentService commentService = new CommentServiceImpl();
    private final LikeService likeService = new LikeServiceImpl();
    private final FollowService followService = new FollowServiceImpl();
    private final UserService userService = new UserServiceImpl();

    @PostMapping("/create")
    public String createPost(
        @RequestParam String title,
        @RequestParam String body,
        @RequestParam String privacy,
        @RequestParam(required=false) MultipartFile attachment,
        HttpServletRequest request,
        RedirectAttributes redirectAttributes
    ) throws Exception {
        HttpSession session = request.getSession(false);
        User current = session == null ? null : (User) session.getAttribute("currentUser");
        if (current == null) {
            redirectAttributes.addFlashAttribute("error", "Vui lòng đăng nhập");
            return "redirect:/login";
        }

        try {
            // Validate input
            if (title == null || title.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Tiêu đề không được để trống");
                return "redirect:/dashboard";
            }
            
            if (body == null || body.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Nội dung không được để trống");
                return "redirect:/dashboard";
            }

            // Xử lý file upload
            String fileUrl = null;
            if (attachment != null && !attachment.isEmpty()) {
                String originalFilename = attachment.getOriginalFilename();
                if (originalFilename != null) {
                    String filename = originalFilename.toLowerCase();
                    
                    if (filename.endsWith(".jpg") || filename.endsWith(".jpeg") || filename.endsWith(".png")) {
                        String uploadDir = request.getServletContext().getRealPath("/resources/uploads/");
                        File dir = new File(uploadDir);
                        if (!dir.exists()) {
                            dir.mkdirs();
                        }

                        String uniqueFilename = System.currentTimeMillis() + "_" + originalFilename;
                        File destFile = new File(dir, uniqueFilename);
                        
                        attachment.transferTo(destFile);
                        fileUrl = request.getContextPath() + "/resources/uploads/" + uniqueFilename;
                    } else {
                        redirectAttributes.addFlashAttribute("error", "Chỉ hỗ trợ file ảnh JPG, JPEG, PNG");
                        return "redirect:/dashboard";
                    }
                }
            }

            // Lưu post
            Post p = new Post();
            p.setUserId(current.getUserId());
            p.setTitle(title.trim());
            p.setBody(body.trim());
            p.setPrivacy(privacy);
            
            int postId = postService.create(p, fileUrl);
            if (postId > 0) {
                redirectAttributes.addFlashAttribute("message", "Đăng bài thành công!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Không thể tạo bài viết");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra khi đăng bài: " + e.getMessage());
        }

        return "redirect:/dashboard";
    }

    
    @PostMapping("/comment")
    public String addComment(
        @RequestParam int postId,
        @RequestParam String content,
        HttpSession session,
        RedirectAttributes redirectAttributes,
        @RequestParam(value = "redirect", defaultValue = "dashboard") String redirectPage,
        HttpServletRequest request
    ) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                redirectAttributes.addFlashAttribute("error", "Vui lòng đăng nhập");
                return "redirect:/login";
            }

            if (content == null || content.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Nội dung comment không được để trống");
                return getRedirectUrl(redirectPage, request);
            }

            if (content.trim().length() > 500) {
                redirectAttributes.addFlashAttribute("error", "Bình luận không được quá 500 ký tự");
                return getRedirectUrl(redirectPage, request);
            }

            Comment comment = new Comment();
            comment.setUserId(currentUser.getUserId());
            comment.setPostId(postId);
            comment.setContent(content.trim());

            int commentId = commentService.addComment(comment);
            if (commentId > 0) {
                redirectAttributes.addFlashAttribute("message", "Thêm bình luận thành công!");
                // Add fragment to auto-open comments section
                redirectAttributes.addFlashAttribute("openComments", postId);
            } else {
                redirectAttributes.addFlashAttribute("error", "Không thể thêm bình luận");
            }
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        return getRedirectUrl(redirectPage, request) + "#post-" + postId;
    }

    @PostMapping("/comment/delete")
    public String deleteComment(
        @RequestParam int commentId, 
        HttpSession session,
        RedirectAttributes redirectAttributes,
        @RequestParam(value = "redirect", defaultValue = "dashboard") String redirectPage,
        @RequestParam(value = "postId", required = false) Integer postId,
        HttpServletRequest request
    ) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                redirectAttributes.addFlashAttribute("error", "Vui lòng đăng nhập");
                return "redirect:/login";
            }

            boolean deleted = commentService.deleteComment(commentId);
            if (deleted) {
                redirectAttributes.addFlashAttribute("message", "Xóa bình luận thành công!");
                if (postId != null) {
                    redirectAttributes.addFlashAttribute("openComments", postId);
                }
            } else {
                redirectAttributes.addFlashAttribute("error", "Không thể xóa bình luận");
            }
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        String redirect = getRedirectUrl(redirectPage, request);
        if (postId != null) {
            redirect += "#post-" + postId;
        }
        return redirect;
    }


    @PostMapping("/like")
    public String likePost(
        @RequestParam int postId, 
        HttpSession session,
        RedirectAttributes redirectAttributes,
        @RequestParam(value = "redirect", defaultValue = "dashboard") String redirectPage,
        HttpServletRequest request
    ) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                redirectAttributes.addFlashAttribute("error", "Vui lòng đăng nhập");
                return "redirect:/login";
            }

            boolean isLiked = likeService.isLiked(currentUser.getUserId(), postId);
            
            if (isLiked) {
                // Unlike
                boolean unliked = likeService.unlikePost(currentUser.getUserId(), postId);
                if (unliked) {
                    redirectAttributes.addFlashAttribute("message", "Đã bỏ like bài viết");
                } else {
                    redirectAttributes.addFlashAttribute("error", "Không thể bỏ like");
                }
            } else {
                // Like
                boolean liked = likeService.likePost(currentUser.getUserId(), postId);
                if (liked) {
                    redirectAttributes.addFlashAttribute("message", "Đã like bài viết");
                } else {
                    redirectAttributes.addFlashAttribute("error", "Không thể like bài viết");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        return getRedirectUrl(redirectPage, request) + "#post-" + postId;
    }




    @PostMapping("/follow")
    public String followUser(
        @RequestParam int userId, 
        HttpSession session,
        RedirectAttributes redirectAttributes,
        @RequestParam(value = "redirect", defaultValue = "dashboard") String redirectPage,
        HttpServletRequest request
    ) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                redirectAttributes.addFlashAttribute("error", "Vui lòng đăng nhập");
                return "redirect:/login";
            }

            if (currentUser.getUserId() == userId) {
                redirectAttributes.addFlashAttribute("error", "Không thể theo dõi chính mình");
                return getRedirectUrl(redirectPage, request);
            }

            // Check if already following
            boolean isFollowing = followService.isFollowing(currentUser.getUserId(), userId);
            
            if (isFollowing) {
                // Unfollow
                boolean unfollowed = followService.unfollow(currentUser.getUserId(), userId);
                if (unfollowed) {
                    redirectAttributes.addFlashAttribute("message", "Đã hủy theo dõi");
                } else {
                    redirectAttributes.addFlashAttribute("error", "Không thể hủy theo dõi");
                }
            } else {
                // Follow
                boolean followed = followService.follow(currentUser.getUserId(), userId);
                if (followed) {
                    redirectAttributes.addFlashAttribute("message", "Đã theo dõi thành công!");
                } else {
                    redirectAttributes.addFlashAttribute("error", "Không thể theo dõi");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        return getRedirectUrl(redirectPage, request);
    }

    @PostMapping("/unfollow")
    public String unfollowUser(
        @RequestParam int userId, 
        HttpSession session,
        RedirectAttributes redirectAttributes,
        @RequestParam(value = "redirect", defaultValue = "dashboard") String redirectPage,
        HttpServletRequest request
    ) {
        try {
            User currentUser = (User) session.getAttribute("currentUser");
            if (currentUser == null) {
                redirectAttributes.addFlashAttribute("error", "Vui lòng đăng nhập");
                return "redirect:/login";
            }

            boolean unfollowed = followService.unfollow(currentUser.getUserId(), userId);
            if (unfollowed) {
                redirectAttributes.addFlashAttribute("message", "Đã hủy theo dõi");
            } else {
                redirectAttributes.addFlashAttribute("error", "Không thể hủy theo dõi");
            }

        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        return getRedirectUrl(redirectPage, request);
    }
    
    // Enhanced helper method to determine redirect URL
    private String getRedirectUrl(String redirectPage, HttpServletRequest request) {
        switch (redirectPage) {
            case "profile":
                return "redirect:/profile";
            case "dashboard":
            default:
                return "redirect:/dashboard";
        }
    }
}