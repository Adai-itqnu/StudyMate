package com.studymate.controller;

import com.studymate.service.DocumentService;
import com.studymate.service.UserService;
import com.studymate.model.Document;
import com.studymate.model.User;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/documents")
public class DocumentController {

    @Autowired
    private DocumentService documentService;

    @Autowired
    private UserService userService;

    @GetMapping
    public String documentsPage(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        List<Document> documents = documentService.getAllDocuments();
        model.addAttribute("documents", documents);

        List<User> allUsers = userService.getAllUsers();
        List<User> suggestions = allUsers.stream()
                .filter(user -> !user.getUsername().equals(currentUser.getUsername()))
                .collect(Collectors.toList());
        model.addAttribute("suggestions", suggestions);
        return "documents";
    }

    @GetMapping("/upload")
    public String uploadDocumentPage(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        model.addAttribute("document", new Document());
        
        List<User> allUsers = userService.getAllUsers();
        List<User> suggestions = allUsers.stream()
                .filter(user -> !user.getUsername().equals(currentUser.getUsername()))
                .collect(Collectors.toList());
        model.addAttribute("suggestions", suggestions);
        return "document_upload";
    }

    @PostMapping("/upload")
    public String uploadDocument(@ModelAttribute Document document, @RequestParam("file") MultipartFile file, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        try {
            document.setUserId(currentUser.getUserId());
            documentService.uploadDocument(document, file);
        } catch (IOException e) {
            e.printStackTrace();
            // Handle error
        }
        return "redirect:/documents";
    }
}
