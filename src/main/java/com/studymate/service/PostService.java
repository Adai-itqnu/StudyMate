package com.studymate.service;

import com.studymate.model.Post;
import java.util.List;

public interface PostService {
    /** 
     * Tạo post; nếu fileUrl ≠ null thì tạo thêm attachment record 
     * trả về postId nếu cần, hoặc 0
     */
    int create(Post post, String fileUrl) throws Exception;
    List<Post> findAll() throws Exception;
}
