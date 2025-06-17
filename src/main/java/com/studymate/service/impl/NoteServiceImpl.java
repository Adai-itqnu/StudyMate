package com.studymate.service.impl;

import com.studymate.dao.NoteDao;
import com.studymate.dao.impl.NoteDaoImpl;
import com.studymate.model.Note;
import com.studymate.service.NoteService;
import java.util.List;

public class NoteServiceImpl implements NoteService {
    private final NoteDao noteDao = new NoteDaoImpl();

    @Override
    public int create(Note note) throws Exception {
        return noteDao.create(note);
    }

    @Override
    public boolean update(Note note) throws Exception {
        return noteDao.update(note);
    }

    @Override
    public boolean delete(int noteId) throws Exception {
        return noteDao.delete(noteId);
    }

    @Override
    public Note findById(int noteId) throws Exception {
        return noteDao.findById(noteId);
    }

    @Override
    public List<Note> findByUserId(int userId) throws Exception {
        return noteDao.findByUserId(userId);
    }
} 