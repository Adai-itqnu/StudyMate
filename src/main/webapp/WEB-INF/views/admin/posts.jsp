<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="<c:url value='/assets/css/bootstrap.min.css'/>" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/admin_posts.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/admin_dashboard.css"/>
    <title>Quản lý bài viết - StudyMate Admin</title>
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
    <div class="post-management">
        <!-- Page Header -->
        <div class="page-header">
            <h1 class="page-title">📝 Quản lý bài viết</h1>
            <a href="${pageContext.request.contextPath}/admin/dashboard"  class="back-btn">⬅ Quay lại Dashboard</a>
        </div>

        <!-- Search Section -->
        <div class="search-section">
            <form action="${pageContext.request.contextPath}/admin/posts/search" method="get" class="search-form">
                <input 
                    type="text" 
                    name="keyword" 
                    class="search-input" 
                    placeholder="Tìm kiếm theo tiêu đề hoặc nội dung bài viết..." 
                    value="${keyword}"
                >
                <button type="submit" class="search-btn">🔍 Tìm kiếm</button>
            </form>
        </div>

        <!-- Results Info -->
        <c:if test="${not empty keyword}">
            <div class="results-info">
                🔍 Kết quả tìm kiếm cho: "<c:out value="${keyword}"/>" - Tìm thấy ${posts.size()} kết quả
            </div>
        </c:if>

        <!-- Posts Header -->
        <div class="posts-header">
            📝 Danh sách bài viết (${posts.size()} bài viết)
        </div>

        <!-- Posts Container -->
        <div class="posts-container">
            <c:choose>
                <c:when test="${not empty posts}">
                    <c:forEach var="post" items="${posts}">
                        <div class="post-card">
                            <!-- Post Header -->
                            <div class="post-header">
                                <div class="post-info">
                                    <div class="post-id">ID: #${post.postId}</div>
                                    <h3 class="post-title"><c:out value="${post.title}"/></h3>
                                    <div class="post-meta">
                                        <div class="post-author">
                                            <img 
                                                src="${pageContext.request.contextPath}/assets/images/default-avatar.png" 
                                                alt="Avatar" 
                                                class="author-avatar"
                                                onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjQiIGhlaWdodD0iMjQiIHZpZXdCb3g9IjAgMCAyNCAyNCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEyIDEyQzE0LjIwOTEgMTIgMTYgMTAuMjA5MSAxNiA4QzE2IDUuNzkwODYgMTQuMjA5MSA0IDEyIDRDOS43OTA4NiA0IDggNS43OTA4NiA4IDhDOCAxMC4yMDkxIDkuNzkwODYgMTIgMTIgMTJaIiBmaWxsPSIjOTk5Ii8+CjxwYXRoIGQ9Ik0xMiAxNEM4LjEzNDAxIDE0IDUgMTcuMTM0IDUgMjFIMTlDMTkgMTcuMTM0IDE1Ljg2NiAxNCAxMiAxNFoiIGZpbGw9IiM5OTkiLz4KPC9zdmc+'"
                                            >
                                            <span>User ID: ${post.userId}</span>
                                        </div>
                                        <span>|</span>
                                        <span>📅 <fmt:formatDate value="${post.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                                        <span>|</span>
                                        <span class="privacy-badge privacy-${post.privacy.toLowerCase()}">
                                            <c:out value="${post.privacy}"/>
                                        </span>
                                        <span class="status-badge status-${post.status.toLowerCase()}">
                                            <c:out value="${post.status}"/>
                                        </span>
                                    </div>
                                </div>
                                <div class="post-actions">
                                    <button 
                                        type="button" 
                                        class="btn-delete" 
                                        onclick="confirmDeletePost(${post.postId}, '${post.title}')"
                                    >
                                        🗑️ Xóa
                                    </button>
                                </div>
                            </div>

                            <!-- Post Body -->
                            <div class="post-body">
                                <div class="post-content">
                                    <c:out value="${post.body}"/>
                                </div>

                                <!-- Attachments -->
                                <c:if test="${not empty post.attachments}">
                                    <div class="post-attachments">
                                        <div class="attachment-list">
                                            <c:forEach var="attachment" items="${post.attachments}">
                                                <span class="attachment-item">
                                                    📎 <c:out value="${attachment.fileType}"/>
                                                </span>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:if>
                            </div>

                            <!-- Post Stats -->
                            <div class="post-stats">
                                <div class="stat-item">
                                    <span>👍</span>
                                    <span>${post.likeCount} lượt thích</span>
                                </div>
                                <div class="stat-item">
                                    <span>💬</span>
                                    <span>${post.commentCount} bình luận</span>
                                </div>
                                <c:if test="${not empty post.shares}">
                                    <div class="stat-item">
                                        <span>🔄</span>
                                        <span>${post.shares.size()} lượt chia sẻ</span>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-data">
                        <h4>📝 Không có dữ liệu</h4>
                        <p>
                            <c:choose>
                                <c:when test="${not empty keyword}">
                                    Không tìm thấy bài viết nào phù hợp với từ khóa "<c:out value="${keyword}"/>"
                                </c:when>
                                <c:otherwise>
                                    Chưa có bài viết nào trong hệ thống
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Form ẩn để xóa post -->
    <form id="deletePostForm" method="POST" action="${pageContext.request.contextPath}/admin/posts/delete" style="display: none;">
        <input type="hidden" name="postId" id="deletePostId">
    </form>

    <script>
        // Xác nhận xóa bài viết
        function confirmDeletePost(postId, title) {
            if (confirm('Bạn có chắc chắn muốn xóa bài viết "' + title + '"?\n\nHành động này sẽ xóa vĩnh viễn bài viết và tất cả dữ liệu liên quan (like, comment, share).')) {
                document.getElementById('deletePostId').value = postId;
                document.getElementById('deletePostForm').submit();
            }
        }

        // Xử lý form tìm kiếm
        document.querySelector('.search-form').addEventListener('submit', function(e) {
            const keyword = this.querySelector('.search-input').value.trim();
            if (!keyword) {
                e.preventDefault();
                alert('Vui lòng nhập từ khóa tìm kiếm!');
                return;
            }
        });

        // Highlight từ khóa tìm kiếm
        document.addEventListener('DOMContentLoaded', function() {
            const keyword = '${keyword}';
            if (keyword && keyword.trim() !== '') {
                highlightKeyword(keyword);
            }
        });

        function highlightKeyword(keyword) {
            const posts = document.querySelectorAll('.post-title, .post-content');
            posts.forEach(element => {
                const text = element.innerHTML;
                const regex = new RegExp(`(${keyword})`, 'gi');
                element.innerHTML = text.replace(regex, '<mark style="background-color: #ffeb3b;">$1</mark>');
            });
        }
    </script>
</body>
</html>