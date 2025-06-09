package com.studymate.service;

import com.studymate.model.Post;
import java.util.List;

public interface PostService {
    /**
     * Lấy danh sách tất cả bài viết
     */
    List<Post> findAll() throws Exception;

    /**
     * Xóa bài viết theo ID
     */
    boolean delete(int postId) throws Exception;
}