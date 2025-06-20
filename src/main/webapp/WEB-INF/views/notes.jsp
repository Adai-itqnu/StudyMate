<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StudyMate - Ghi chú học tập</title>
    <link href="<c:url value='/assets/css/bootstrap.min.css'/>" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/dashboard.css"/>
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
            </div>
        </div>
    </div>
    <div class="container-fluid mt-4">
        <div class="row">
            <!-- Sidebar trái: Gợi ý theo dõi -->
            <div class="col-md-3">
                <div class="sidebar">
                    <h5 class="mb-3">
                        <i class="fas fa-users"></i> Gợi ý theo dõi
                    </h5>
                    
                    
                </div>
            </div>
            <!-- Main Content Area: Ghi chú -->
            <div class="col-md-6">
                <div class="main-content">
                    <div class="post-form" style="border-radius: 20px; box-shadow: 0 4px 24px rgba(142,36,170,0.10); padding: 36px 32px 28px 32px; background: #fff;">
                        <h5 class="mb-4" style="font-weight:800; color:#8e24aa; letter-spacing:-1px;">
                            <i class="fas fa-sticky-note me-2"></i> Ghi chú học tập
                        </h5>
                        <!-- Form thêm ghi chú mới -->
                        <form action="${pageContext.request.contextPath}/notes/create" method="post" class="mb-4 d-flex">
                            <textarea name="content" class="form-control me-2" rows="2" placeholder="Viết ghi chú mới..." required style="border-radius:12px;"></textarea>
                            <button type="submit" class="btn btn-purple" style="border-radius:12px;font-weight:600;">
                                <i class="fas fa-plus"></i> Thêm
                            </button>
                        </form>
                        <!-- Danh sách ghi chú -->
                        <c:if test="${not empty notes}">
                            <div class="list-group">
                                <c:forEach var="note" items="${notes}">
                                    <div class="list-group-item mb-3" style="border-radius:12px; box-shadow:0 2px 8px rgba(142,36,170,0.06);">
                                        <form action="${pageContext.request.contextPath}/notes/update" method="post" class="d-flex align-items-center">
                                            <input type="hidden" name="noteId" value="${note.noteId}"/>
                                            <textarea name="content" class="form-control me-2" rows="2" style="border-radius:8px;">${note.content}</textarea>
                                            <button type="submit" class="btn btn-outline-success me-2" style="border-radius:8px;">
                                                <i class="fas fa-save"></i>
                                            </button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/notes/delete" method="post" class="d-inline">
                                            <input type="hidden" name="noteId" value="${note.noteId}"/>
                                            <button type="submit" class="btn btn-outline-danger btn-sm mt-2" style="border-radius:8px;">
                                                <i class="fas fa-trash"></i> Xóa
                                            </button>
                                        </form>
                                        <div class="text-end text-muted small mt-1">
                                            <fmt:formatDate value="${note.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>
                        <c:if test="${empty notes}">
                            <div class="alert alert-info mt-4" style="border-radius:12px;">
                                <i class="fas fa-info-circle me-2"></i> Bạn chưa có ghi chú nào.
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
            <!-- Sidebar phải: có thể thêm tính năng khác sau -->
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
    <script src="<c:url value='/assets/js/bootstrap.bundle.min.js'/>"/>
</body>
</html> 