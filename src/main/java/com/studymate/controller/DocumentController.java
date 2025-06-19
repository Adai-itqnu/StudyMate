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
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            String originalFilename = file.getOriginalFilename();
            String uniqueFilename = System.currentTimeMillis() + "_" + originalFilename;
            File destFile = new File(dir, uniqueFilename);
            file.transferTo(destFile);

            // Lưu thông tin document vào DB
            Document doc = new Document();
            doc.setUploaderId(current.getUserId());
            doc.setFileUrl("/resources/uploads/" + uniqueFilename);
            doc.setTitle(title != null ? title : originalFilename);
            doc.setDescription(description);
            doc.setUploadedAt(new java.util.Date());
            documentService.create(doc);

            model.addAttribute("message", "Upload thành công!");
            return "redirect:/documents";
        } catch (Exception e) {
            model.addAttribute("error", "Lỗi upload: " + e.getMessage());
            return "document_upload";
        }
    }

    @GetMapping("/download")
    public ResponseEntity<Resource> downloadFile(@RequestParam("path") String filePath, HttpServletRequest request) {
        try {
            String realPath = request.getServletContext().getRealPath(filePath);
            File file = new File(realPath);
            if (!file.exists()) {
                return ResponseEntity.notFound().build();
            }
            FileSystemResource resource = new FileSystemResource(file);
            String fileName = file.getName().replaceAll("^\\d+_", "");
            String contentType = request.getServletContext().getMimeType(file.getAbsolutePath());
            if (contentType == null) {
                contentType = "application/octet-stream";
            }
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"")
                    .contentType(MediaType.parseMediaType(contentType))
                    .body(resource);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }
}