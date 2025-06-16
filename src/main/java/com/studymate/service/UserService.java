package com.studymate.service;

import com.studymate.model.User;
import java.util.List;

public interface UserService {

    /**
     * Đăng ký user mới, trả về userId vừa tạo
     */
    int register(User user) throws Exception;

    /**
     * Đăng nhập, nếu thành công trả về User, ngược lại trả về null
     */
    User login(String email, String password) throws Exception;

    /**
     * Lấy danh sách tất cả user (dùng cho admin)
     */
    List<User> findAll() throws Exception;

    /**
     * Tìm user theo ID
     */
    User findById(int userId) throws Exception;

    /**
     * Cập nhật thông tin user
     */
    boolean updateUser(User user) throws Exception;

    /**
     * Cập nhật mật khẩu user
     */
    boolean updatePassword(int userId, String oldPassword, String newPassword) throws Exception;

    /**
     * Lấy danh sách gợi ý theo dõi cho một user cụ thể
     */
    List<User> getFollowSuggestions(int userId) throws Exception;
}