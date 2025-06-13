package com.studymate.service;

import com.studymate.dao.UserDao;
import com.studymate.dao.PostDao;
import com.studymate.model.User;
import com.studymate.model.Post;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.ArrayList;

@Service
public class SearchService {
    
    @Autowired
    private UserDao userDao;
    
    @Autowired
    private PostDao postDao;
    
    // Tìm kiếm người dùng theo tên
    public List<User> searchUsers(String keyword) {
        try {
            return userDao.searchByName(keyword);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    // Tìm kiếm bài viết theo tiêu đề
    public List<Post> searchPosts(String keyword) {
        try {
            return postDao.searchByTitle(keyword);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    // Tìm kiếm tổng hợp
    public SearchResult searchAll(String keyword) {
        SearchResult result = new SearchResult();
        result.setUsers(searchUsers(keyword));
        result.setPosts(searchPosts(keyword));
        return result;
    }
    
    // Class kết quả tìm kiếm
    public static class SearchResult {
        private List<User> users;
        private List<Post> posts;
        
        public SearchResult() {
            this.users = new ArrayList<>();
            this.posts = new ArrayList<>();
        }
        
        // Getters and Setters
        public List<User> getUsers() { return users; }
        public void setUsers(List<User> users) { this.users = users; }
        
        public List<Post> getPosts() { return posts; }
        public void setPosts(List<Post> posts) { this.posts = posts; }
    }
}