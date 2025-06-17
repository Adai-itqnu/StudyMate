<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StudyMate - Phòng Chat: ${room.name}</title>
    <link href="<c:url value='/assets/css/bootstrap.min.css'/>" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
   <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/dashboard.css"/>
        <style>
        .chat-box {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            height: 550px; /* Tăng chiều cao của khung chat để bù lại thanh nhập nhỏ gọn hơn */
            overflow-y: auto;
            padding: 15px;
            margin-bottom: 15px;
            background-color: #f9f9f9;
            display: flex;
            flex-direction: column;
        }
        .message-input {
            display: flex;
            align-items: center; /* Đảm bảo căn chỉnh dọc */
            margin-top: 10px;
        }
        .message-input .input-group {
            width: 100%; /* Đảm bảo input-group chiếm toàn bộ chiều rộng */
        }
        .message-input textarea.form-control {
            border-radius: 20px 0 0 20px; /* Bo tròn bên trái */
            padding: 8px 15px; /* Đệm nhất quán */
            resize: none;
            height: 38px; /* Chiều cao được giảm nhẹ để nhỏ gọn */
            min-height: 38px;
            max-height: 38px;
            overflow-y: hidden;
            font-size: 0.9em;
            box-shadow: none; /* Loại bỏ mọi bóng tập trung mặc định */
        }
        .message-input .input-group-append .btn {
            border-radius: 0 20px 20px 0; /* Bo tròn bên phải */
            height: 38px; /* Đảm bảo cùng chiều cao với textarea để căn chỉnh hoàn hảo */
            padding: 0 15px; /* Điều chỉnh padding */
            font-size: 1.1em; /* Kích thước biểu tượng */
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: none; /* Loại bỏ mọi bóng tập trung mặc định */
        }
        .message {
            margin-bottom: 8px;
            padding: 7px 10px;
            border-radius: 10px;
            max-width: 75%;
            word-wrap: break-word;
        }
        .message.sent {
            background-color: #DCF8C6;
            align-self: flex-end;
            margin-left: auto;
        }
        .message.received {
            background-color: #E0E0E0;
            align-self: flex-start;
        }
        .message-meta {
            font-size: 0.7em;
            color: #888;
            margin-top: 3px;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="container-fluid">
            <div class="row align-items-center py-3">
                <!-- Logo/Trang chủ -->
                <div class="col-md-3">
                    <a href="<c:url value='/dashboard'/>" class="text-decoration-none">
                        <h4 class="mb-0 text-primary">
                            <i class="fas fa-graduation-cap"></i> StudyMate
                        </h4>
                    </a>
                </div>
                
                <!-- Ô tìm kiếm -->
                <div class="col-md-6">
                    <form action="<c:url value='/dashboard'/>" method="get" class="d-flex justify-content-center">
                        <div class="input-group search-box">
                            <input type="text" name="search" class="form-control" 
                                   placeholder="Tìm kiếm người dùng..." 
                                   value="${searchKeyword}">
                            <button class="btn btn-outline-primary" type="submit">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </form>
                </div>
                
                <!-- User info -->
                <div class="col-md-3">
                    <div class="d-flex justify-content-end">
                        <div class="user-dropdown">
                            <div class="d-flex align-items-center cursor-pointer" onclick="toggleDropdown()">
                                <img src="${currentUser.avatarUrl != null ? currentUser.avatarUrl : '/assets/images/default-avatar.png'}" 
                                     alt="Avatar" class="avatar me-2">
                                <span class="me-2">${currentUser.fullName}</span>
                                <i class="fas fa-chevron-down"></i>
                            </div>
                            <div class="dropdown-menu" id="userDropdown">
                                <a href="<c:url value='/profile'/>" class="dropdown-item">
                                    <i class="fas fa-user me-2"></i>Trang cá nhân
                                </a>
                                <a href="<c:url value='/profile/settings'/>" class="dropdown-item">
                                    <i class="fas fa-cog me-2"></i>Chỉnh sửa thông tin
                                </a>
                                <a href="<c:url value='/logout'/>" class="dropdown-item">
                                    <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container-fluid">
        <div class="row">
            <!-- Left Sidebar - Gợi ý người dùng -->
            <div class="col-md-3">
                <div class="sidebar">
                    <h5 class="mb-3">
                        <i class="fas fa-users"></i> Gợi ý theo dõi
                    </h5>
                    
                    <c:forEach var="suggestion" items="${suggestions}">
                        <div class="suggestion-card">
                            <div class="d-flex align-items-center">
                                <img src="${suggestion.avatarUrl != null ? suggestion.avatarUrl : '/assets/images/default-avatar.png'}" 
                                     alt="Avatar" class="avatar me-3">
                                <div class="flex-grow-1">
                                    <h6 class="mb-1">${suggestion.fullName}</h6>
                                    <small class="text-muted">@${suggestion.username}</small>
                                </div>
                            </div>
                            <div class="mt-2">
                                <button class="btn btn-primary btn-sm me-2" 
                                        onclick="followUser(${suggestion.userId})">
                                    <i class="fas fa-plus"></i> Theo dõi
                                </button>
                                <a href="<c:url value='/profile/${suggestion.userId}'/>" 
                                   class="btn btn-outline-secondary btn-sm">
                                    Xem trang
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Main Content Area -->
            <div class="col-md-6">
                <div class="main-content">
                    <div class="post-form">
                        <h5 class="mb-3">
                            <i class="fas fa-comments"></i> Phòng Chat: ${room.name}
                        </h5>
                        <div class="chat-box" id="chatBox">
                            <!-- Chat messages will be loaded here -->
                            <div class="message received">
                                <p>Chào mừng đến với phòng chat!</p>
                                <span class="message-meta">StudyMate Bot - <fmt:formatDate value="<%= new java.util.Date() %>" pattern="HH:mm"/></span>
                            </div>
                        </div>
                        <div class="message-input">
                            <div class="input-group">
                                <textarea id="chatMessage" class="form-control" rows="1" placeholder="Nhập tin nhắn..."></textarea>
                                <div class="input-group-append">
                                    <button class="btn btn-primary" type="button" onclick="sendMessage(${room.roomId})">
                                        <i class="fas fa-paper-plane"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Sidebar - Features -->
            <div class="col-md-3">
                <div class="right-sidebar">
                    <h5 class="mb-3">
                        <i class="fas fa-tools"></i> Tính năng
                    </h5>
                    
                    <!-- 1. Tạo lịch học -->
                    <div class="feature-card">
                        <a href="#" style="text-decoration: none; color: inherit; display: block; padding: 15px;">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-calendar-alt text-primary fa-2x me-3"></i>
                                <div>
                                    <h6 class="mb-1">Tạo lịch học</h6>
                                    <small class="text-muted">Lên kế hoạch học tập</small>
                                </div>
                            </div>
                        </a>
                    </div>
                    
                    <!-- 2. Xem ghi chú -->
                    <div class="feature-card">
                        <a href="<c:url value='/notes'/>" style="text-decoration: none; color: inherit; display: block; padding: 15px;">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-sticky-note text-warning fa-2x me-3"></i>
                                <div>
                                    <h6 class="mb-1">Xem ghi chú</h6>
                                    <small class="text-muted">Quản lý ghi chú cá nhân</small>
                                </div>
                            </div>
                        </a>
                    </div>

                    <!-- 3. Đăng tải tài liệu học tập -->
                    <div class="feature-card">
                        <a href="<c:url value='/documents/upload'/>" style="text-decoration: none; color: inherit; display: block; padding: 15px;">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-upload text-info fa-2x me-3"></i>
                                <div>
                                    <h6 class="mb-1">Đăng tải tài liệu học tập</h6>
                                    <small class="text-muted">Chia sẻ tài liệu với cộng đồng</small>
                                </div>
                            </div>
                        </a>
                    </div>
                    
                    <!-- 4. Xem tài liệu đã tải lên -->
                    <div class="feature-card">
                        <a href="<c:url value='/documents'/>" style="text-decoration: none; color: inherit; display: block; padding: 15px;">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-book-open text-success fa-2x me-3"></i>
                                <div>
                                    <h6 class="mb-1">Xem tài liệu đã tải lên</h6>
                                    <small class="text-muted">Duyệt và tìm kiếm tài liệu</small>
                                </div>
                            </div>
                        </a>
                    </div>

                     <!-- 5. Tạo phòng học -->
                     <div class="feature-card">
                        <a href="<c:url value='/rooms'/>" style="text-decoration: none; color: inherit; display: block; padding: 15px;">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-users text-danger fa-2x me-3"></i>
                                <div>
                                    <h6 class="mb-1">Phòng học</h6>
                                    <small class="text-muted">Tham gia và tạo phòng học</small>
                                </div>
                            </div>
                        </a>
                    </div>

                    <!-- 6. Thống kê học tập -->
                    <div class="feature-card">
                        <a href="#" style="text-decoration: none; color: inherit; display: block; padding: 15px;">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-chart-line text-secondary fa-2x me-3"></i>
                                <div>
                                    <h6 class="mb-1">Thống kê học tập</h6>
                                    <small class="text-muted">Theo dõi tiến độ</small>
                                </div>
                            </div>
                        </a>
                    </div>

                     <!-- 7. Nhắc nhở -->
                     <div class="feature-card">
                        <a href="#" style="text-decoration: none; color: inherit; display: block; padding: 15px;">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-bell text-info fa-2x me-3"></i>
                                <div>
                                    <h6 class="mb-1">Nhắc nhở</h6>
                                    <small class="text-muted">Đặt nhắc nhở cho công việc</small>
                                </div>
                            </div>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="<c:url value='/assets/js/bootstrap.bundle.min.js'/>"></script>
    <script src="${pageContext.request.contextPath}/resources/assets/js/dashboard.js"></script>
    <script>
        function toggleDropdown() {
            document.getElementById("userDropdown").classList.toggle("show");
        }

        window.onclick = function(event) {
            if (!event.target.matches('.user-dropdown *' ) && !event.target.matches('.user-dropdown')) {
                var dropdowns = document.getElementsByClassName("dropdown-menu");
                for (var i = 0; i < dropdowns.length; i++) {
                    var openDropdown = dropdowns[i];
                    if (openDropdown.classList.contains('show')) {
                        openDropdown.classList.remove('show');
                    }
                }
            }
        }

        function sendMessage(roomId) {
            const messageInput = document.getElementById(`chatMessage`);
            const messageContent = messageInput.value.trim();
            if (messageContent === '') return;

            // For now, just append the message to the chat box
            const chatBox = document.getElementById("chatBox");
            const newMessageDiv = document.createElement('div');
            newMessageDiv.classList.add('message', 'sent');
            newMessageDiv.innerHTML = `<p>${messageContent}</p><span class="message-meta">Bạn - <fmt:formatDate value="<%= new java.util.Date() %>" pattern="HH:mm"/></span>`;
            chatBox.appendChild(newMessageDiv);
            chatBox.scrollTop = chatBox.scrollHeight;
            messageInput.value = '';

            // In a real application, you would send this message to the server via WebSocket or AJAX
            console.log(`Sending message to room ${roomId}: ${messageContent}`);
        }
    </script>
</body>
</html>