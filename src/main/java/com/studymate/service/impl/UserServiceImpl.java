package com.studymate.service.impl;

import com.studymate.dao.UserDao;
import com.studymate.dao.impl.UserDaoImpl;
import com.studymate.model.User;
import com.studymate.service.UserService;
import com.studymate.util.PasswordUtil;
import java.util.List;

public class UserServiceImpl implements UserService {
    private final UserDao userDao = new UserDaoImpl();

    @Override
    public int register(User user) throws Exception {
        if (userDao.findByEmail(user.getEmail()) != null) {
            throw new Exception("Email đã được đăng ký");
        }
        user.setPassword(PasswordUtil.hash(user.getPassword()));
        return userDao.create(user);
    }

    @Override
    public User login(String email, String password) throws Exception {
        User user = userDao.findByEmail(email);
        if (user != null && PasswordUtil.verify(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    @Override
    public List<User> findAll() throws Exception {
        return userDao.findAll();
    }
}
