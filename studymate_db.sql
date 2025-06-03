CREATE DATABASE studymate_db;
USE studymate_db;

-- Bảng người dùng
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role ENUM('STUDENT', 'TEACHER', 'ADMIN') DEFAULT 'STUDENT',
    avatar VARCHAR(255), -- Đường dẫn đến ảnh đại diện
    bio TEXT, -- Tiểu sử/Giới thiệu
    phone VARCHAR(20), -- Số điện thoại
    date_of_birth DATE, -- Ngày sinh
    school VARCHAR(255), -- Tên trường
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Bảng follows
CREATE TABLE follows (
    following_user_id INT NOT NULL,
    followed_user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (following_user_id, followed_user_id),
    FOREIGN KEY (following_user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (followed_user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Bảng subjects: Lưu thông tin về các môn học
CREATE TABLE subjects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bảng user_subjects: Liên kết người dùng với môn học
CREATE TABLE user_subjects (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    subject_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE,
    UNIQUE KEY (user_id, subject_id)
);

-- Bảng study_notes: Ghi chú học tập hàng ngày/hàng tuần
CREATE TABLE study_notes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    subject_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
);

-- Bảng study_materials: Đăng tải tài liệu học tập
CREATE TABLE study_materials (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    subject_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    file_path VARCHAR(255) NOT NULL, -- Đường dẫn đến file
    file_type VARCHAR(50) NOT NULL, -- Loại file (PDF, DOCX, v.v.)
    file_size INT NOT NULL, -- Kích thước file (bytes)
    download_count INT DEFAULT 0, -- Số lượt tải
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
);

-- Bảng forum_posts: Bảng tin trao đổi vấn đề học tập
CREATE TABLE forum_posts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    subject_id INT,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    file_path VARCHAR(255), -- Đường dẫn đến file (có thể NULL)
    file_type VARCHAR(50), -- Loại file (PDF, DOCX, v.v.)
    view_count INT DEFAULT 0, -- Số lượt xem
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE SET NULL
);

-- Bảng post_comments: Bình luận cho các bài đăng
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

-- Bảng post_likes: Like cho các bài đăng
CREATE TABLE post_likes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES forum_posts(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY (post_id, user_id)
);

-- Bảng schedules: Lịch học
CREATE TABLE schedules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    subject_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    location VARCHAR(255), -- Vị trí học
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    is_recurring BOOLEAN DEFAULT FALSE,
    recurrence_pattern VARCHAR(50), -- Mẫu lặp lại (daily, weekly, monthly)
    reminder_minutes INT, -- Nhắc nhở trước bao nhiêu phút
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES subjects(id) ON DELETE CASCADE
);

-- Bảng notifications: Thông báo
CREATE TABLE notifications (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    notification_type ENUM('POST', 'COMMENT', 'LIKE', 'FOLLOW', 'MATERIAL', 'SCHEDULE') NOT NULL,
    reference_id INT, -- ID tham chiếu đến đối tượng liên quan (post_id, comment_id, ...)
    source_user_id INT, -- ID người dùng tạo ra thông báo (người đăng bài, like, comment, ...)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (source_user_id) REFERENCES users(id) ON DELETE SET NULL
);



-- Thêm dữ liệu mẫu cho bảng users
INSERT INTO users (full_name, username, password, email, role, avatar, bio, school) VALUES 
('Nguyễn Văn A', 'nguyenvana', '$2a$10$kPJ4zMHxdPnF4qJsZv3EBuEqI096BV73tMOSJrNgAVFu9YNqoLCS2', 'nguyenvana@example.com', 'STUDENT', 'avatar-1.jpg', 'Sinh viên năm nhất ngành Công nghệ thông tin', 'Đại học Bách Khoa Hà Nội'),
('Trần Thị B', 'tranthib', '$2a$10$kPJ4zMHxdPnF4qJsZv3EBuEqI096BV73tMOSJrNgAVFu9YNqoLCS2', 'tranthib@example.com', 'STUDENT', 'avatar-2.jpg', 'Đam mê học tập và nghiên cứu', 'Đại học Quốc gia Hà Nội'),
('Lê Văn C', 'levanc', '$2a$10$kPJ4zMHxdPnF4qJsZv3EBuEqI096BV73tMOSJrNgAVFu9YNqoLCS2', 'levanc@example.com', 'STUDENT', 'avatar-3.jpg', 'Thích tìm hiểu về lập trình web', 'Học viện Công nghệ Bưu chính Viễn thông'),
('Phạm Thị D', 'phamthid', '$2a$10$kPJ4zMHxdPnF4qJsZv3EBuEqI096BV73tMOSJrNgAVFu9YNqoLCS2', 'phamthid@example.com', 'STUDENT', 'avatar-4.jpg', 'Chuyên ngành Khoa học máy tính', 'Đại học Công nghệ - ĐHQGHN'),
('Hoàng Văn E', 'hoangvane', '$2a$10$kPJ4zMHxdPnF4qJsZv3EBuEqI096BV73tMOSJrNgAVFu9YNqoLCS2', 'hoangvane@example.com', 'TEACHER', 'avatar-5.jpg', 'Giảng viên bộ môn Công nghệ phần mềm', 'Đại học FPT');

-- Thêm dữ liệu mẫu cho bảng follows
INSERT INTO follows (following_user_id, followed_user_id) VALUES 
(1, 2), -- User 1 follows User 2
(1, 3), -- User 1 follows User 3
(2, 1), -- User 2 follows User 1
(3, 1), -- User 3 follows User 1
(3, 2), -- User 3 follows User 2
(4, 1), -- User 4 follows User 1
(4, 5), -- User 4 follows User 5
(5, 2); -- User 5 follows User 2

-- Thêm dữ liệu mẫu cho bảng subjects
INSERT INTO subjects (subject_name, description) VALUES 
('Toán cao cấp', 'Môn học cơ bản về đại số tuyến tính và giải tích'),
('Lập trình Java', 'Học về ngôn ngữ lập trình Java và ứng dụng'),
('Cơ sở dữ liệu', 'Các nguyên lý và ứng dụng của hệ quản trị cơ sở dữ liệu'),
('Trí tuệ nhân tạo', 'Giới thiệu về AI và machine learning'),
('Phát triển ứng dụng web', 'Xây dựng các ứng dụng web với các công nghệ hiện đại');

-- Thêm dữ liệu mẫu cho bảng user_subjects
INSERT INTO user_subjects (user_id, subject_id) VALUES 
(1, 1), (1, 2), (1, 3), -- User 1 học 3 môn
(2, 1), (2, 4), -- User 2 học 2 môn
(3, 2), (3, 3), (3, 5), -- User 3 học 3 môn
(4, 1), (4, 4), (4, 5); -- User 4 học 3 môn

-- Thêm dữ liệu mẫu cho bảng study_notes
INSERT INTO study_notes (user_id, subject_id, title, content) VALUES 
(1, 2, 'Tổng quan về Java OOP', 'Java là ngôn ngữ lập trình hướng đối tượng, với các đặc điểm như tính đóng gói, tính kế thừa, tính đa hình và tính trừu tượng...'),
(1, 3, 'Mô hình ER trong CSDL', 'Mô hình ER (Entity-Relationship) là công cụ để thiết kế cơ sở dữ liệu quan hệ. Các thành phần chính bao gồm thực thể, thuộc tính và mối quan hệ...'),
(2, 4, 'Thuật toán học máy', 'Một số thuật toán học máy phổ biến: Decision Tree, Random Forest, SVM, Neural Networks...'),
(3, 5, 'Spring Framework Basics', 'Spring Framework là một framework phổ biến cho phát triển ứng dụng Java. Nó cung cấp IOC container, dependency injection...');

-- Thêm dữ liệu mẫu cho bảng study_materials
INSERT INTO study_materials (user_id, subject_id, title, description, file_path, file_type, file_size) VALUES 
(1, 2, 'Tài liệu Java cơ bản', 'Tổng hợp kiến thức cơ bản về Java', 'materials/java_basics.pdf', 'PDF', 1024000),
(2, 1, 'Bài tập Toán cao cấp', 'Các bài tập và lời giải chi tiết', 'materials/math_exercises.pdf', 'PDF', 2048000),
(3, 3, 'Slide CSDL', 'Slide bài giảng môn Cơ sở dữ liệu', 'materials/database_slides.pptx', 'PPTX', 3072000),
(5, 4, 'Giáo trình AI', 'Giáo trình Trí tuệ nhân tạo', 'materials/ai_textbook.pdf', 'PDF', 5120000);

-- Thêm dữ liệu mẫu cho bảng forum_posts
INSERT INTO forum_posts (user_id, subject_id, title, content, view_count) VALUES 
(1, 2, 'Hỏi về Exception trong Java', 'Mình đang gặp vấn đề với việc xử lý ngoại lệ trong Java. Làm thế nào để bắt nhiều loại exception cùng lúc?', 45),
(2, 4, 'Chia sẻ tài liệu học AI', 'Mình vừa tìm được một số tài liệu hay về machine learning và muốn chia sẻ với mọi người. Các bạn có thể tìm thấy link ở đây...', 78),
(3, 5, 'Review khóa học Web Development', 'Mình vừa hoàn thành khóa học Web Development trên Udemy và muốn review lại cho các bạn đang quan tâm...', 120),
(4, 1, 'Cần giúp đỡ bài tập Toán', 'Mình đang gặp khó khăn với bài tập về đạo hàm riêng. Có ai giúp mình được không?', 32),
(5, 3, 'Tip học môn Cơ sở dữ liệu', 'Qua quá trình giảng dạy, mình có một số mẹo giúp các bạn học tốt môn CSDL...', 200);

-- Thêm dữ liệu mẫu cho bảng post_comments
INSERT INTO post_comments (post_id, user_id, content) VALUES 
(1, 3, 'Bạn có thể sử dụng cú pháp try-catch với nhiều catch blocks, mỗi block xử lý một loại exception khác nhau.'),
(1, 5, 'Hoặc bạn có thể sử dụng cú pháp try-with-resources từ Java 7 trở lên để quản lý tài nguyên tốt hơn.'),
(2, 1, 'Cảm ơn bạn đã chia sẻ! Tài liệu rất hữu ích cho người mới bắt đầu như mình.'),
(3, 2, 'Khóa học này có phải là của instructor nào không? Mình cũng đang tìm khóa học tốt.'),
(3, 4, 'Bạn có thể chia sẻ chi tiết hơn về nội dung khóa học được không?'),
(4, 5, 'Bạn có thể gửi ảnh bài tập cụ thể không, mình sẽ giúp bạn giải.');

-- Thêm dữ liệu mẫu cho bảng post_likes
INSERT INTO post_likes (post_id, user_id) VALUES 
(1, 2), (1, 3), (1, 5),
(2, 1), (2, 3), (2, 4),
(3, 1), (3, 2), (3, 4), (3, 5),
(4, 2), (4, 5),
(5, 1), (5, 2), (5, 3), (5, 4);

-- Thêm dữ liệu mẫu cho bảng schedules
INSERT INTO schedules (user_id, subject_id, title, description, location, start_time, end_time, is_recurring, recurrence_pattern) VALUES 
(1, 2, 'Học Java', 'Buổi học về Collection Framework', 'Phòng 305, Tòa nhà A1', '2025-05-22 08:00:00', '2025-05-22 10:30:00', TRUE, 'weekly'),
(1, 3, 'Học CSDL', 'Thực hành SQL', 'Phòng máy 101', '2025-05-23 13:30:00', '2025-05-23 16:00:00', TRUE, 'weekly'),
(2, 1, 'Ôn tập Toán', 'Chuẩn bị kiểm tra giữa kỳ', 'Thư viện tầng 2', '2025-05-24 09:00:00', '2025-05-24 11:30:00', FALSE, NULL),
(3, 5, 'Workshop Web Dev', 'Thực hành xây dựng REST API', 'Phòng Lab 403', '2025-05-25 14:00:00', '2025-05-25 17:00:00', FALSE, NULL);

-- Thêm dữ liệu mẫu cho bảng notifications
INSERT INTO notifications (user_id, title, content, is_read, notification_type, reference_id, source_user_id) VALUES 
(1, 'Bình luận mới', 'Hoàng Văn E đã bình luận về bài đăng của bạn', FALSE, 'COMMENT', 1, 5),
(1, 'Người theo dõi mới', 'Trần Thị B đã bắt đầu theo dõi bạn', TRUE, 'FOLLOW', NULL, 2),
(2, 'Lượt thích mới', 'Nguyễn Văn A đã thích bài đăng của bạn', FALSE, 'LIKE', 2, 1),
(3, 'Bình luận mới', 'Phạm Thị D đã bình luận về bài đăng của bạn', FALSE, 'COMMENT', 3, 4),
(4, 'Trả lời bình luận', 'Hoàng Văn E đã trả lời bình luận của bạn', TRUE, 'COMMENT', 4, 5);

-- Mật khẩu ở trên là 'password' được mã hóa với BCrypt
-- Lưu ý: Trong thực tế, hãy sử dụng mật khẩu mạnh hơn cho tài khoản