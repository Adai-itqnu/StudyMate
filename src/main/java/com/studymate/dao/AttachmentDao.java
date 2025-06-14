package com.studymate.dao;

import com.studymate.model.Attachment;
import java.util.List;

public interface AttachmentDao {
    int create(Attachment att) throws Exception;
    List<Attachment> findByPostId(int postId) throws Exception;
    /** Xóa attachment theo attachmentId */
    boolean deleteById(int attachmentId) throws Exception;
}
