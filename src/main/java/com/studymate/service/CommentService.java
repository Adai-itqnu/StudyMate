package com.studymate.service;

import com.studymate.model.Comment;
import java.util.List;

public interface CommentService {
    int addComment(Comment comment) throws Exception;
    boolean deleteComment(int commentId) throws Exception;
    List<Comment> getCommentsByPost(int postId) throws Exception;
}