package com.studymate.dao;

import java.util.List;
import com.studymate.model.Share;

public interface ShareDao {
    int create(int userId, int postId) throws Exception;
    List<Share> findByPostId(int postId) throws Exception;
}