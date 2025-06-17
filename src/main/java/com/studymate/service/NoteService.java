package com.studymate.service;

import com.studymate.model.Note;
import java.util.List;

public interface NoteService {
    int create(Note note) throws Exception;
    boolean update(Note note) throws Exception;
    boolean delete(int noteId) throws Exception;
    Note findById(int noteId) throws Exception;
    List<Note> findByUserId(int userId) throws Exception;
} 