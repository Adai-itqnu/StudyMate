package com.studymate.dao;

import com.studymate.model.Document;

import java.sql.SQLException;
import java.util.List;

public interface DocumentDao {
    void addDocument(Document document) throws SQLException;
    List<Document> getAllDocuments() throws SQLException;
    Document getDocumentById(int documentId) throws SQLException;
    void deleteDocument(int documentId) throws SQLException;
} 