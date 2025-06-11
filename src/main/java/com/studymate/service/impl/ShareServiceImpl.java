package com.studymate.service.impl;

import com.studymate.dao.ShareDao;
import com.studymate.dao.impl.ShareDaoImpl;
import com.studymate.model.Share;
import com.studymate.service.ShareService;

import java.util.List;

public class ShareServiceImpl implements ShareService {
    private final ShareDao shareDao = new ShareDaoImpl();

    @Override
    public List<Share> getSharesByPost(int postId) throws Exception {
        return shareDao.findByPostId(postId);
    }

    @Override
    public int sharePost(int userId, int postId) throws Exception {
        Share s = new Share();
        s.setUserId(userId);
        s.setPostId(postId);
        return shareDao.create(s);
    }
}