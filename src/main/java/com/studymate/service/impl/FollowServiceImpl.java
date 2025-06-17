package com.studymate.service.impl;

import com.studymate.dao.FollowDao;
import com.studymate.dao.impl.FollowDaoImpl;
import com.studymate.model.User;
import com.studymate.service.FollowService;

import java.util.List;

public class FollowServiceImpl implements FollowService {
    private final FollowDao followDao = new FollowDaoImpl();

    @Override
    public boolean follow(int followerId, int followeeId) throws Exception {
        return followDao.create(followerId, followeeId);
    }

    @Override
    public boolean unfollow(int followerId, int followeeId) throws Exception {
        return followDao.delete(followerId, followeeId);
    }

    @Override
    public List<User> getFollowers(int userId) throws Exception {
        return followDao.findFollowers(userId);
    }

    @Override
    public List<User> getFollowees(int userId) throws Exception {
        return followDao.findFollowees(userId);
    }
    
    @Override
    public boolean isFollowing(int followerId, int followeeId) throws Exception {
        return followDao.isFollowing(followerId, followeeId);
    }
}