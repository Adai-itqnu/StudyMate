<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StudyMate - Thành viên nhóm ${room.name}</title>
    <link href="<c:url value='/assets/css/bootstrap.min.css'/>" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/dashboard.css"/>
    <style>
        .btn-purple {
            background: linear-gradient(135deg, #8e24aa, #ba68c8);
            color: #fff;
            border: none;
            border-radius: 25px;
            padding: 8px 16px;
        }
        .btn-purple:hover {
            background: linear-gradient(135deg, #6a1b9a, #8e24aa);
            color: #fff;
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
                <div class="col-md-6"></div>
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
            <!-- Left Sidebar -->
            <div class="col-md-3">
                <div class="sidebar">
                    <h5 class="mb-3"><i class="fas fa-users"></i> Gợi ý theo dõi</h5>
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
                                <button class="btn btn-primary btn-sm me-2" onclick="followUser(${suggestion.userId})">
                                    <i class="fas fa-plus"></i> Theo dõi
                                </button>
                                <a href="<c:url value='/profile/${suggestion.userId}'/>" class="btn btn-outline-secondary btn-sm">
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
                    <h5 class="mb-4"><i class="fas fa-users"></i> Thành viên nhóm: ${room.name}</h5>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>
                    <!-- Form thêm thành viên -->
                    <form action="<c:url value='/rooms/${room.roomId}/members/add'/>" method="post" class="mb-4">
                        <div class="input-group">
                            <input type="number" name="userId" class="form-control" placeholder="Nhập ID người dùng" required>
                            <button type="submit" class="btn btn-purple">Thêm thành viên</button>
                        </div>
                    </form>
                    <!-- Danh sách thành viên -->
                    <c:if test="${not empty members}">
                        <div class="card p-3">
                            <ul class="list-group list-group-flush">
                                <c:forEach var="member" items="${members}">
                                    <li class="list-group-item d-flex justify-content-between align-items-center">
                                        <div class="d-flex align-items-center">
                                            <img src="${member.avatarUrl != null ? member.avatarUrl : '/assets/images/default-avatar.png'}" 
                                                 alt="Avatar" class="avatar me-3">
                                            <div>
                                                <h6 class="mb-1">${member.fullName}</h6>
                                                <small class="text-muted">@${member.username}</small>
                                            </div>
                                        </div>
                                        <c:if test="${room.userId == currentUser.userId && member.userId != currentUser.userId}">
                                            <form action="<c:url value='/rooms/${room.roomId}/members/${member.userId}/remove'/>" method="post" style="display:inline;">
                                                <button type="submit" class="btn btn-outline-danger btn-sm" 
                                                        onclick="return confirm('Bạn có chắc muốn xóa ${member.fullName} khỏi nhóm?')">
                                                    <i class="fas fa-trash"></i> Xóa
                                                </button>
                                            </form>
                                        </c:if>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>
                    <c:if test="${empty members}">
                        <div class="alert alert-info">Chưa có thành viên nào trong nhóm.</div>
                    </c:if>
                </div>
            </div>

            <!-- Right Sidebar -->
            <div class="col-md-3">
                <div class="right-sidebar">
                    <h5 class="mb-3"><i class="fas fa-tools"></i> Tính năng</h5>
                    <div class="feature-card" onclick="window.location.href='<c:url value='/schedules'/>'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-calendar-alt text-primary fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Tạo lịch học</h6>
                                <small class="text-muted">Lên kế hoạch học tập</small>
                            </div>
                        </div>
                    </div>
                    <div class="feature-card" onclick="window.location.href='<c:url value='/notes'/>'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-sticky-note text-warning fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Xem ghi chú</h6>
                                <small class="text-muted">Quản lý ghi chú cá nhân</small>
                            </div>
                        </div>
                    </div>
                    <div class="feature-card" onclick="window.location.href='<c:url value='/tasks'/>'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-list-check text-success fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Xem task</h6>
                                <small class="text-muted">Theo dõi công việc</small>
                            </div>
                        </div>
                    </div>
                    <div class="feature-card" onclick="window.location.href='<c:url value='/documents'/>'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-book-open text-info fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Thư viện tài liệu</h6>
                                <small class="text-muted">Tài liệu học tập</small>
                            </div>
                        </div>
                    </div>
                    <div class="feature-card" onclick="window.location.href='<c:url value='/rooms'/>'">
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
    <script src="<c:url value='/assets/js/bootstrap.bundle.min.js'/>"></script>
    <script src="${pageContext.request.contextPath}/resources/assets/js/dashboard.js"></script>
</body>
</html>