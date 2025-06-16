package com.studymate.controller;

import com.studymate.model.Note;
import com.studymate.model.User;
import com.studymate.service.NoteService;
import com.studymate.service.UserService;
import com.studymate.service.impl.NoteServiceImpl;
import com.studymate.service.impl.UserServiceImpl;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@Controller
@RequestMapping("/notes")
public class NoteController {
    private final NoteService noteService = new NoteServiceImpl();
    private final UserService userService = new UserServiceImpl();

    @GetMapping
    public String listNotes(HttpSession session, Model model) throws Exception {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) return "redirect:/login";
        List<Note> notes = noteService.findByUserId(current.getUserId());
        model.addAttribute("notes", notes);
        List<User> suggestions = userService.getFollowSuggestions(current.getUserId());
        model.addAttribute("suggestions", suggestions);
        return "notes";
    }

    @PostMapping("/create")
    public String createNote(@RequestParam String content, HttpSession session, Model model) throws Exception {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) return "redirect:/login";
        Note note = new Note();
        note.setUserId(current.getUserId());
        note.setContent(content);
        noteService.create(note);

        List<User> suggestions = userService.getFollowSuggestions(current.getUserId());
        model.addAttribute("suggestions", suggestions);

        return "redirect:/notes";
    }

    @PostMapping("/update")
    public String updateNote(@RequestParam int noteId, @RequestParam String content, HttpSession session, Model model) throws Exception {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) return "redirect:/login";
        Note note = noteService.findById(noteId);
        if (note != null && note.getUserId() == current.getUserId()) {
            note.setContent(content);
            noteService.update(note);
        }

        List<User> suggestions = userService.getFollowSuggestions(current.getUserId());
        model.addAttribute("suggestions", suggestions);

        return "redirect:/notes";
    }

    @PostMapping("/delete")
    public String deleteNote(@RequestParam int noteId, HttpSession session, Model model) throws Exception {
        User current = (User) session.getAttribute("currentUser");
        if (current == null) return "redirect:/login";
        Note note = noteService.findById(noteId);
        if (note != null && note.getUserId() == current.getUserId()) {
            noteService.delete(noteId);
        }

        List<User> suggestions = userService.getFollowSuggestions(current.getUserId());
        model.addAttribute("suggestions", suggestions);

        return "redirect:/notes";
    }
} 