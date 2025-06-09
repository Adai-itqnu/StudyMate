package com.studymate.service;

import com.studymate.dao.PostDao;
import com.studymate.dao.PostDaoImpl;
import com.studymate.model.Post;
import com.studymate.service.PostService;
import java.util.List;

public class PostServiceImpl implements PostService {
    private final PostDao postDao = new PostDaoImpl();

    @Override
    public List<Post> findAll() throws Exception {
        return postDao.findAll();
    }

    @Override
    public boolean delete(int postId) throws Exception {
        return postDao.delete(postId);
    }
}