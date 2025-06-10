package com.studymate.service;

import com.studymate.model.User;
import com.studymate.model.Post;
import java.util.List;

public interface SearchService {
    List<User> searchUsers(String keyword) throws Exception;
    List<Post> searchPosts(String keyword) throws Exception;
}