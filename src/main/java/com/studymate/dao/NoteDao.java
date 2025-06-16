package com.studymate.dao;

import com.studymate.model.Note;

import java.sql.SQLException;
import java.util.List;

public interface NoteDao {
    void addNote(Note note) throws SQLException;
    List<Note> getAllNotes() throws SQLException;
    Note getNoteById(int noteId) throws SQLException;
    void updateNote(Note note) throws SQLException;
    void deleteNote(int noteId) throws SQLException;
    List<Note> getNotesByUserId(int userId) throws SQLException;
} 