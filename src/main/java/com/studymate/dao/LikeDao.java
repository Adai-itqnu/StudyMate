package com.studymate.dao;

public interface LikeDao {
    boolean create(int userId, int postId) throws Exception;
    boolean delete(int userId, int postId) throws Exception;
    int countByPost(int postId) throws Exception;
    int countByPostId(int pid);
    boolean deleteByPostId(int postId) throws Exception;
    boolean isLiked(int userId, int postId) throws Exception;
}