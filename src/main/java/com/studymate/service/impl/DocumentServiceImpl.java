package com.studymate.service.impl;

import com.studymate.dao.DocumentDao;
import com.studymate.dao.impl.DocumentDaoImpl;
import com.studymate.model.Document;
import com.studymate.service.DocumentService;
import java.util.List;

public class DocumentServiceImpl implements DocumentService {
    private final DocumentDao documentDao = new DocumentDaoImpl();
    @Override
    public int create(Document document) throws Exception {
        return documentDao.create(document);
    }
    @Override
    public List<Document> findAll() throws Exception {
        return documentDao.findAll();
    }
    @Override
    public Document findById(int documentId) throws Exception {
        return documentDao.findById(documentId);
    }
    @Override
    public boolean delete(int documentId) throws Exception {
        return documentDao.delete(documentId);
    }
} 	