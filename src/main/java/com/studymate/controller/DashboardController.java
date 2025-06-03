package com.studymate.controller;

import com.studymate.dao.PostDAO;
import com.studymate.dao.UserDAO;
import com.studymate.model.Post;
import com.studymate.model.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/dashboard")
public class DashboardController {
    
    @Autowired
    private PostDAO postDAO;
    
    @Autowired
    private UserDAO userDAO;
    
    private static final String UPLOAD_DIR = "uploads/";
    private static final int MAX_POSTS_PER_PAGE = 10;
    private static final int MAX_SUGGESTED_USERS = 5;
    
    @GetMapping
    public String dashboard(Model model, HttpSession session) {
        // Kiểm tra đăng nhập
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/user/login";
        }
        
        try {
            // Lấy danh sách bài đăng cho feed của user hiện tại
            List<Post> feedPosts = postDAO.getFeedPosts(currentUser.getId(), MAX_POSTS_PER_PAGE);
            
            // Nếu không có bài đăng từ người theo dõi, lấy bài đăng công khai
//            if (feedPosts == null || feedPosts.isEmpty()) {
//                feedPosts = postDAO.getRecentPosts(MAX_POSTS_PER_PAGE);
//            }
            
            if (feedPosts == null) {
                feedPosts = new ArrayList<>();
            }
            
            // Kiểm tra trạng thái like cho từng bài đăng
            feedPosts.forEach(post -> {
                try {
                    boolean isLiked = postDAO.isLikedByUser(post.getId(), currentUser.getId());
                    post.setLikedByCurrentUser(isLiked);
                    
                    // Đảm bảo có đầy đủ thông tin user cho post
                    if (post.getUser() == null) {
                        User postUser = userDAO.getUserById(post.getId());
                        post.setUser(postUser);
                    }
                } catch (Exception e) {
                    System.err.println("Error processing post " + post.getId() + ": " + e.getMessage());
                }
            });
            
            // Lấy danh sách người dùng gợi ý
            List<User> suggestedUsers = getSuggestedUsers(currentUser.getId());
            
            // Lấy thống kê người theo dõi
            int followerCount = 0;
            int followingCount = 0;
            
            try {
                List<User> followers = userDAO.getFollowers(currentUser.getId());
                List<User> following = userDAO.getFollowing(currentUser.getId());
                followerCount = followers != null ? followers.size() : 0;
                followingCount = following != null ? following.size() : 0;
            } catch (Exception e) {
                System.err.println("Error getting follow counts: " + e.getMessage());
            }
            
            // Thêm dữ liệu vào model
            model.addAttribute("user", currentUser);
            model.addAttribute("posts", feedPosts);
            model.addAttribute("suggestedUsers", suggestedUsers);
            model.addAttribute("followerCount", followerCount);
            model.addAttribute("followingCount", followingCount);
            
            // Thêm thông báo nếu có
            if (feedPosts.isEmpty()) {
                model.addAttribute("noPostsMessage", "Chưa có bài đăng nào. Hãy theo dõi một số người bạn hoặc tạo bài đăng đầu tiên!");
            }
            
            return "dashboard";
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error loading dashboard: " + e.getMessage());
            
            // Thêm thông tin cơ bản để trang không bị crash
            model.addAttribute("user", currentUser);
            model.addAttribute("posts", new ArrayList<Post>());
            model.addAttribute("suggestedUsers", new ArrayList<User>());
            model.addAttribute("followerCount", 0);
            model.addAttribute("followingCount", 0);
            model.addAttribute("error", "Có lỗi xảy ra khi tải dữ liệu. Vui lòng thử lại sau.");
            
            return "dashboard";
        }
    }
    
    /**
     * Xử lý tạo bài đăng mới với file upload
     */
    @PostMapping("/post/create")
    public String createPost(
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            @RequestParam(value = "file", required = false) MultipartFile file,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/user/login";
        }
        
        try {
            // Validate input
            if (title == null || title.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Tiêu đề không được để trống");
                return "redirect:/dashboard";
            }
            
            if (content == null || content.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("error", "Nội dung không được để trống");
                return "redirect:/dashboard";
            }
            
            Post post = new Post();
            post.setUser(currentUser);
            post.setTitle(title.trim());
            post.setContent(content.trim());
            post.setSubjectId(0); // Không liên quan đến môn học cụ thể
            
            // Xử lý file upload nếu có
            if (file != null && !file.isEmpty()) {
                String fileName = saveUploadedFile(file);
                if (fileName != null) {
                    post.setFilePath(fileName);
                    post.setFileType(getFileType(file.getContentType()));
                }
            }
            
            if (postDAO.createPost(post)) {
                redirectAttributes.addFlashAttribute("message", "Đăng bài thành công!");
            } else {
                redirectAttributes.addFlashAttribute("error", "Đăng bài thất bại. Vui lòng thử lại.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            redirectAttributes.addFlashAttribute("error", "Có lỗi xảy ra khi đăng bài: " + e.getMessage());
        }
        
        return "redirect:/dashboard";
    }
    
    /**
     * Xử lý follow/unfollow user
     */
    @PostMapping("/user/follow")
    @ResponseBody
    public Map<String, Object> followUser(@RequestParam("userId") int userId, 
                                         HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            response.put("success", false);
            response.put("message", "Bạn cần đăng nhập");
            return response;
        }
        
        if (currentUser.getId() == userId) {
            response.put("success", false);
            response.put("message", "Không thể theo dõi chính mình");
            return response;
        }
        
        try {
            boolean isCurrentlyFollowing = userDAO.isFollowing(currentUser.getId(), userId);
            
            if (isCurrentlyFollowing) {
                // Unfollow
                if (userDAO.unfollowUser(currentUser.getId(), userId)) {
                    response.put("success", true);
                    response.put("action", "unfollowed");
                    response.put("message", "Đã hủy theo dõi");
                } else {
                    response.put("success", false);
                    response.put("message", "Không thể hủy theo dõi");
                }
            } else {
                // Follow
                if (userDAO.followUser(currentUser.getId(), userId)) {
                    response.put("success", true);
                    response.put("action", "followed");
                    response.put("message", "Đã theo dõi thành công");
                } else {
                    response.put("success", false);
                    response.put("message", "Không thể theo dõi");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "Có lỗi xảy ra");
        }
        
        return response;
    }
    
    /**
     * Lấy danh sách người dùng gợi ý
     */
    private List<User> getSuggestedUsers(int currentUserId) {
        try {
            // Lấy danh sách tất cả người dùng
            List<User> allUsers = userDAO.searchUsers("");
            if (allUsers == null || allUsers.isEmpty()) {
                return new ArrayList<>();
            }
            
            // Lấy danh sách người đang theo dõi
            List<User> following = userDAO.getFollowing(currentUserId);
            Set<Integer> followingIds = new HashSet<>();
            if (following != null) {
                followingIds = following.stream()
                    .map(User::getId)
                    .collect(Collectors.toSet());
            }
            
            // Lọc bỏ user hiện tại và những người đã follow
            final Set<Integer> finalFollowingIds = followingIds;
            List<User> suggestedUsers = allUsers.stream()
                .filter(user -> user.getId() != currentUserId)
                .filter(user -> !finalFollowingIds.contains(user.getId()))
                .limit(MAX_SUGGESTED_USERS)
                .collect(Collectors.toList());
            
            return suggestedUsers;
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error getting suggested users: " + e.getMessage());
            return new ArrayList<>();
        }
    }
    
    /**
     * Lưu file upload
     */
    private String saveUploadedFile(MultipartFile file) {
        try {
            // Tạo thư mục upload nếu chưa tồn tại
            File uploadDir = new File(UPLOAD_DIR);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            // Tạo tên file unique
            String originalFileName = file.getOriginalFilename();
            String extension = "";
            if (originalFileName != null && originalFileName.contains(".")) {
                extension = originalFileName.substring(originalFileName.lastIndexOf("."));
            }
            
            String fileName = System.currentTimeMillis() + "_" + UUID.randomUUID().toString() + extension;
            Path filePath = Paths.get(UPLOAD_DIR + fileName);
            
            // Lưu file
            Files.copy(file.getInputStream(), filePath);
            
            return fileName;
            
        } catch (IOException e) {
            e.printStackTrace();
            System.err.println("Error saving uploaded file: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Xác định loại file
     */
    private String getFileType(String contentType) {
        if (contentType == null) return "OTHER";
        
        if (contentType.startsWith("image/")) {
            return "IMAGE";
        } else if (contentType.equals("application/pdf")) {
            return "PDF";
        } else if (contentType.contains("document") || contentType.contains("word")) {
            return "DOCUMENT";
        } else {
            return "OTHER";
        }
    }
}