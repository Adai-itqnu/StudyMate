package com.studymate.service.impl;

import com.studymate.dao.CommentDao;
import com.studymate.dao.impl.CommentDaoImpl;
import com.studymate.model.Comment;
import com.studymate.service.CommentService;

import java.util.List;

public class CommentServiceImpl implements CommentService {
    private final CommentDao commentDao = new CommentDaoImpl();

    @Override
    public int addComment(Comment comment) throws Exception {
        return commentDao.create(comment);
    }

    @Override
    public boolean deleteComment(int commentId) throws Exception {
        return commentDao.delete(commentId);
    }

    @Override
    public List<Comment> getCommentsByPost(int postId) throws Exception {
        return commentDao.findByPostId(postId);
    }
}