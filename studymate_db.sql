CREATE DATABASE studymate_db;
USE studymate_db;

-- Bảng schools (trường học)
CREATE TABLE schools (
    school_id   INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(255) NOT NULL UNIQUE
);

-- Bảng users
CREATE TABLE users (
    user_id         INT AUTO_INCREMENT PRIMARY KEY,
    fullname		VARCHAR(50) NOT NULL,
    username        VARCHAR(50)  NOT NULL,
    password        VARCHAR(255) NOT NULL,
    role            ENUM('USER','ADMIN') DEFAULT 'USER',
    avatar_url      VARCHAR(500),
    bio             TEXT,
    phone           VARCHAR(20),
    email           VARCHAR(100) NOT NULL UNIQUE,
    date_of_birth   DATE,
    school_id       INT,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    status          ENUM('ACTIVE','BANNED') DEFAULT 'ACTIVE',
    is_system_admin BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (school_id) REFERENCES schools(school_id)
);

-- Bảng posts (bài viết)
CREATE TABLE posts (
    post_id     INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NOT NULL,
    title       VARCHAR(100) NOT NULL,
    body        TEXT         NOT NULL,
    privacy     ENUM('PUBLIC','FOLLOWERS','PRIVATE') DEFAULT 'PUBLIC',
    status      ENUM('DRAFT','PUBLISHED')       DEFAULT 'DRAFT',
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Bảng post_attachments (file/ảnh đính kèm của post)
CREATE TABLE attachments (
    attachment_id  INT AUTO_INCREMENT PRIMARY KEY,
    post_id        INT NOT NULL,
    file_url       VARCHAR(500) NOT NULL,
    file_type      ENUM('IMAGE','DOCUMENT','OTHER') DEFAULT 'IMAGE',
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES posts(post_id)
);

-- Bảng follows (theo dõi)
CREATE TABLE follows (	
    follower_id  INT NOT NULL,		
    followee_id  INT NOT NULL,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (follower_id, followee_id),
    FOREIGN KEY (follower_id) REFERENCES users(user_id),
    FOREIGN KEY (followee_id) REFERENCES users(user_id)
);

-- Bảng notes (ghi chú học tập)
CREATE TABLE notes (
    note_id     INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NOT NULL,
    content     TEXT NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Bảng tasks (công việc)
CREATE TABLE tasks (
    task_id     INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NOT NULL,
    title       VARCHAR(255) NOT NULL,
    description TEXT,
    due_date    DATE,
    status      ENUM('PENDING','DONE') DEFAULT 'PENDING',
    is_pinned   BOOLEAN DEFAULT FALSE,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Bảng likes
CREATE TABLE likes (
    user_id     INT,
    post_id     INT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, post_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (post_id) REFERENCES posts(post_id)
);

-- Bảng comments
CREATE TABLE comments (
    comment_id  INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT,
    post_id     INT,
    content     TEXT NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (post_id) REFERENCES posts(post_id)
);


-- Bảng rooms (phòng học)
CREATE TABLE rooms (
    room_id    INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT,
    name       VARCHAR(100) NOT NULL UNIQUE,     -- ví dụ: "P101", "Lab A"
    location   VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE room_members (
    room_id INT NOT NULL,
    user_id INT NOT NULL,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (room_id, user_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE documents (
  document_id INT AUTO_INCREMENT PRIMARY KEY,
  uploader_id INT NOT NULL,
  title       VARCHAR(255),
  description TEXT,
  file_url    VARCHAR(500) NOT NULL,
  uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (uploader_id) REFERENCES users(user_id)
);

-- Bảng schedules (thời khóa biểu) sau khi thêm room_id
CREATE TABLE schedules (
    schedule_id   INT AUTO_INCREMENT PRIMARY KEY,
    user_id       INT NOT NULL,
    subject varchar(250) not null,
    room varchar(250) not null,
    day_of_week   TINYINT NOT NULL,               -- 1=Thứ hai … 7=Chủ nhật
    start_time    TIME NOT NULL,                  -- giờ bắt đầu
    end_time      TIME NOT NULL,                  -- giờ kết thúc
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)    REFERENCES users(user_id)
);

INSERT INTO schools (name) VALUES 
('THPT Nguyễn Huệ'),
('THPT Lê Quý Đôn'),
('THPT Trần Phú'),
('THPT Nguyễn Trãi'),
('THPT Lý Thường Kiệt'),
('THPT Hai Bà Trưng'),
('THPT Nguyễn Du'),
('THPT Phan Châu Trinh'),
('THPT Võ Nguyên Giáp'),
('THPT Lê Lợi'),
('THPT Trường Chinh'),
('THPT Nguyễn Tất Thành'),
('THPT Chu Văn An'),
('THPT Quang Trung'),
('THPT Hùng Vương'),
('THPT Ngô Quyền'),
('THPT Lê Thánh Tông'),
('THPT Trần Hưng Đạo'),
('THPT Nguyễn Bỉnh Khiêm'),
('THPT Phan Bội Châu');

