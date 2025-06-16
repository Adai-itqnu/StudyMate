package com.studymate.dao.impl;

import com.studymate.dao.DocumentDao;
import com.studymate.model.Document;
import com.studymate.util.DBConnectionUtil;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class DocumentDaoImpl implements DocumentDao {

    @Override
    public void addDocument(Document document) throws SQLException {
        String sql = "INSERT INTO documents (user_id, title, description, file_url, upload_date) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, document.getUserId());
            stmt.setString(2, document.getTitle());
            stmt.setString(3, document.getDescription());
            stmt.setString(4, document.getFileUrl());
            stmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
            stmt.executeUpdate();

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    document.setDocumentId(generatedKeys.getInt(1));
                }
            }
        }
    }

    @Override
    public List<Document> getAllDocuments() throws SQLException {
        List<Document> documents = new ArrayList<>();
        String sql = "SELECT * FROM documents";
        try (Connection conn = DBConnectionUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                documents.add(mapRowToDocument(rs));
            }
        }
        return documents;
    }

    @Override
    public Document getDocumentById(int documentId) throws SQLException {
        String sql = "SELECT * FROM documents WHERE document_id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, documentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapRowToDocument(rs);
                }
            }
        }
        return null;
    }

    @Override
    public void deleteDocument(int documentId) throws SQLException {
        String sql = "DELETE FROM documents WHERE document_id = ?";
        try (Connection conn = DBConnectionUtil.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, documentId);
            stmt.executeUpdate();
        }
    }

    private Document mapRowToDocument(ResultSet rs) throws SQLException {
        Document document = new Document();
        document.setDocumentId(rs.getInt("document_id"));
        document.setUserId(rs.getInt("user_id"));
        document.setTitle(rs.getString("title"));
        document.setDescription(rs.getString("description"));
        document.setFileUrl(rs.getString("file_url"));
        document.setUploadDate(rs.getTimestamp("upload_date"));
        return document;
    }
}
