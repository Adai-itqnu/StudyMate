CREATE DATABASE studymate_db;
USE studymate_db;

-- Bảng users: Thông tin người dùng
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role ENUM('USER', 'ADMIN') DEFAULT 'USER',
    avatar VARCHAR(255),
    bio TEXT,
    phone VARCHAR(20),
    date_of_birth DATE,
    school VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status ENUM('ACTIVE', 'BANNED') DEFAULT 'ACTIVE',
    is_system_admin BOOLEAN DEFAULT FALSE
);

-- Bảng system_admins: Quản lý admin hệ thống (đơn giản hóa)
CREATE TABLE system_admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    admin_level ENUM('ADMIN') NOT NULL,
    last_login DATETIME,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
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
-- Bảng study_schedules: Lịch học
CREATE TABLE study_schedules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    subject_id INT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE SET NULL
);

-- Bảng user_follows: Theo dõi người dùng
CREATE TABLE user_follows (
    id INT AUTO_INCREMENT PRIMARY KEY,
    follower_id INT NOT NULL COMMENT 'Người theo dõi',
    following_id INT NOT NULL COMMENT 'Người được theo dõi',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (follower_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (following_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_follow (follower_id, following_id)
);

-- Tạo tài khoản admin
INSERT INTO users (full_name, username, password, email, role, status, is_system_admin)
VALUES (
    'Tran Anh Dai',
    'admin',
    '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EHsM', -- Mật khẩu: dai06092004
    'admin@studymate.com',
    'ADMIN',
    'ACTIVE',
    TRUE
);

-- Thêm người dùng
INSERT INTO users (full_name, username, password, email, role, status, is_system_admin)
VALUES
('Nguyễn Văn A', 'nguyenvana', '$2a$10$abcabcabcabcabcabcabcuJFt2', 'vana@example.com', 'USER', 'ACTIVE', FALSE),
('Trần Thị B', 'tranthib', '$2a$10$abcabcabcabcabcabcabcuJFt2', 'thib@example.com', 'USER', 'ACTIVE', FALSE),
('Lê Văn C', 'levanc', '$2a$10$abcabcabcabcabcabcabcuJFt2', 'vanc@example.com', 'USER', 'ACTIVE', FALSE);

-- Thêm môn học
INSERT INTO subjects (subject_name, description)
VALUES
('Lập trình Java', 'Môn học cơ bản về lập trình Java và OOP'),
('Cơ sở dữ liệu', 'Các nguyên tắc thiết kế và quản lý CSDL'),
('Trí tuệ nhân tạo', 'Giới thiệu về AI và học máy');


-- Bài viết diễn đàn
INSERT INTO forum_posts (user_id, subject_id, title, content, view_count)
VALUES
(1, 1, 'Hỏi về vòng lặp for trong Java', 'Mình chưa hiểu rõ cách dùng vòng lặp for trong Java, ai giúp với!', 23),
(2, 2, 'Cách thiết kế ERD', 'Mọi người thường bắt đầu thiết kế ERD như thế nào?', 35),
(3, 3, 'AI có thay thế lập trình viên không?', 'Theo các bạn thì trong tương lai AI có thể thay thế coder không?', 50);

-- bình luận bài viết
INSERT INTO post_comments (post_id, user_id, content)
VALUES
(1, 2, 'Bạn thử dùng cú pháp for (int i = 0; i < n; i++) nhé.'),
(1, 3, 'Tham khảo Java Loop tutorial của w3schools rất dễ hiểu.'),
(2, 1, 'Từ phân tích yêu cầu → xác định thực thể chính trước.');

-- Like bài viết
INSERT INTO post_likes (post_id, user_id)
VALUES
(1, 2),
(1, 3),
(2, 1);

-- ghi chú học tập
INSERT INTO study_notes (user_id, subject_id, title, content, is_private)
VALUES
(1, 1, 'Java cơ bản', 'Java là OOP, gồm các tính chất như kế thừa, đa hình...', FALSE),
(2, 2, 'Khóa chính & khóa ngoại', 'Khóa chính là định danh duy nhất cho mỗi bản ghi...', TRUE);

-- tài liệu học tập 
INSERT INTO study_materials (user_id, subject_id, title, description, file_path, file_type, file_size, download_count, rating, rating_count)
VALUES
(1, 1, 'Tài liệu Java PDF', 'Tổng hợp lý thuyết Java', 'materials/java_intro.pdf', 'PDF', 204800, 5, 4.5, 2),
(2, 2, 'Slide ERD', 'Slide mô tả sơ đồ ERD', 'materials/erd_slide.pptx', 'PPTX', 102400, 3, 4.2, 1);

-- báo cáo vi phạm
INSERT INTO system_reports (reporter_id, report_type, target_id, target_type, reason, evidence, status)
VALUES
(1, 'CONTENT_VIOLATION', 3, 'post', 'Nội dung bài viết không phù hợp', NULL, 'PENDING'),
(2, 'USER_VIOLATION', 3, 'user', 'Người dùng có hành vi spam', NULL, 'IN_REVIEW');



select * from users
