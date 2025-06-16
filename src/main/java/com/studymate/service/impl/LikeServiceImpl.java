package com.studymate.service.impl;

import com.studymate.dao.LikeDao;
import com.studymate.dao.impl.LikeDaoImpl;
import com.studymate.service.LikeService;

public class LikeServiceImpl implements LikeService {
    private final LikeDao likeDao = new LikeDaoImpl();

    @Override
    public boolean likePost(int userId, int postId) throws Exception {
        return likeDao.create(userId, postId);
    }

    @Override
    public boolean unlikePost(int userId, int postId) throws Exception {
        return likeDao.delete(userId, postId);
    }

    @Override
    public int countLikes(int postId) throws Exception {
        return likeDao.countByPost(postId);
    }

    @Override
    public boolean likeComment(int userId, int commentId) throws Exception {
        return likeDao.createCommentLike(userId, commentId);
    }

    @Override
    public boolean unlikeComment(int userId, int commentId) throws Exception {
        return likeDao.deleteCommentLike(userId, commentId);
    }

    @Override
    public int countCommentLikes(int commentId) throws Exception {
        return likeDao.countByComment(commentId);
    }
}