package com.studymate.service;

import com.studymate.model.Note;

import java.sql.SQLException;
import java.util.List;

public interface NoteService {
    void addNote(Note note);
    List<Note> getAllNotes();
    Note getNoteById(int noteId);
    void updateNote(Note note);
    void deleteNote(int noteId);
    List<Note> getNotesByUserId(int userId);
} 