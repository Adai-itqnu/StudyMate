package com.studymate.service;

public interface LikeService {
    boolean likePost(int userId, int postId) throws Exception;
    boolean unlikePost(int userId, int postId) throws Exception;
    int countLikes(int postId) throws Exception;
    boolean likeComment(int userId, int commentId) throws Exception; // Thêm
    boolean unlikeComment(int userId, int commentId) throws Exception; // Thêm
    int countCommentLikes(int commentId) throws Exception; // Thêm
}