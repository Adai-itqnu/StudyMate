package com.studymate.dao;

import com.studymate.model.Document;
import java.util.List;

public interface DocumentDao {
    int create(Document document) throws Exception;
    List<Document> findAll() throws Exception;
    Document findById(int documentId) throws Exception;
    boolean delete(int documentId) throws Exception;
} 