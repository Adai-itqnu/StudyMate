package com.studymate.service.impl;

import com.studymate.dao.UserDao;
import com.studymate.dao.PostDao;
import com.studymate.dao.impl.UserDaoImpl;
import com.studymate.dao.impl.PostDaoImpl;
import com.studymate.model.User;
import com.studymate.model.Post;
import com.studymate.service.SearchService;

import java.util.List;
import java.util.stream.Collectors;

public class SearchServiceImpl implements SearchService {
    private final UserDao userDao = new UserDaoImpl();
    private final PostDao postDao = new PostDaoImpl();

    @Override
    public List<User> searchUsers(String keyword) throws Exception {
        String q = "%" + keyword + "%".toLowerCase();
        return userDao.findAll().stream()
            .filter(u -> u.getUsername().toLowerCase().contains(keyword.toLowerCase())
                       || u.getFullName().toLowerCase().contains(keyword.toLowerCase())
                       || u.getEmail().toLowerCase().contains(keyword.toLowerCase()))
            .collect(Collectors.toList());
    }

//    @Override
//    public List<Post> searchPosts(String keyword) throws Exception {
//       // return postDao.search(keyword);
//    }
}