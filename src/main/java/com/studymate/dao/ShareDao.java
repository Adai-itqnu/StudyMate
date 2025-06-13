package com.studymate.dao;

import java.util.List;
import com.studymate.model.Share;

public interface ShareDao {
	int create(Share share) throws Exception;
    List<Share> findByPostId(int postId) throws Exception;
    boolean deleteByPostId(int postId) throws Exception;
    boolean isShared(int userId, int postId);
    int getShareCount(int postId);
    boolean deleteShare(int userId, int postId);
}