package com.studymate.controller;

import com.studymate.model.Document;
import com.studymate.model.User;
import com.studymate.service.DocumentService;
import com.studymate.service.UserService;
import com.studymate.service.impl.DocumentServiceImpl;
import com.studymate.service.impl.UserServiceImpl;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
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
}