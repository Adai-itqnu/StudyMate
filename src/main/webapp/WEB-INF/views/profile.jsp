<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin cá nhân - StudyMate</title>
    <link href="<c:url value='/assets/css/bootstrap.min.css'/>" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet"/>
    <style>
        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
        }
        .profile-avatar {
            position: relative;
        }
        .profile-avatar img, .profile-avatar .avatar-placeholder {
            border: 4px solid white;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .info-card {
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border: none;
            border-radius: 10px;
        }
        .info-item {
            padding: 1rem 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .info-item:last-child {
            border-bottom: none;
        }
        .info-label {
            font-weight: 600;
            color: #6c757d;
            font-size: 0.9rem;
        }
        .info-value {
            color: #495057;
            margin-top: 0.25rem;
        }
        .empty-value {
            color: #adb5bd;
            font-style: italic;
        }
    </style>
</head>
<body class="bg-light">
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="<c:url value='/dashboard'/>">
                <i class="fas fa-graduation-cap"></i> StudyMate
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="<c:url value='/dashboard'/>">
                    <i class="fas fa-home"></i> Trang chủ
                </a>
                <a class="nav-link active" href="<c:url value='/profile'/>">
                    <i class="fas fa-user"></i> Trang cá nhân
                </a>
                <a class="nav-link" href="<c:url value='/profile/search'/>">
                    <i class="fas fa-search"></i> Tìm kiếm
                </a>
                <a class="nav-link" href="<c:url value='/logout'/>">
                    <i class="fas fa-sign-out-alt"></i> Đăng xuất
                </a>
            </div>
        </div>
    </nav>

    <!-- Profile Header -->
    <div class="profile-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-3 text-center">
                    <div class="profile-avatar">
                        <c:choose>
                            <c:when test="${not empty currentUser.avatarUrl}">
                                <img src="${currentUser.avatarUrl}" class="rounded-circle" width="150" height="150" alt="Avatar"/>
                            </c:when>
                            <c:otherwise>
                                <div class="avatar-placeholder bg-white text-primary rounded-circle d-flex align-items-center justify-content-center" style="width: 150px; height: 150px; margin: 0 auto;">
                                    <i class="fas fa-user fa-4x"></i>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="col-md-9">
                    <h2 class="mb-2">${currentUser.fullName}</h2>
                    <p class="mb-2">
                        <i class="fas fa-at"></i> ${currentUser.username}
                    </p>
                    <c:if test="${not empty currentUser.bio}">
                        <p class="mb-3">
                            <i class="fas fa-quote-left"></i> ${currentUser.bio}
                        </p>
                    </c:if>
                    <div class="d-flex gap-3">
                        <a href="<c:url value='/profile/settings'/>" class="btn btn-light">
                            <i class="fas fa-edit"></i> Chỉnh sửa thông tin
                        </a>
                        <a href="<c:url value='/profile'/>" class="btn btn-outline-light">
                            <i class="fas fa-eye"></i> Xem trang cá nhân
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container mt-4">
        <div class="row">
            <!-- Personal Information -->
            <div class="col-md-6 mb-4">
                <div class="card info-card">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-user-circle"></i> Thông tin cá nhân
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="info-item">
                            <div class="info-label">Họ và tên</div>
                            <div class="info-value">${currentUser.fullName}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Tên đăng nhập</div>
                            <div class="info-value">@${currentUser.username}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Email</div>
                            <div class="info-value">
                                <i class="fas fa-envelope text-muted"></i> ${currentUser.email}
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Số điện thoại</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty currentUser.phone}">
                                        <i class="fas fa-phone text-muted"></i> ${currentUser.phone}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="empty-value">Chưa cập nhật</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Ngày sinh</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty currentUser.dateOfBirth}">
                                        <i class="fas fa-calendar text-muted"></i> 
                                        <fmt:formatDate value="${currentUser.dateOfBirth}" pattern="dd/MM/yyyy"/>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="empty-value">Chưa cập nhật</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Giới thiệu bản thân</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty currentUser.bio}">
                                        ${currentUser.bio}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="empty-value">Chưa có giới thiệu</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Account Information -->
            <div class="col-md-6 mb-4">
                <div class="card info-card">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-cog"></i> Thông tin tài khoản
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="info-item">
                            <div class="info-label">Vai trò</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${currentUser.role == 'ADMIN'}">
                                        <span class="badge bg-danger">
                                            <i class="fas fa-crown"></i> Quản trị viên
                                        </span>
                                    </c:when>
                                    <c:when test="${currentUser.role == 'TEACHER'}">
                                        <span class="badge bg-info">
                                            <i class="fas fa-chalkboard-teacher"></i> Giáo viên
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-primary">
                                            <i class="fas fa-user-graduate"></i> Học sinh
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Trạng thái tài khoản</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${currentUser.status == 'ACTIVE'}">
                                        <span class="badge bg-success">
                                            <i class="fas fa-check-circle"></i> Hoạt động
                                        </span>
                                    </c:when>
                                    <c:when test="${currentUser.status == 'INACTIVE'}">
                                        <span class="badge bg-warning">
                                            <i class="fas fa-pause-circle"></i> Tạm dừng
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger">
                                            <i class="fas fa-ban"></i> Bị khóa
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Ngày tham gia</div>
                            <div class="info-value">
                                <i class="fas fa-calendar-plus text-muted"></i>
                                <fmt:formatDate value="${currentUser.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Cập nhật lần cuối</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty currentUser.updatedAt}">
                                        <i class="fas fa-edit text-muted"></i>
                                        <fmt:formatDate value="${currentUser.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="empty-value">Chưa có cập nhật</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Trường học</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${currentUser.schoolId > 0}">
                                        <i class="fas fa-school text-muted"></i> ID: ${currentUser.schoolId}
                                    </c:when>
                                    <c:otherwise>
                                        <span class="empty-value">Chưa chọn trường</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="row">
            <div class="col-12">
                <div class="card info-card">
                    <div class="card-header bg-warning text-dark">
                        <h5 class="mb-0">
                            <i class="fas fa-bolt"></i> Thao tác nhanh
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-3 col-sm-6 mb-3">
                                <a href="<c:url value='/profile/settings'/>" class="btn btn-outline-primary w-100">
                                    <i class="fas fa-user-edit"></i><br>
                                    <small>Chỉnh sửa thông tin</small>
                                </a>
                            </div>
                            <div class="col-md-3 col-sm-6 mb-3">
                                <a href="<c:url value='/profile'/>" class="btn btn-outline-info w-100">
                                    <i class="fas fa-eye"></i><br>
                                    <small>Xem trang cá nhân</small>
                                </a>
                            </div>
                            <div class="col-md-3 col-sm-6 mb-3">
                                <a href="<c:url value='/post/create'/>" class="btn btn-outline-success w-100">
                                    <i class="fas fa-plus-circle"></i><br>
                                    <small>Tạo bài viết mới</small>
                                </a>
                            </div>
                            <div class="col-md-3 col-sm-6 mb-3">
                                <a href="<c:url value='/profile/search'/>" class="btn btn-outline-secondary w-100">
                                    <i class="fas fa-search"></i><br>
                                    <small>Tìm bạn bè</small>
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="<c:url value='/assets/js/bootstrap.bundle.min.js'/>"></script>
</body>
</html>