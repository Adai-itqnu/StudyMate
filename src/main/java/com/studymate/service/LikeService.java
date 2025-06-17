package com.studymate.service;

public interface LikeService {
    boolean likePost(int userId, int postId) throws Exception;
    boolean unlikePost(int userId, int postId) throws Exception;
    int countLikes(int postId) throws Exception;
    boolean isLiked(int userId, int postId) throws Exception;
}