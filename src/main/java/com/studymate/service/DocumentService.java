package com.studymate.service;

import com.studymate.model.Document;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

public interface DocumentService {
    void uploadDocument(Document document, MultipartFile file) throws IOException;
    List<Document> getAllDocuments();
    Document getDocumentById(int documentId);
    void deleteDocument(int documentId);
} 