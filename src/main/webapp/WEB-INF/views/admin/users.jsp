<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="<c:url value='/assets/css/bootstrap.min.css'/>" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/admin_users.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/admin_dashboard.css"/>
    <title>Quản lý người dùng - StudyMate Admin</title>
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
    <div class="user-management">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">📋 Quản lý người dùng</h1>
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="back-btn">⬅ Quay lại Dashboard</a>
        </div>

        <!-- Search Section -->
        <div class="search-section">
            <form action="${pageContext.request.contextPath}/admin/users/search" method="get" class="search-form">
                <input 
                    type="text" 
                    name="keyword" 
                    class="search-input" 
                    placeholder="Tìm kiếm theo tên, username hoặc email..." 
                    value="${keyword}"
                >
                <button type="submit" class="search-btn">🔍 Tìm kiếm</button>
            </form>
        </div>

        <!-- Results Info -->
        <c:if test="${not empty keyword}">
            <div class="results-info">
                🔍 Kết quả tìm kiếm cho: "<c:out value="${keyword}"/>" - Tìm thấy ${users.size()} kết quả
            </div>
        </c:if>

        <!-- Users Table -->
        <div class="users-table-container">
            <div class="table-header">
                👥 Danh sách người dùng (${users.size()} người dùng)
            </div>
            
            <c:choose>
                <c:when test="${not empty users}">
                    <table class="users-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Thông tin người dùng</th>
                                <th>Email</th>
                                <th>Vai trò</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${users}">
                                <tr>
                                    <td><strong>#${user.userId}</strong></td>
                                    <td>
                                        <div class="user-info">
                                            <img 
                                                src="${user.avatarUrl != null ? user.avatarUrl : pageContext.request.contextPath += '/resources/assets/images/avatar.png'}" 
                                                alt="Avatar" 
                                                class="user-avatar"
                                            >
                                            <div class="user-details">
                                                <h6><c:out value="${user.fullName}"/></h6>
                                                <small>@<c:out value="${user.username}"/></small>
                                            </div>
                                        </div>
                                    </td>
                                    <td><c:out value="${user.email}"/></td>
                                    <td>
                                        <span class="role-badge ${user.role == 'ADMIN' ? 'role-admin' : 'role-user'}">
                                            <c:out value="${user.role}"/>
                                        </span>
                                    </td>
                                    <td>
                                        <span class="status-badge ${user.status == 'ACTIVE' ? 'status-active' : 'status-inactive'}">
                                            <c:out value="${user.status}"/>
                                        </span>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <button 
                                                type="button" 
                                                class="btn-delete" 
                                                onclick="confirmDeleteUser(${user.userId}, '${user.fullName}')"
                                            >
                                                🗑️ Xóa
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-data">
                        <h4>📝 Không có dữ liệu</h4>
                        <p>
                            <c:choose>
                                <c:when test="${not empty keyword}">
                                    Không tìm thấy người dùng nào phù hợp với từ khóa "<c:out value="${keyword}"/>"
                                </c:when>
                                <c:otherwise>
                                    Chưa có người dùng nào trong hệ thống
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Delete Form (Hidden) -->
    <form id="deleteForm" action="${pageContext.request.contextPath}/admin/users/delete" method="post" style="display: none;">
        <input type="hidden" name="userId" id="deleteUserId">
    </form>

    <script>
        function confirmDeleteUser(userId, userName) {
            if (confirm(`Bạn có chắc chắn muốn xóa người dùng "${userName}"?\n\nHành động này không thể hoàn tác!`)) {
                document.getElementById('deleteUserId').value = userId;
                document.getElementById('deleteForm').submit();
            }
        }

        // Enhanced search
        document.querySelector('.search-form').addEventListener('submit', function(e) {
            const keyword = this.querySelector('.search-input').value.trim();
            if (!keyword) {
                e.preventDefault();
                alert('Vui lòng nhập từ khóa tìm kiếm!');
                return;
            }
        });

        // Auto focus search input if there's a keyword
        document.addEventListener('DOMContentLoaded', function() {
            const keywordInput = document.querySelector('.search-input');
            if (keywordInput.value) {
                keywordInput.focus();
                keywordInput.setSelectionRange(keywordInput.value.length, keywordInput.value.length);
            }
        });
    </script>
</body>
</html>