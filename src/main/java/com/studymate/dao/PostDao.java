package com.studymate.dao;

import com.studymate.model.Post;
import java.util.List;

public interface PostDao {
    int create(Post post) throws Exception;
    List<Post> findAll() throws Exception;
}
