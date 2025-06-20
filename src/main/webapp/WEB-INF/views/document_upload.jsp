<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StudyMate - Tải tài liệu học tập</title>
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
            <!-- Main Content Area: Upload tài liệu -->
            <div class="col-md-6">
                <div class="main-content">
                    <div class="post-form" style="border-radius: 20px; box-shadow: 0 4px 24px rgba(142,36,170,0.10); padding: 36px 32px 28px 32px; background: #fff;">
                        <h5 class="mb-4" style="font-weight:800; color:#8e24aa; letter-spacing:-1px;">
                            <i class="fas fa-upload me-2"></i> Tải tài liệu học tập
                        </h5>
                        <form action="${pageContext.request.contextPath}/documents/upload" method="post" enctype="multipart/form-data">
                            <div class="mb-4">
                                <label for="title" class="form-label" style="color:#8e24aa;font-weight:600;">Tiêu đề <span class="text-danger">*</span></label>
                                <input type="text" class="form-control form-control-lg" id="title" name="title" required style="border-radius:12px;">
                            </div>
                            <div class="mb-4">
                                <label for="description" class="form-label" style="color:#8e24aa;font-weight:600;">Mô tả</label>
                                <textarea class="form-control form-control-lg" id="description" name="description" rows="3" style="border-radius:12px;"></textarea>
                            </div>
                            <div class="mb-4">
                                <label for="file" class="form-label" style="color:#8e24aa;font-weight:600;">Chọn file tài liệu <span class="text-danger">*</span></label>
                                <input type="file" class="form-control form-control-lg" id="file" name="file" accept=".pdf,.doc,.docx,.ppt,.pptx,.xls,.xlsx" required style="border-radius:12px;">
                            </div>
                            <div class="d-flex justify-content-between align-items-center mt-4">
                                <button type="submit" class="btn btn-purple btn-lg px-4" style="border-radius:25px;font-weight:600;">
                                    <i class="fas fa-upload me-1"></i> Tải lên
                                </button>
                                <a href="${pageContext.request.contextPath}/documents" class="btn btn-outline-secondary btn-lg px-4" style="border-radius:25px;">
                                    <i class="fas fa-arrow-left me-1"></i> Quay lại
                                </a>
                            </div>
                        </form>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger mt-4" style="border-radius:12px;"><i class="fas fa-exclamation-circle me-2"></i>${error}</div>
                        </c:if>
                    </div>
                </div>
            </div>
            <!-- Sidebar phải -->
            <div class="col-md-3">
                <div class="right-sidebar">
                    <h5 class="mb-3"><i class="fas fa-tools"></i> Tính năng</h5>
                    <div class="feature-card mb-3" onclick="window.location.href='${pageContext.request.contextPath}/schedules'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-calendar-alt text-primary fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Tạo lịch học</h6>
                                <small class="text-muted">Lên kế hoạch học tập</small>
                            </div>
                        </div>
                    </div>
                    <div class="feature-card mb-3" onclick="window.location.href='${pageContext.request.contextPath}/notes'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-sticky-note text-warning fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Xem ghi chú</h6>
                                <small class="text-muted">Quản lý ghi chú cá nhân</small>
                            </div>
                        </div>
                    </div>
                    <div class="feature-card mb-3" onclick="window.location.href='${pageContext.request.contextPath}/tasks'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-tasks text-success fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Xem task</h6>
                                <small class="text-muted">Theo dõi công việc</small>
                            </div>
                        </div>
                    </div>
                    <div class="feature-card mb-3" onclick="window.location.href='${pageContext.request.contextPath}/documents'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-book text-info fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Thư viện tài liệu</h6>
                                <small class="text-muted">Tài liệu học tập</small>
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