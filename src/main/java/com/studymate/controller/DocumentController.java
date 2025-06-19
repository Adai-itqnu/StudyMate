package com.studymate.controller;

import com.studymate.model.Document;
import com.studymate.model.User;
import com.studymate.service.DocumentService;
import com.studymate.service.UserService;
import com.studymate.service.impl.DocumentServiceImpl;
import com.studymate.service.impl.UserServiceImpl;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Controller
@RequestMapping("/documents")
public class DocumentController {
    private final DocumentService documentService = new DocumentServiceImpl();
    private final UserService userService = new UserServiceImpl();

    @GetMapping
    public String listDocuments(HttpSession session, Model model) throws Exception {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) return "redirect:/login";
        List<Document> documents = documentService.findAll();
        model.addAttribute("documents", documents);
        // Gợi ý theo dõi
        List<User> suggestions = userService.findAll();
        suggestions.removeIf(u -> u.getUserId() == current.getUserId());
        model.addAttribute("suggestions", suggestions);
        model.addAttribute("currentUser", current);
        return "documents";
    }

    @GetMapping("/upload")
    public String uploadForm(HttpSession session, Model model) throws Exception {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) return "redirect:/login";
        // Gợi ý theo dõi
        List<User> suggestions = userService.findAll();
        suggestions.removeIf(u -> u.getUserId() == current.getUserId());
        model.addAttribute("suggestions", suggestions);
        model.addAttribute("currentUser", current);
        return "document_upload";
    }

    @PostMapping("/upload")
    public String handleUpload(
        @RequestParam("file") MultipartFile file,
        @RequestParam(value = "title", required = false) String title,
        @RequestParam(value = "description", required = false) String description,
        HttpSession session,
        Model model,
        HttpServletRequest request
    ) {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) return "redirect:/login";
        
        if (file == null || file.isEmpty()) {
            model.addAttribute("error", "Vui lòng chọn file để upload!");
            return "document_upload";
        }
        
        try {
            // Lưu file vào thư mục uploads
            String uploadDir = request.getServletContext().getRealPath("/resources/uploads/");
            System.out.println("📁 Upload directory: " + uploadDir);
            
            File dir = new File(uploadDir);
            if (!dir.exists()) {
                boolean created = dir.mkdirs();
                System.out.println("📁 Created upload directory: " + created);
            }

            String originalFilename = file.getOriginalFilename();
            System.out.println("📄 Original filename: " + originalFilename);
            
            // Tạo tên file unique với timestamp
            String uniqueFilename = System.currentTimeMillis() + "_" + originalFilename;
            File destFile = new File(dir, uniqueFilename);
            
            System.out.println("💾 Saving file to: " + destFile.getAbsolutePath());
            file.transferTo(destFile);
            
            // Kiểm tra file đã được lưu chưa
            if (destFile.exists()) {
                System.out.println("✅ File saved successfully, size: " + destFile.length() + " bytes");
            } else {
                System.out.println("❌ File was not saved!");
                model.addAttribute("error", "Không thể lưu file!");
                return "document_upload";
            }

            // Lưu thông tin document vào DB
            Document doc = new Document();
            doc.setUploaderId(current.getUserId());
            String fileUrl = "/resources/uploads/" + uniqueFilename;
            doc.setFileUrl(fileUrl);
            doc.setTitle(title != null && !title.trim().isEmpty() ? title : originalFilename);
            doc.setDescription(description);
            doc.setUploadedAt(new java.util.Date());
            
            System.out.println("🗄️ Saving document to DB with URL: " + fileUrl);
            documentService.create(doc);

            model.addAttribute("message", "Upload thành công!");
            return "redirect:/documents";
            
        } catch (Exception e) {
            System.err.println("❌ Upload error: " + e.getMessage());
            e.printStackTrace();
            model.addAttribute("error", "Lỗi upload: " + e.getMessage());
            return "document_upload";
        }
    }

    @GetMapping("/download")
    public ResponseEntity<Resource> downloadFile(@RequestParam("path") String filePath, HttpServletRequest request) {
        try {
            System.out.println("⬇️ Download request for path: " + filePath);
            
            String realPath = request.getServletContext().getRealPath(filePath);
            System.out.println("📂 Real path: " + realPath);
            
            File file = new File(realPath);
            System.out.println("📄 File exists: " + file.exists());
            System.out.println("📄 File absolute path: " + file.getAbsolutePath());
            
            if (!file.exists()) {
                System.out.println("❌ File not found: " + realPath);
                return ResponseEntity.notFound().build();
            }
            
            FileSystemResource resource = new FileSystemResource(file);
            
            // Loại bỏ timestamp prefix từ tên file để hiển thị tên gốc
            String fileName = file.getName().replaceAll("^\\d+_", "");
            System.out.println("📄 Display filename: " + fileName);
            
            String contentType = request.getServletContext().getMimeType(file.getAbsolutePath());
            if (contentType == null) {
                contentType = "application/octet-stream";
            }
            System.out.println("📄 Content type: " + contentType);
            
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"")
                    .contentType(MediaType.parseMediaType(contentType))
                    .body(resource);
                    
        } catch (Exception e) {
            System.err.println("❌ Download error: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.internalServerError().build();
        }
    }
}