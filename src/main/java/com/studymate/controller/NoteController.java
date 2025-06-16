package com.studymate.controller;

import com.studymate.model.Note;
import com.studymate.model.User;
import com.studymate.service.NoteService;
import com.studymate.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/notes")
public class NoteController {

    @Autowired
    private NoteService noteService;

    @Autowired
    private UserService userService;

    @GetMapping
    public String notesPage(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        List<Note> notes = noteService.getNotesByUserId(currentUser.getUserId());
        model.addAttribute("notes", notes);

        List<User> allUsers = userService.getAllUsers();
        List<User> suggestions = allUsers.stream()
                .filter(user -> !user.getUsername().equals(currentUser.getUsername()))
                .collect(Collectors.toList());
        model.addAttribute("suggestions", suggestions);

        model.addAttribute("note", new Note()); // For new note creation form
        return "notes";
    }

    @PostMapping
    public String addNote(@ModelAttribute Note note, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        note.setUserId(currentUser.getUserId());
        noteService.addNote(note);
        return "redirect:/notes";
    }

    @GetMapping("/edit/{noteId}")
    public String editNotePage(@PathVariable int noteId, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        Note note = noteService.getNoteById(noteId);
        if (note == null || note.getUserId() != currentUser.getUserId()) {
            return "redirect:/notes"; // Or show an error
        }
        model.addAttribute("note", note);

        List<User> allUsers = userService.getAllUsers();
        List<User> suggestions = allUsers.stream()
                .filter(user -> !user.getUsername().equals(currentUser.getUsername()))
                .collect(Collectors.toList());
        model.addAttribute("suggestions", suggestions);

        return "notes"; // Reusing the notes page for editing
    }

    @PostMapping("/update")
    public String updateNote(@ModelAttribute Note note, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        Note existingNote = noteService.getNoteById(note.getNoteId());
        if (existingNote != null && existingNote.getUserId() == currentUser.getUserId()) {
            noteService.updateNote(note);
        }
        return "redirect:/notes";
    }

    @GetMapping("/delete/{noteId}")
    public String deleteNote(@PathVariable int noteId, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/login";
        }
        Note note = noteService.getNoteById(noteId);
        if (note != null && note.getUserId() == currentUser.getUserId()) {
            noteService.deleteNote(noteId);
        }
        return "redirect:/notes";
    }
} 