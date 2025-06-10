package com.studymate.dao;

import com.studymate.model.Post;
import java.util.List;

public interface PostDao {
    /** Lấy danh sách tất cả bài viết */
    List<Post> findAll() throws Exception;
    /** Xóa bài viết theo ID */
    boolean delete(int postId) throws Exception;
    // Search bài viết
    List<Post> search(String keyword) throws Exception;
}