package com.studymate.dao;

import java.util.List;
import com.studymate.model.Comment;

public interface CommentDao {
    int create(Comment comment) throws Exception;
    boolean delete(int commentId) throws Exception;
    List<Comment> findByPostId(int postId) throws Exception;
    boolean deleteByPostId(int postId) throws Exception;
    boolean updateComment(int commentId, String content) throws Exception;
}