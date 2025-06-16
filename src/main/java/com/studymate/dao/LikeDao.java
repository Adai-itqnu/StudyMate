package com.studymate.dao;

public interface LikeDao {
    boolean create(int userId, int postId) throws Exception;
    boolean delete(int userId, int postId) throws Exception;
    int countByPost(int postId) throws Exception;
    int countByPostId(int pid);
    boolean deleteByPostId(int postId) throws Exception;
    boolean createCommentLike(int userId, int commentId) throws Exception; // Thêm
    boolean deleteCommentLike(int userId, int commentId) throws Exception; // Thêm
    int countByComment(int commentId) throws Exception; // Thêm
}