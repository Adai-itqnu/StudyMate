package com.studymate.dao;

public interface LikeDao {
    boolean create(int userId, int postId) throws Exception;
    boolean delete(int userId, int postId) throws Exception;
    int countByPost(int postId) throws Exception;
}