package com.studymate.dao;

import com.studymate.model.User;
import java.util.List;

public interface UserDao {
    // Tạo user mới
    int create(User user) throws Exception;

    // Cập nhật thông tin user
    boolean update(User user) throws Exception;

    // Xóa user theo id
    boolean delete(int userId) throws Exception;

    // Lấy user theo id
    User findById(int userId) throws Exception;

    // Lấy user theo email (dùng cho đăng nhập)
    User findByEmail(String email) throws Exception;
    
    User findByUsername(String username) throws Exception;

    // Lấy tất cả user (nếu cần)
    List<User> findAll() throws Exception;
    
 // Lấy danh sách gợi ý theo dõi
    List<User> getFollowSuggestions(int userId) throws Exception;
    
}