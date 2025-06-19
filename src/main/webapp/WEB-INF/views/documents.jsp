<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StudyMate - Thư viện tài liệu</title>
    <link href="<c:url value='/assets/css/bootstrap.min.css'/>" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/dashboard.css"/>
    <style>
        body {
            font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', sans-serif;
            background: linear-gradient(135deg, #faf8f7 0%, #f8f5f3 50%, #ffffff 100%);
            min-height: 100vh;
            color: #333;
        }
        .doc-card {
            box-shadow: 0 4px 20px rgba(142,36,170,0.10);
            border-radius: 18px;
            margin-bottom: 28px;
            border: 1.5px solid #e1bee7;
            background: white;
            transition: box-shadow 0.2s, transform 0.2s;
        }
        .doc-card:hover {
            box-shadow: 0 8px 32px rgba(142,36,170,0.18);
            transform: translateY(-3px) scale(1.02);
        }
        .doc-title {
            font-weight: 700;
            font-size: 1.15rem;
            color: #8e24aa;
        }
        .doc-meta {
            color: #888;
            font-size: 0.98rem;
        }
        .doc-link {
            color: #8e24aa;
            font-weight: 500;
            border-radius: 8px;
            padding: 6px 14px;
            background: linear-gradient(135deg, #f3e5f5, #e1bee7);
            text-decoration: none;
            transition: background 0.2s, color 0.2s;
        }
        .doc-link:hover {
            background: linear-gradient(135deg, #8e24aa, #ba68c8);
            color: #fff;
            text-decoration: none;
        }
        .header-gradient {
            background: linear-gradient(135deg, #8e24aa 0%, #ba68c8 60%, #e1bee7 100%);
            border-radius: 18px;
            box-shadow: 0 4px 20px rgba(142,36,170,0.10);
            padding: 24px 32px 18px 32px;
            margin-bottom: 32px;
        }
        .header-gradient h2 {
            color: #fff;
            font-weight: 800;
            letter-spacing: -1px;
            text-shadow: 0 2px 8px rgba(142,36,170,0.10);
        }
        .btn-purple {
            background: linear-gradient(135deg, #8e24aa, #ba68c8);
            color: #fff;
            border: none;
            font-weight: 600;
            border-radius: 25px;
            padding: 10px 26px;
            transition: background 0.2s, box-shadow 0.2s;
        }
        .btn-purple:hover {
            background: linear-gradient(135deg, #6a1b9a, #8e24aa);
            color: #fff;
            box-shadow: 0 6px 20px rgba(142,36,170,0.18);
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
                            <input type="text" name="search" class="form-control" 
                                   placeholder="Tìm kiếm người dùng..." 
                                   value="${searchKeyword}">
                            <button class="btn btn-outline-primary" type="submit">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </form>
                </div>
                
                <div class="col-md-3">
                    <div class="d-flex justify-content-end">
                        <div class="user-dropdown">
                            <div class="d-flex align-items-center cursor-pointer" onclick="toggleDropdown()">
                                <img src="${currentUser.avatarUrl != null ? currentUser.avatarUrl : 'resources/assets/images/avatar.png'}" 
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
            <!-- Sidebar trái -->
            <div class="col-md-3">
                <div class="sidebar">
                    <h5 class="mb-3">
                        <i class="fas fa-users"></i> Gợi ý theo dõi
                    </h5>
                    <c:forEach var="suggestion" items="${suggestions}">
                        <div class="suggestion-card">
                            <div class="d-flex align-items-center">
                                <img src="${suggestion.avatarUrl != null ? suggestion.avatarUrl : '/assets/images/default-avatar.png'}" alt="Avatar" class="avatar me-3">
                                <div class="flex-grow-1">
                                    <h6 class="mb-1">${suggestion.fullName}</h6>
                                    <small class="text-muted">@${suggestion.username}</small>
                                </div>
                            </div>
                            <div class="mt-2">
                                <button class="btn btn-primary btn-sm me-2" onclick="followUser(${suggestion.userId})">
                                    <i class="fas fa-plus"></i> Theo dõi
                                </button>
                                <a href="<c:url value='/profile/${suggestion.userId}'/>" class="btn btn-outline-secondary btn-sm">Xem trang</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            <!-- Main Content Area: Thư viện tài liệu -->
            <div class="col-md-6">
                <div class="main-content">
                    <div class="post-form">
                        <h5 class="mb-3">
                            <i class="fas fa-book-open"></i> Thư viện tài liệu học tập
                        </h5>
                        <a href="${pageContext.request.contextPath}/documents/upload" class="btn btn-purple mb-3">
                            <i class="fas fa-upload me-1"></i> Tải tài liệu mới
                        </a>
                        <c:if test="${not empty message}">
                            <div class="alert alert-success"><i class="fas fa-check-circle me-2"></i>${message}</div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger"><i class="fas fa-exclamation-circle me-2"></i>${error}</div>
                        </c:if>
                        <div class="row">
                            <c:forEach var="doc" items="${documents}">
                                <div class="col-12 mb-3">
                                    <div class="card doc-card p-3">
                                        <div class="doc-title mb-1"><i class="fas fa-file-alt text-purple me-2"></i>${doc.title}</div>
                                        <div class="doc-meta mb-2">${doc.description}</div>
                                        <div class="mb-2">
                                            <a class="doc-link" href="${pageContext.request.contextPath}/documents/download?path=${doc.fileUrl}" target="_blank">
											    <i class="fas fa-download me-1"></i>Tải/Xem tài liệu
											</a>
                                        </div>
                                        <div class="doc-meta">
                                            <i class="fas fa-calendar-alt me-1"></i> ${doc.uploadedAt}
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty documents}">
                                <div class="col-12 text-center text-muted py-5">
                                    <i class="fas fa-folder-open fa-2x mb-2"></i><br/>
                                    Chưa có tài liệu nào.
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Sidebar phải -->
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
    <script src="${pageContext.request.contextPath}/resources/assets/js/dashboard.js"></script>
</body>
</html> 