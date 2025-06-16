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

    @Override
    public User findById(int userId) throws Exception {
        return userDao.findById(userId);
    }

    @Override
    public boolean updateUser(User user) throws Exception {
        User existingUser = userDao.findById(user.getUserId());
        if (existingUser == null) {
            throw new Exception("Không tìm thấy user");
        }
        
        // Kiểm tra email đã tồn tại (ngoại trừ email hiện tại)
        User userWithEmail = userDao.findByEmail(user.getEmail());
        if (userWithEmail != null && userWithEmail.getUserId() != user.getUserId()) {
            throw new Exception("Email đã được sử dụng bởi user khác");
        }
        
        // Giữ nguyên password cũ nếu không thay đổi
        user.setPassword(existingUser.getPassword());
        
        return userDao.update(user);
    }

    @Override
    public boolean updatePassword(int userId, String oldPassword, String newPassword) throws Exception {
        User user = userDao.findById(userId);
        if (user == null) {
            throw new Exception("Không tìm thấy user");
        }
        
        if (!PasswordUtil.verify(oldPassword, user.getPassword())) {
            throw new Exception("Mật khẩu cũ không đúng");
        }
        
        user.setPassword(PasswordUtil.hash(newPassword));
        return userDao.update(user);
    }

    @Override
    public List<User> getFollowSuggestions(int userId) throws Exception {
        return userDao.getFollowSuggestions(userId);
    }
}