<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StudyMate - Tạo Phòng Học</title>
    <link href="<c:url value='/assets/css/bootstrap.min.css'/>" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
   <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/dashboard.css"/>
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
                            <i class="fas fa-plus-circle"></i> Tạo Phòng Học Mới
                        </h5>
                        <form action="<c:url value='/rooms/create'/>" method="post">
                            <div class="mb-3">
                                <label for="roomName" class="form-label">Tên phòng học:</label>
                                <input type="text" class="form-control" id="roomName" name="name" required>
                            </div>
                            <div class="mb-3">
                                <label for="location" class="form-label">Địa điểm:</label>
                                <input type="text" class="form-control" id="location" name="location" required>
                            </div>
                            <%-- Removed description field as it's not in the database --%>
                            <%-- Removed roomType field as it's not in the database --%>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-paper-plane"></i> Tạo phòng
                            </button>
                        </form>
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

        // Implement followUser and other JS functions if needed for this page
    </script>
</body>
</html>