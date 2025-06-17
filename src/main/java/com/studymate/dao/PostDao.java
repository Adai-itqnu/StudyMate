package com.studymate.dao;

import com.studymate.model.Post;
import java.util.List;

public interface PostDao {
    int create(Post post) throws Exception;
    List<Post> findAll() throws Exception;
    List<Post> findAllWithDetails() throws Exception;
    boolean delete(int postId) throws Exception;
    Post findById(int postId);
}
