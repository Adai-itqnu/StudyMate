package com.studymate.service;

import com.studymate.model.Share;
import java.util.List;

public interface ShareService {
    int sharePost(int userId, int postId) throws Exception;
    List<Share> getSharesByPost(int postId) throws Exception;
}