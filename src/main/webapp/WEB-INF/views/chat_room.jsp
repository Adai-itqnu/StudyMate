<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>StudyMate - Phòng Chat: ${room.name}</title>

  <!-- Bootstrap 5.3.0 -->
  <link
    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
    rel="stylesheet"
  >
  <!-- FontAwesome 6.x -->
  <link
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    rel="stylesheet"
  >
  <!-- CSS riêng -->
  <link
    rel="stylesheet"
    href="${pageContext.request.contextPath}/resources/assets/css/dashboard.css"
  />

  <style>
    /* Khung chat */
    .chat-box {
      border: 1px solid #e0e0e0;
      border-radius: 8px;
      padding: 15px;
      height: 400px;
      overflow-y: auto;
    }
    /* Tin nhắn */
    .message {
      margin-bottom: 10px;
      max-width: 75%;
      position: relative;
      padding: 10px;
    }
    .message.received {
      background: #f1f1f1;
      color: #333;
      border-radius: 10px 10px 10px 0;
    }
    .message.sent {
      background: linear-gradient(90deg, #6dd5ed 0%, #2193b0 100%); /* xanh ngọc nhạt chuyển xanh biển */
      color: #fff;
      border-radius: 10px 10px 0 10px;
      margin-left: auto;
    }
    .message-meta {
      display: block;
      font-size: 0.75rem;
      color: #888;
      margin-top: 4px;
      text-align: right;
    }
    /* Thanh nhập và nút gửi */
    .message-input textarea.form-control {
      height: 38px;
      min-height: 38px;
      max-height: 38px;
      border-radius: 20px 0 0 20px;
      padding: 8px 15px;
      resize: none;
      overflow: hidden; /* Ẩn thanh cuộn */
    }
    .message-input button {
      height: 38px;
      border-radius: 0 20px 20px 0;
      padding: 0 15px;
      font-size: 1.1em;
    }
  </style>
</head>
<body>
	<!-- Header -->
    <div class="header">
        <div class="container-fluid">
            <div class="row align-items-center py-3">
                <div class="col-md-3">
                    <a href="<c:url value='/dashboard'/>" class="text-decoration-none">
                        <h4 class="mb-0 text-primary">
                            <i class="fas fa-graduation-cap"></i> StudyMate
                        </h4>
                    </a>
                </div>
                <div class="col-md-6">
                    <form action="<c:url value='/dashboard'/>" method="get" class="d-flex justify-content-center">
                        <div class="input-group search-box">
                            <input type="text" name="search" class="form-control" placeholder="Tìm kiếm người dùng...">
                            <button class="btn btn-outline-primary" type="submit">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
  <div class="container mt-4">
    <div class="row">
      <!-- Sidebar trái (nếu có) -->
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

      <!-- Khu vực Chat chính -->
      <div class="col-md-6">
        <h5 class="mb-3">
          <i class="fas fa-comments"></i>
          Phòng Chat: ${room.name}
        </h5>

        <!-- Chat messages -->
        <div class="chat-box" id="chatBox">
          <div class="message received">
            <p>Chào mừng đến với phòng chat!</p>
            <span class="message-meta">
              <fmt:formatDate value="${now}" pattern="HH:mm"/>
            </span>
          </div>
          <!-- Tin nhắn mới sẽ được append ở đây -->
        </div>

        <!-- Thanh nhập tin -->
        <div class="message-input d-flex align-items-center mt-2">
          <textarea
            id="chatMessage"
            class="form-control flex-grow-1 me-2"
            rows="1"
            placeholder="Nhập tin nhắn..."
          ></textarea>
          <button
            id="sendBtn"
            class="btn btn-primary d-flex align-items-center justify-content-center"
            type="button"
            onclick="sendMessage(${room.roomId})"
          >
            <i class="fas fa-paper-plane"></i>
          </button>
        </div>
      </div>

      <!-- Sidebar phải (nếu có) -->
      <div class="col-md-3">
                <div class="right-sidebar">
                    <h5 class="mb-3"><i class="fas fa-tools"></i> Tính năng</h5>
                    
                    <!-- 1. Tạo lịch học -->
                    <div class="feature-card" onclick="window.location.href='<c:url value="/schedule"/>'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-calendar-alt text-primary fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Tạo lịch học</h6>
                                <small class="text-muted">Lên kế hoạch học tập</small>
                            </div>
                        </div>
                    </div>
                    
                    <!-- 2. Xem ghi chú -->
                    <div class="feature-card" onclick="window.location.href='<c:url value="/notes"/>'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-sticky-note text-warning fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Xem ghi chú</h6>
                                <small class="text-muted">Quản lý ghi chú cá nhân</small>
                            </div>
                        </div>
                    </div>
                    
                    <!-- 3. Xem task -->
                    <div class="feature-card" onclick="window.location.href='<c:url value="/tasks"/>'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-list-check text-success fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Xem task</h6>
                                <small class="text-muted">Theo dõi công việc</small>
                            </div>
                        </div>
                    </div>
                    
                    <!-- 4. Thư viện tài liệu -->
                    <div class="feature-card" onclick="window.location.href='<c:url value="/documents"/>'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-book-open text-info fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Thư viện tài liệu</h6>
                                <small class="text-muted">Tài liệu học tập</small>
                            </div>
                        </div>
                    </div>
	                    
                    <!-- 5. Nhóm học tập -->
                    <div class="feature-card" onclick="window.location.href='<c:url value="/rooms"/>'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-users text-primary fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Nhóm học tập</h6>
                                <small class="text-muted">Tham gia nhóm học</small>
                            </div>
                        </div>
                    </div>
                    
                    
                </div>
      </div>
    </div>
  </div>

  <script>
    function sendMessage(roomId) {
      const input = document.getElementById("chatMessage");
      const text = input.value.trim();
      if (!text) return;

      // Lấy timestamp hiện tại
      const now = new Date();
      const hh = now.getHours().toString().padStart(2, "0");
      const mm = now.getMinutes().toString().padStart(2, "0");
      const time = `${hh}:${mm}`;

      // Tạo div tin nhắn mới
      const chatBox = document.getElementById("chatBox");
      const msgDiv = document.createElement("div");
      msgDiv.classList.add("message", "sent");

      // Tạo <p> chứa nội dung
      const p = document.createElement("p");
      p.textContent = text;
      msgDiv.appendChild(p);

      // Tạo <span> chứa timestamp
      const span = document.createElement("span");
      span.classList.add("message-meta");
      span.textContent = time;
      msgDiv.appendChild(span);

      // Append và scroll xuống cuối
      chatBox.appendChild(msgDiv);
      chatBox.scrollTop = chatBox.scrollHeight;
      input.value = "";

      // TODO: Gửi AJAX/WebSocket lên server nếu cần
      console.log(`Sending to room ${roomId}:`, text);
    }
  </script>
</body>
</html>
