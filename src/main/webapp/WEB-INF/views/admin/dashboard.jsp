<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="<c:url value='/assets/css/bootstrap.min.css'/>" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/admin_dashboard.css"/>
    <title>Admin Dashboard - StudyMate</title>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="logo">StudyMate Admin</a>
        

        <div class="admin-info">
            <span class="admin-name">👤 <c:out value="${sessionScope.currentUser.fullName}" default="Administrator"/></span>
            
            <a href="${pageContext.request.contextPath}/login" class="logout-btn">Đăng xuất</a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Welcome Section -->
        <div class="welcome-section">
            <h1 class="welcome-title">Bảng Điều Khiển Quản Trị</h1>
            <p class="welcome-subtitle">Quản lý hệ thống StudyMate một cách hiệu quả</p>
        </div>

        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-number">${totalUsers}</div>
                <div class="stat-label">Tổng người dùng</div>
            </div>
            <div class="stat-card">
                <div class="stat-number">${totalPosts}</div>
                <div class="stat-label">Tổng bài viết</div>
            </div>
        </div>

        <!-- Management Grid -->
        <div class="management-grid">
            <!-- User Management Card -->
            <div class="management-card">
                <div class="card-header">
                    <div class="card-icon users-icon">👥</div>
                    <h3 class="card-title">Quản Lý Người Dùng</h3>
                </div>
                <p class="card-description">
                    Xem danh sách, tìm kiếm và quản lý tất cả người dùng trong hệ thống. 
                    Bạn có thể xóa tài khoản người dùng vi phạm quy định.
                </p>
                <div class="card-actions">
                    <a href="${pageContext.request.contextPath}/admin/users" class="action-btn btn-primary">📋 Xem danh sách</a>
                </div>
            </div>

            <!-- Post Management Card -->
            <div class="management-card">
                <div class="card-header">
                    <div class="card-icon posts-icon">📝</div>
                    <h3 class="card-title">Quản Lý Bài Viết</h3>
                </div>
                <p class="card-description">
                    Xem danh sách, tìm kiếm và quản lý tất cả bài viết trong hệ thống. 
                    Bạn có thể xóa bài viết vi phạm quy định.
                </p>
                <div class="card-actions">
                    <a href="${pageContext.request.contextPath}/admin/posts" class="action-btn btn-primary">📋 Xem danh sách</a>
                </div>
            </div>

        </div>
    </div>

    <script>
        // Animate numbers on page load
        function animateNumbers() {
            const numbers = document.querySelectorAll('.stat-number');
            numbers.forEach(number => {
                const target = parseInt(number.textContent.replace(/,/g, ''));
                if (isNaN(target)) return;
                
                let current = 0;
                const increment = target / 100;
                const timer = setInterval(() => {
                    current += increment;
                    if (current >= target) {
                        current = target;
                        clearInterval(timer);
                    }
                    number.textContent = Math.floor(current).toLocaleString();
                }, 20);
            });
        }

        // Search form enhancement
        document.querySelector('.search-form').addEventListener('submit', function(e) {
            const keyword = this.querySelector('.search-input').value.trim();
            if (!keyword) {
                e.preventDefault();
                alert('Vui lòng nhập từ khóa tìm kiếm!');
                return;
            }
        });

        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            animateNumbers();
        });
    </script>
</body>
</html>