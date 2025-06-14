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
    
    /** 
     * Lấy tất cả posts kèm chi tiết: attachments, likes, comments, shares 
     */
    List<Post> findAllWithDetails() throws Exception;			
    
    /** Xóa post và tất cả dữ liệu con (attachments, likes, comments, shares) */
    void delete(int postId) throws Exception;
}
