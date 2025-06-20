<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StudyMate - Thư viện tài liệu</title>
    <link href="<c:url value='/assets/css/bootstrap.min.css'/>" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/dashboard.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/document.css"/>
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
                    
                </div>
                
                <div class="col-md-3">
                    
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
            <!-- Hiển thị tên file gốc -->
            <div class="mb-2">
                <div class="doc-meta mb-1">
                    <i class="fas fa-file me-1"></i>
                    <!-- Lấy tên file gốc từ fileUrl -->
                    ${fn:substringAfter(doc.fileUrl, '_')}
                </div>
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