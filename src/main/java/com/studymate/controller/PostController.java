package com.studymate.controller;

import com.studymate.model.Attachment;
import com.studymate.model.Post;
import com.studymate.model.User;
import com.studymate.service.PostService;
import com.studymate.service.impl.PostServiceImpl;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

@Controller
@RequestMapping("/posts")
public class PostController {
    private final PostService postService = new PostServiceImpl();

    @PostMapping("/create")
    public String createPost(
        @RequestParam String title,
        @RequestParam String body,
        @RequestParam String privacy,
        @RequestParam(required=false) MultipartFile attachment,
        HttpServletRequest request
    ) throws Exception {
        HttpSession session = request.getSession(false);
        User current = session == null ? null : (User) session.getAttribute("currentUser");
        if (current == null) {
            return "redirect:/login";
        }

        // 1) Xử lý file upload ở Controller
        String fileUrl = null;
        if (attachment != null && !attachment.isEmpty()) {
            String originalFilename = attachment.getOriginalFilename();
            if (originalFilename != null) {
                String filename = originalFilename.toLowerCase();
                
                // Kiểm tra định dạng file
                if (filename.endsWith(".jpg") || filename.endsWith(".jpeg") || filename.endsWith(".png")) {
                    
                    // Tạo đường dẫn thư mục upload
                    String uploadDir = request.getServletContext().getRealPath("/resources/uploads/");
                    File dir = new File(uploadDir);
                    if (!dir.exists()) {
                        dir.mkdirs();
                        System.out.println("Created upload directory: " + uploadDir);
                    }

                    // Tạo tên file unique
                    String uniqueFilename = System.currentTimeMillis() + "_" + originalFilename;
                    File destFile = new File(dir, uniqueFilename);
                    
                    try {
                        // Sử dụng transferTo để lưu file
                        attachment.transferTo(destFile);
                        
                        // Tạo URL để truy cập file
                        fileUrl = request.getContextPath() + "/resources/uploads/" + uniqueFilename;
                        
                        System.out.println("File saved successfully:");
                        System.out.println("- File path: " + destFile.getAbsolutePath());
                        System.out.println("- File URL: " + fileUrl);
                        System.out.println("- File exists: " + destFile.exists());
                        System.out.println("- File size: " + destFile.length() + " bytes");
                        
                    } catch (IOException e) {
                        System.err.println("Error saving file: " + e.getMessage());
                        e.printStackTrace();
                    }
                } else {
                    System.out.println("Invalid file format: " + filename);
                }
            }
        }

        // 2) Lưu post + attachment URL vào Service
        Post p = new Post();
        p.setUserId(current.getUserId());
        p.setTitle(title);
        p.setBody(body);
        p.setPrivacy(privacy);
        
        int postId = postService.create(p, fileUrl);
        System.out.println("Post created with ID: " + postId);

        return "redirect:/dashboard";
    }
}