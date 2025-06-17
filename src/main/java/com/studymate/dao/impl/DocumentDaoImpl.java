package com.studymate.dao.impl;

import com.studymate.dao.DocumentDao;
import com.studymate.model.Document;
import com.studymate.util.DBConnectionUtil;
import java.sql.*;
import java.util.*;

public class DocumentDaoImpl implements DocumentDao {
    @Override
    public int create(Document document) throws Exception {
        String sql = "INSERT INTO documents (uploader_id, title, description, file_url) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, document.getUploaderId());
            ps.setString(2, document.getTitle());
            ps.setString(3, document.getDescription());
            ps.setString(4, document.getFileUrl());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }
    @Override
    public List<Document> findAll() throws Exception {
        List<Document> list = new ArrayList<>();
        String sql = "SELECT * FROM documents ORDER BY uploaded_at DESC";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Document d = new Document();
                d.setDocumentId(rs.getInt("document_id"));
                d.setUploaderId(rs.getInt("uploader_id"));
                d.setTitle(rs.getString("title"));
                d.setDescription(rs.getString("description"));
                d.setFileUrl(rs.getString("file_url"));
                d.setUploadedAt(rs.getTimestamp("uploaded_at"));
                list.add(d);
            }
        }
        return list;
    }
    @Override
    public Document findById(int documentId) throws Exception {
        String sql = "SELECT * FROM documents WHERE document_id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, documentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Document d = new Document();
                    d.setDocumentId(rs.getInt("document_id"));
                    d.setUploaderId(rs.getInt("uploader_id"));
                    d.setTitle(rs.getString("title"));
                    d.setDescription(rs.getString("description"));
                    d.setFileUrl(rs.getString("file_url"));
                    d.setUploadedAt(rs.getTimestamp("uploaded_at"));
                    return d;
                }
            }
        }
        return null;
    }
    @Override
    public boolean delete(int documentId) throws Exception {
        String sql = "DELETE FROM documents WHERE document_id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, documentId);
            return ps.executeUpdate() > 0;
        }
    }
} 