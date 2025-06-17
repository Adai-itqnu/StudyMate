package com.studymate.dao.impl;

import com.studymate.dao.NoteDao;
import com.studymate.model.Note;
import com.studymate.util.DBConnectionUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NoteDaoImpl implements NoteDao {
    private static final String INSERT_SQL = "INSERT INTO notes (user_id, content, created_at, updated_at) VALUES (?, ?, NOW(), NOW())";
    private static final String UPDATE_SQL = "UPDATE notes SET content=?, updated_at=NOW() WHERE note_id=? AND user_id=?";
    private static final String DELETE_SQL = "DELETE FROM notes WHERE note_id=? AND user_id=?";
    private static final String SELECT_BY_ID = "SELECT * FROM notes WHERE note_id=?";
    private static final String SELECT_BY_USER = "SELECT * FROM notes WHERE user_id=? ORDER BY updated_at DESC";

    @Override
    public int create(Note note) throws Exception {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_SQL, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, note.getUserId());
            ps.setString(2, note.getContent());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                return rs.next() ? rs.getInt(1) : -1;
            }
        }
    }

    @Override
    public boolean update(Note note) throws Exception {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(UPDATE_SQL)) {
            ps.setString(1, note.getContent());
            ps.setInt(2, note.getNoteId());
            ps.setInt(3, note.getUserId());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(int noteId) throws Exception {
        // Cần userId để bảo vệ quyền xóa, nhưng interface chỉ truyền noteId
        // Có thể sửa interface nếu cần, tạm thời chỉ xóa theo noteId
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement("DELETE FROM notes WHERE note_id=?")) {
            ps.setInt(1, noteId);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public Note findById(int noteId) throws Exception {
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_ID)) {
            ps.setInt(1, noteId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Note note = new Note();
                    note.setNoteId(rs.getInt("note_id"));
                    note.setUserId(rs.getInt("user_id"));
                    note.setContent(rs.getString("content"));
                    note.setCreatedAt(rs.getTimestamp("created_at"));
                    note.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return note;
                }
            }
        }
        return null;
    }

    @Override
    public List<Note> findByUserId(int userId) throws Exception {
        List<Note> list = new ArrayList<>();
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(SELECT_BY_USER)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Note note = new Note();
                    note.setNoteId(rs.getInt("note_id"));
                    note.setUserId(rs.getInt("user_id"));
                    note.setContent(rs.getString("content"));
                    note.setCreatedAt(rs.getTimestamp("created_at"));
                    note.setUpdatedAt(rs.getTimestamp("updated_at"));
                    list.add(note);
                }
            }
        }
        return list;
    }
} 