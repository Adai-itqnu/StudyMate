<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StudyMate - Danh sách nhóm</title>
    <link href="<c:url value='/assets/css/bootstrap.min.css'/>" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/room.css"/>
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
                <div class="col-md-6 text-center">
                    <!-- Ô tìm kiếm đã bị loại bỏ -->
                </div>
                <div class="col-md-3">
                    
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
                    
                </div>
            </div>

            <!-- Main Content Area: Danh sách nhóm -->
            <div class="col-md-6">
                <div class="main-content">
                    <div class="post-form">
                        <h5 class="mb-3">
                            <i class="fas fa-users"></i> Danh sách nhóm học tập
                        </h5>
                        <div class="mb-4">
                            <a href="<c:url value='/rooms/create'/>" class="btn btn-purple">
                                <i class="fas fa-plus-circle me-2"></i> Tạo nhóm mới
                            </a>
                        </div>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>
                        <c:if test="${not empty message}">
                            <div class="alert alert-success">${message}</div>
                        </c:if>
                        <c:if test="${not empty rooms}">
                            <div class="row">
                                <c:forEach var="room" items="${rooms}">
                                    <div class="col-md-6 mb-4">
                                        <div class="card room-card p-3">
                                            <!-- Action buttons cho owner -->
                                            <c:if test="${room.userId == currentUser.userId}">
                                                <div class="card-actions">
                                                    <a href="<c:url value='/rooms/${room.roomId}/edit'/>" class="btn btn-outline-warning btn-xs" title="Sửa">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <form action="<c:url value='/rooms/${room.roomId}/delete'/>" method="post" style="display:inline;">
                                                        <button type="submit" class="btn btn-outline-danger btn-xs" title="Xóa"
                                                                onclick="return confirm('Bạn có chắc muốn xóa nhóm ${room.name}?')">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </form>
                                                </div>
                                            </c:if>
                                            
                                            <div class="card-content">
                                                <div class="card-header-info">
                                                    <h6 class="mb-1">${room.name}</h6>
                                                    <small class="text-muted mb-2"><i class="fas fa-map-marker-alt"></i> ${room.location}</small>
                                                </div>
                                                <div class="card-actions-bottom">
                                                    <c:choose>
                                                        <c:when test="${room.userId == currentUser.userId}">
                                                            <!-- Người tạo nhóm chỉ thấy nút Xem thành viên nhỏ -->
                                                            <a href="<c:url value='/rooms/${room.roomId}/members'/>" class="btn btn-primary btn-xs">
                                                                <i class="fas fa-users"></i> Thành viên
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <!-- Người dùng khác thấy nút Tham gia nhóm và Xem thành viên -->
                                                            <div class="d-flex gap-2">
    <c:if test="${room.userId != currentUser.userId && empty room.members}">
        <form action="<c:url value='/rooms/${room.roomId}/members/add'/>" method="post" style="display:inline;">
            <input type="hidden" name="userId" value="${currentUser.userId}">
            <button type="submit" class="btn btn-purple btn-xs" style="background: linear-gradient(135deg, #8e24aa, #ba68c8); color: #fff; border: none; border-radius: 20px; padding: 6px 12px; font-size: 0.75rem; font-weight: 600; transition: all 0.3s ease; display: flex; align-items: center; gap: 5px;">
                <i class="fas fa-plus-circle"></i> Tham gia
            </button>
        </form>
    </c:if>
    <a href="<c:url value='/rooms/${room.roomId}/members'/>" class="btn btn-outline-primary btn-xs" style="border: 2px solid rgba(186, 104, 200, 0.5); border-radius: 20px; padding: 6px 12px; font-size: 0.75rem; color: #666; font-weight: 600; transition: all 0.3s ease; text-decoration: none; display: flex; align-items: center; gap: 5px;">
        <i class="fas fa-users"></i> Thành viên
    </a>
</div>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>
                        <c:if test="${empty rooms}">
                            <div class="alert alert-info mt-4" style="border-radius:12px;">
                                <i class="fas fa-info-circle me-2"></i> Hiện chưa có nhóm nào.
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>

            <!-- Right Sidebar - Features -->
            <div class="col-md-3">
                <div class="right-sidebar">
                    <h5 class="mb-3">
                        <i class="fas fa-tools"></i> Tính năng
                    </h5>
                    <div class="feature-card" onclick="window.location.href='<c:url value='/schedule'/>'">
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