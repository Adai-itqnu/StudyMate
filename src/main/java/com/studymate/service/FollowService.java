package com.studymate.service;

import com.studymate.model.User;
import java.util.List;

public interface FollowService {
    boolean follow(int followerId, int followeeId) throws Exception;
    boolean unfollow(int followerId, int followeeId) throws Exception;
    List<User> getFollowers(int userId) throws Exception;
    List<User> getFollowees(int userId) throws Exception;
}