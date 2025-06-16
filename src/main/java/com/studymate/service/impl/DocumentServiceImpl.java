package com.studymate.service.impl;

import com.studymate.dao.DocumentDao;
import com.studymate.model.Document;
import com.studymate.service.DocumentService;
import com.studymate.util.CloudStorageUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@Service
public class DocumentServiceImpl implements DocumentService {

    @Autowired
    private DocumentDao documentDao;

    @Autowired
    private CloudStorageUtil cloudStorageUtil;

    @Override
    public void uploadDocument(Document document, MultipartFile file) throws IOException {
        String fileUrl = cloudStorageUtil.uploadFile(file);
        document.setFileUrl(fileUrl);
        try {
            documentDao.addDocument(document);
        } catch (SQLException e) {
            throw new RuntimeException("Error uploading document", e);
        }
    }

    @Override
    public List<Document> getAllDocuments() {
        try {
            return documentDao.getAllDocuments();
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving documents", e);
        }
    }

    @Override
    public Document getDocumentById(int documentId) {
        try {
            return documentDao.getDocumentById(documentId);
        } catch (SQLException e) {
            throw new RuntimeException("Error retrieving document by ID", e);
        }
    }

    @Override
    public void deleteDocument(int documentId) {
        try {
            documentDao.deleteDocument(documentId);
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting document", e);
        }
    }
} 