CREATE DATABASE studymate_db;
USE studymate_db;

-- Bảng users: Thông tin người dùng
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role ENUM('STUDENT', 'TEACHER', 'ADMIN') DEFAULT 'STUDENT',
    avatar VARCHAR(255),
    bio TEXT,
    phone VARCHAR(20),
    date_of_birth DATE,
    school VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status ENUM('PENDING', 'ACTIVE', 'SUSPENDED', 'BANNED') DEFAULT 'PENDING',
    is_verified BOOLEAN DEFAULT FALSE,
    verification_token VARCHAR(255),
    verification_token_expiry DATETIME,
    is_system_admin BOOLEAN DEFAULT FALSE
);

-- Bảng system_admins: Quản lý admin hệ thống
CREATE TABLE system_admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    admin_level ENUM('SUPER_ADMIN', 'ADMIN', 'MODERATOR') NOT NULL,
    permissions JSON,
    last_login DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Bảng teacher_verifications: Xác thực giáo viên
CREATE TABLE teacher_verifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    qualification TEXT NOT NULL,
    experience TEXT,
    documents_path VARCHAR(255),
    status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    reviewed_by INT,
    review_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (reviewed_by) REFERENCES users(id) ON DELETE SET NULL
);

-- Bảng subjects: Môn học
CREATE TABLE subjects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng forum_posts: Bài đăng diễn đàn
CREATE TABLE forum_posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    subject_id INT,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    file_path VARCHAR(255),
    file_type VARCHAR(50),
    view_count INT DEFAULT 0,
    status ENUM('ACTIVE', 'DELETED', 'HIDDEN') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE SET NULL
);

-- Bảng post_comments: Bình luận
CREATE TABLE post_comments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES forum_posts(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Bảng post_likes: Like bài đăng
CREATE TABLE post_likes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES forum_posts(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY (post_id, user_id)
);
-- Bảng study_notes: Ghi chú học tập
CREATE TABLE study_notes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    subject_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    is_private BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
);

-- Bảng study_materials: Tài liệu học tập
CREATE TABLE study_materials (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    subject_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    file_path VARCHAR(255) NOT NULL,
    file_type VARCHAR(50) NOT NULL,
    file_size INT NOT NULL,
    download_count INT DEFAULT 0,
    rating DECIMAL(3,2) DEFAULT 0.00,
    rating_count INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
);
-- Bảng admin_logs: Log hành động admin
CREATE TABLE admin_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id INT NOT NULL,
    action_type ENUM('USER_MANAGEMENT', 'CONTENT_MODERATION', 'TEACHER_VERIFICATION', 'SYSTEM_SETTINGS', 'GROUP_MANAGEMENT', 'REPORT_HANDLING') NOT NULL,
    action_description TEXT NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (admin_id) REFERENCES system_admins(id) ON DELETE CASCADE
);

-- Bảng system_reports: Báo cáo vi phạm
CREATE TABLE system_reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reporter_id INT NOT NULL,
    report_type ENUM('USER_VIOLATION', 'CONTENT_VIOLATION', 'GROUP_VIOLATION', 'SYSTEM_ISSUE') NOT NULL,
    target_id INT NOT NULL,
    target_type VARCHAR(50) NOT NULL,
    reason TEXT NOT NULL,
    evidence TEXT,
    status ENUM('PENDING', 'IN_REVIEW', 'RESOLVED', 'DISMISSED') DEFAULT 'PENDING',
    handled_by INT,
    resolution_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (reporter_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (handled_by) REFERENCES system_admins(id) ON DELETE SET NULL
);

-- Bảng system_announcements: Thông báo hệ thống
CREATE TABLE system_announcements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    priority ENUM('LOW', 'MEDIUM', 'HIGH', 'URGENT') DEFAULT 'MEDIUM',
    start_date DATETIME NOT NULL,
    end_date DATETIME,
    is_active BOOLEAN DEFAULT TRUE,
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES system_admins(id) ON DELETE CASCADE
);
-- Bảng system_settings: Cài đặt hệ thống
CREATE TABLE system_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    setting_key VARCHAR(50) NOT NULL UNIQUE,
    setting_value TEXT NOT NULL,
    description TEXT,
    updated_by INT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (updated_by) REFERENCES users(id) ON DELETE SET NULL
);	

-- Tạo tài khoản admin
INSERT INTO users (full_name, username, password, email, role, status, is_verified, is_system_admin)
VALUES (
    'Tran Anh Dai',
    'admin',
    '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EHsM', -- Mật khẩu: dai06092004
    'admin@studymate.com',
    'ADMIN',
    'ACTIVE',
    TRUE,
    TRUE
);

-- Tạo bản ghi trong bảng system_admins
INSERT INTO system_admins (user_id, admin_level, permissions)
VALUES (
    (SELECT id FROM users WHERE username = 'admin'),
    'SUPER_ADMIN',
    '{"all_permissions": true}'
);

-- Thêm dữ liệu mẫu cho bảng users
INSERT INTO users (full_name, username, password, email, role, avatar, bio, school, status, is_verified) VALUES 
('Nguyễn Văn A', 'nguyenvana', '$2a$10$kPJ4zMHxdPnF4qJsZv3EBuEqI096BV73tMOSJrNgAVFu9YNqoLCS2', 'nguyenvana@example.com', 'STUDENT', 'avatar-1.jpg', 'Sinh viên năm nhất ngành Công nghệ thông tin', 'Đại học Bách Khoa Hà Nội', 'ACTIVE', TRUE),
('Trần Thị B', 'tranthib', '$2a$10$kPJ4zMHxdPnF4qJsZv3EBuEqI096BV73tMOSJrNgAVFu9YNqoLCS2', 'tranthib@example.com', 'STUDENT', 'avatar-2.jpg', 'Đam mê học tập và nghiên cứu', 'Đại học Quốc gia Hà Nội', 'ACTIVE', TRUE),
('Lê Văn C', 'levanc', '$2a$10$kPJ4zMHxdPnF4qJsZv3EBuEqI096BV73tMOSJrNgAVFu9YNqoLCS2', 'levanc@example.com', 'STUDENT', 'avatar-3.jpg', 'Thích tìm hiểu về lập trình web', 'Học viện Công nghệ Bưu chính Viễn thông', 'ACTIVE', TRUE),
('Phạm Thị D', 'phamthid', '$2a$10$kPJ4zMHxdPnF4qJsZv3EBuEqI096BV73tMOSJrNgAVFu9YNqoLCS2', 'phamthid@example.com', 'STUDENT', 'avatar-4.jpg', 'Chuyên ngành Khoa học máy tính', 'Đại học Công nghệ - ĐHQGHN', 'ACTIVE', TRUE),
('Hoàng Văn E', 'hoangvane', '$2a$10$kPJ4zMHxdPnF4qJsZv3EBuEqI096BV73tMOSJrNgAVFu9YNqoLCS2', 'hoangvane@example.com', 'TEACHER', 'avatar-5.jpg', 'Giảng viên bộ môn Công nghệ phần mềm', 'Đại học FPT', 'ACTIVE', TRUE);

-- Thêm dữ liệu mẫu cho bảng subjects
INSERT INTO subjects (subject_name, description) VALUES 
('Toán cao cấp', 'Môn học cơ bản về đại số tuyến tính và giải tích'),
('Lập trình Java', 'Học về ngôn ngữ lập trình Java và ứng dụng'),
('Cơ sở dữ liệu', 'Các nguyên lý và ứng dụng của hệ quản trị cơ sở dữ liệu'),
('Trí tuệ nhân tạo', 'Giới thiệu về AI và machine learning'),
('Phát triển ứng dụng web', 'Xây dựng các ứng dụng web với các công nghệ hiện đại');

-- Thêm dữ liệu mẫu cho bảng forum_posts
INSERT INTO forum_posts (user_id, subject_id, title, content, view_count) VALUES 
(2, 2, 'Hỏi về Exception trong Java', 'Mình đang gặp vấn đề với việc xử lý ngoại lệ trong Java. Làm thế nào để bắt nhiều loại exception cùng lúc?', 45),
(3, 4, 'Chia sẻ tài liệu học AI', 'Mình vừa tìm được một số tài liệu hay về machine learning và muốn chia sẻ với mọi người. Các bạn có thể tìm thấy link ở đây...', 78),
(4, 5, 'Review khóa học Web Development', 'Mình vừa hoàn thành khóa học Web Development trên Udemy và muốn review lại cho các bạn đang quan tâm...', 120),
(2, 1, 'Cần giúp đỡ bài tập Toán', 'Mình đang gặp khó khăn với bài tập về đạo hàm riêng. Có ai giúp mình được không?', 32),
(5, 3, 'Tip học môn Cơ sở dữ liệu', 'Qua quá trình giảng dạy, mình có một số mẹo giúp các bạn học tốt môn CSDL...', 200);

-- Thêm dữ liệu mẫu cho bảng post_comments
INSERT INTO post_comments (post_id, user_id, content) VALUES 
(1, 3, 'Bạn có thể sử dụng cú pháp try-catch với nhiều catch blocks, mỗi block xử lý một loại exception khác nhau.'),
(1, 5, 'Hoặc bạn có thể sử dụng cú pháp try-with-resources từ Java 7 trở lên để quản lý tài nguyên tốt hơn.'),
(2, 1, 'Cảm ơn bạn đã chia sẻ! Tài liệu rất hữu ích cho người mới bắt đầu như mình.'),
(3, 2, 'Khóa học này có phải là của instructor nào không? Mình cũng đang tìm khóa học tốt.'),
(3, 4, 'Bạn có thể chia sẻ chi tiết hơn về nội dung khóa học được không?'),
(4, 5, 'Bạn có thể gửi ảnh bài tập cụ thể không, mình sẽ giúp bạn giải.');

-- Thêm dữ liệu mẫu cho bảng study_notes
INSERT INTO study_notes (user_id, subject_id, title, content, is_private) VALUES 
(1, 2, 'Tổng quan về Java OOP', 'Java là ngôn ngữ lập trình hướng đối tượng, với các đặc điểm như tính đóng gói, tính kế thừa, tính đa hình và tính trừu tượng...', FALSE),
(1, 3, 'Mô hình ER trong CSDL', 'Mô hình ER (Entity-Relationship) là công cụ để thiết kế cơ sở dữ liệu quan hệ. Các thành phần chính bao gồm thực thể, thuộc tính và mối quan hệ...', FALSE),
(2, 4, 'Thuật toán học máy', 'Một số thuật toán học máy phổ biến: Decision Tree, Random Forest, SVM, Neural Networks...', TRUE),
(3, 5, 'Spring Framework Basics', 'Spring Framework là một framework phổ biến cho phát triển ứng dụng Java. Nó cung cấp IOC container, dependency injection...', FALSE);

-- Thêm dữ liệu mẫu cho bảng study_materials
INSERT INTO study_materials (user_id, subject_id, title, description, file_path, file_type, file_size, rating, rating_count) VALUES 
(1, 2, 'Tài liệu Java cơ bản', 'Tổng hợp kiến thức cơ bản về Java', 'materials/java_basics.pdf', 'PDF', 1024000, 4.5, 10),
(2, 1, 'Bài tập Toán cao cấp', 'Các bài tập và lời giải chi tiết', 'materials/math_exercises.pdf', 'PDF', 2048000, 4.8, 15),
(3, 3, 'Slide CSDL', 'Slide bài giảng môn Cơ sở dữ liệu', 'materials/database_slides.pptx', 'PPTX', 3072000, 4.2, 8),
(5, 4, 'Giáo trình AI', 'Giáo trình Trí tuệ nhân tạo', 'materials/ai_textbook.pdf', 'PDF', 5120000, 4.7, 20);

-- Thêm dữ liệu mẫu cho bảng system_reports
INSERT INTO system_reports (reporter_id, report_type, target_id, target_type, reason, status) VALUES 
(1, 'USER_VIOLATION', 2, 'user', 'Người dùng đăng nội dung không phù hợp', 'PENDING'),
(2, 'CONTENT_VIOLATION', 1, 'post', 'Bài viết chứa thông tin sai lệch', 'RESOLVED'),
(3, 'GROUP_VIOLATION', 1, 'group', 'Nhóm học tập vi phạm nội quy', 'IN_REVIEW'),
(4, 'SYSTEM_ISSUE', 0, 'system', 'Gặp lỗi khi tải tài liệu', 'PENDING');

-- Thêm dữ liệu mẫu cho bảng system_announcements
INSERT INTO system_announcements (title, content, priority, start_date, created_by, is_active) VALUES 
('Bảo trì hệ thống', 'Hệ thống sẽ được bảo trì vào ngày 25/05/2024', 'HIGH', '2024-05-20 00:00:00', 1, TRUE),
('Cập nhật tính năng mới', 'Thêm tính năng nhóm học tập mới', 'MEDIUM', '2024-05-15 00:00:00', 1, TRUE),
('Thông báo về kỳ thi', 'Lịch thi cuối kỳ sẽ được công bố vào tuần tới', 'HIGH', '2024-05-10 00:00:00', 1, TRUE);

-- Thêm dữ liệu mẫu cho bảng system_settings
INSERT INTO system_settings (setting_key, setting_value, description) VALUES 
('MAX_FILE_SIZE', '10485760', 'Kích thước file tối đa (bytes)'),
('ALLOWED_FILE_TYPES', 'pdf,doc,docx,ppt,pptx,jpg,jpeg,png', 'Các loại file được phép tải lên'),
('MAX_POST_LENGTH', '5000', 'Độ dài tối đa của bài viết'),
('REQUIRE_EMAIL_VERIFICATION', 'true', 'Yêu cầu xác thực email'),
('TEACHER_APPROVAL_REQUIRED', 'true', 'Yêu cầu duyệt giáo viên');

-- Thêm dữ liệu mẫu cho bảng teacher_verifications
INSERT INTO teacher_verifications (user_id, qualification, experience, status) VALUES 
(5, 'Thạc sĩ Công nghệ thông tin', '5 năm kinh nghiệm giảng dạy', 'APPROVED');

-- Thêm dữ liệu mẫu cho bảng admin_logs
INSERT INTO admin_logs (admin_id, action_type, action_description, ip_address) VALUES 
(1, 'USER_MANAGEMENT', 'Duyệt tài khoản giáo viên mới', '192.168.1.1'),
(1, 'CONTENT_MODERATION', 'Xóa bài viết vi phạm nội quy', '192.168.1.1'),
(1, 'SYSTEM_SETTINGS', 'Cập nhật cài đặt hệ thống', '192.168.1.1');