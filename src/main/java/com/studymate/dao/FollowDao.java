package com.studymate.dao;

import java.util.List;
import com.studymate.model.User;

public interface FollowDao {
    boolean create(int followerId, int followeeId) throws Exception;
    boolean delete(int followerId, int followeeId) throws Exception;
    List<User> findFollowers(int userId) throws Exception;
    List<User> findFollowees(int userId) throws Exception;
}