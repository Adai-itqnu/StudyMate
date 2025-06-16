package com.studymate.service.impl;

import com.studymate.dao.NoteDao;
import com.studymate.model.Note;
import com.studymate.service.NoteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.SQLException;
import java.util.List;

@Service
public class NoteServiceImpl implements NoteService {

    @Autowired
    private NoteDao noteDao;

    @Override
    public void addNote(Note note) {
        try {
            noteDao.addNote(note);
        } catch (SQLException e) {
            throw new RuntimeException("Error adding note", e);
        }
    }

    @Override
    public List<Note> getAllNotes() {
        try {
            return noteDao.getAllNotes();
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving all notes", e);
        }
    }

    @Override
    public Note getNoteById(int noteId) {
        try {
            return noteDao.getNoteById(noteId);
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving note by ID", e);
        }
    }

    @Override
    public void updateNote(Note note) {
        try {
            noteDao.updateNote(note);
        } catch (SQLException e) {
            throw new RuntimeException("Error updating note", e);
        }
    }

    @Override
    public void deleteNote(int noteId) {
        try {
            noteDao.deleteNote(noteId);
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting note", e);
        }
    }

    @Override
    public List<Note> getNotesByUserId(int userId) {
        try {
            return noteDao.getNotesByUserId(userId);
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving notes by user ID", e);
        }
    }
} 