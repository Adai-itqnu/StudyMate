<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>StudyMate - Trang chủ</title>
    <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"/>
    <style>
        body {
            background-color: #f8f9fa;
            min-height: 100vh;
        }
        .navbar-brand {
            font-weight: bold;
            color: #28a745 !important;
            font-size: 1.4rem;
        }
        .user-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            object-fit: cover;
        }
        .sidebar {
            height: calc(100vh - 56px);
            position: sticky;
            top: 56px;
            overflow-y: auto;
        }
        .post-card {
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 5px;
        }
        .post-header {
            display: flex;
            align-items: center;
            padding: 12px 15px;
        }
        .post-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
            object-fit: cover;
        }
        .post-user {
            font-weight: 600;
            margin-bottom: 0;
        }
        .post-time {
            font-size: 0.85rem;
            color: #6c757d;
        }
        .post-content {
            padding: 0 15px 15px;
        }
        .post-image {
            width: 100%;
            max-height: 400px;
            object-fit: contain;
        }
        .post-actions {
            display: flex;
            padding: 8px 15px;
            border-top: 1px solid #dee2e6;
            border-bottom: 1px solid #dee2e6;
        }
        .post-action {
            flex: 1;
            text-align: center;
            padding: 8px 0;
            color: #6c757d;
            cursor: pointer;
            transition: background-color 0.2s;
            border-radius: 5px;
        }
        .post-action:hover {
            background-color: #f1f3f5;
        }
        .post-action.liked {
            color: #007bff;
        }
        .post-comments {
            padding: 15px;
            background-color: #f8f9fa;
        }
        .new-post-card {
            margin-bottom: 1.5rem;
            border-radius: 5px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .new-post-header {
            padding: 15px;
            border-bottom: 1px solid #dee2e6;
        }
        .new-post-body {
            padding: 15px;
        }
        .new-post-footer {
            padding: 10px 15px;
            border-top: 1px solid #dee2e6;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .user-item {
            display: flex;
            align-items: center;
            padding: 8px 0;
            margin-bottom: 10px;
        }
        .user-item-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
            object-fit: cover;
        }
        .user-item-name {
            font-weight: 500;
            margin-bottom: 2px;
        }
        .user-item-username {
            font-size: 0.85rem;
            color: #6c757d;
        }
        .sidebar-title {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #dee2e6;
        }
        .utility-card {
            margin-bottom: 15px;
            border-radius: 5px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .utility-card-header {
            padding: 10px 15px;
            background-color: #f8f9fa;
            font-weight: 600;
            border-bottom: 1px solid #dee2e6;
        }
        .utility-card-body {
            padding: 15px;
        }
        .comment-item {
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
        .comment-user {
            font-weight: 500;
            margin-bottom: 2px;
        }
        .comment-text {
            margin-bottom: 5px;
        }
        .dropdown-menu {
            min-width: 12rem;
        }
        .no-posts {
            text-align: center;
            padding: 2rem;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard">StudyMate</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarContent">
                <form class="d-flex ms-auto me-3" action="${pageContext.request.contextPath}/user/search" method="get">
                    <div class="input-group">
                        <input type="text" name="keyword" class="form-control" placeholder="Tìm kiếm người dùng...">
                        <button class="btn btn-outline-success" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </form>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                            <img src="${pageContext.request.contextPath}/resources/img/${not empty user.avatar ? user.avatar : 'avatar-placeholder.png'}" 
                                 alt="Avatar" class="user-avatar me-2" 
                                 onerror="this.src='${pageContext.request.contextPath}/resources/img/avatar-placeholder.png';">
                            ${user.fullName}
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile">
                                <i class="fas fa-user-circle me-2"></i> Trang cá nhân
                            </a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile/edit">
                                <i class="fas fa-cog me-2"></i> Chỉnh sửa thông tin
                            </a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/followers">
                                <i class="fas fa-users me-2"></i> Người theo dõi
                            </a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/following">
                                <i class="fas fa-user-friends me-2"></i> Đang theo dõi
                            </a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/logout">
                                <i class="fas fa-sign-out-alt me-2"></i> Đăng xuất
                            </a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container py-4">
        <div class="row">
            <!-- Left Sidebar - User List -->
            <div class="col-md-3">
                <div class="sidebar bg-white p-3 rounded shadow-sm">
                    <h5 class="sidebar-title">Người dùng gợi ý</h5>
                    
                    <c:choose>
                        <c:when test="${not empty suggestedUsers}">
                            <c:forEach var="suggestedUser" items="${suggestedUsers}">
                                <div class="user-item">
                                    <img src="${pageContext.request.contextPath}/resources/img/${not empty suggestedUser.avatar ? suggestedUser.avatar : 'avatar-placeholder.png'}" 
                                         class="user-item-avatar" alt="User"
                                         onerror="this.src='${pageContext.request.contextPath}/resources/img/avatar-placeholder.png';">
                                    <div class="flex-grow-1">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <p class="user-item-name mb-0">${suggestedUser.fullName}</p>
                                                <small class="user-item-username">@${suggestedUser.username}</small>
                                            </div>
                                            <button class="btn btn-sm btn-outline-primary" 
                                                    onclick="followUser(${suggestedUser.id}, this)">
                                                Theo dõi
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted text-center">Không có gợi ý nào</p>
                        </c:otherwise>
                    </c:choose>
                    
                    <div class="text-center mt-3">
                        <a href="${pageContext.request.contextPath}/user/search" class="text-decoration-none">Xem thêm</a>
                    </div>
                </div>
            </div>

            <!-- Middle Content - Posts -->
            <div class="col-md-6">
                <!-- New Post Box -->
                <div class="new-post-card bg-white">
                    <div class="new-post-header">
                        <h6 class="mb-0">Tạo bài đăng mới</h6>
                    </div>
                    <form action="${pageContext.request.contextPath}/post/create" method="post" enctype="multipart/form-data">
                        <div class="new-post-body">
                            <input type="text" name="title" class="form-control mb-2" placeholder="Tiêu đề bài đăng..." required>
                            <textarea name="content" class="form-control border-0" rows="3" placeholder="Bạn đang nghĩ gì?" required></textarea>
                            <div id="previewImage" class="mt-2 d-none position-relative">
                                <img src="" alt="Preview" class="img-fluid rounded">
                                <button type="button" class="btn-close position-absolute top-0 end-0 m-2" onclick="removeImage()"></button>
                            </div>
                        </div>
                        <div class="new-post-footer">
                            <div>
                                <button type="button" class="btn btn-sm btn-light me-2" onclick="document.getElementById('imageUpload').click()">
                                    <i class="fas fa-image me-1"></i> Ảnh/File
                                </button>
                                <input type="file" name="file" id="imageUpload" accept="image/*,application/pdf,application/msword,application/vnd.openxmlformats-officedocument.wordprocessingml.document" style="display: none" onchange="previewFile(this)">
                            </div>
                            <button type="submit" class="btn btn-success">Đăng</button>
                        </div>
                    </form>
                </div>

                <!-- Posts Feed -->
                <c:choose>
                    <c:when test="${not empty posts}">
                        <c:forEach var="post" items="${posts}">
                            <div class="post-card bg-white">
                                <div class="post-header">
                                    <img src="${pageContext.request.contextPath}/resources/img/${not empty post.user.avatar ? post.user.avatar : 'avatar-placeholder.png'}" 
                                         class="post-avatar" alt="User"
                                         onerror="this.src='${pageContext.request.contextPath}/resources/img/avatar-placeholder.png';">
                                    <div>
                                        <p class="post-user">${post.user.fullName}</p>
                                        <small class="post-time">${post.formattedCreatedAt}</small>
                                    </div>
                                </div>
                                <div class="post-content">
                                    <c:if test="${not empty post.title}">
                                        <h6 class="mb-2">${post.title}</h6>
                                    </c:if>
                                    <p>${post.content}</p>
                                    <c:if test="${post.hasFile() and post.isImage()}">
                                        <img src="${pageContext.request.contextPath}/uploads/${post.filePath}" 
                                             class="post-image mb-3" alt="Post image">
                                    </c:if>
                                    <c:if test="${post.hasFile() and not post.isImage()}">
                                        <div class="alert alert-info">
                                            <i class="fas fa-file me-2"></i>
                                            <a href="${pageContext.request.contextPath}/uploads/${post.filePath}" 
                                               target="_blank" class="text-decoration-none">
                                                Tải xuống file đính kèm
                                            </a>
                                        </div>
                                    </c:if>
                                </div>
                                <div class="post-actions">
                                    <div class="post-action ${post.likedByCurrentUser ? 'liked' : ''}" 
                                         onclick="toggleLike(${post.id}, this)">
                                        <i class="fa${post.likedByCurrentUser ? 's' : 'r'} fa-thumbs-up me-1"></i> 
                                        Thích (<span class="like-count">${post.likeCount}</span>)
                                    </div>
                                    <div class="post-action" onclick="toggleComments(${post.id})">
                                        <i class="far fa-comment me-1"></i> 
                                        Bình luận (${post.commentCount})
                                    </div>
                                    <div class="post-action">
                                        <i class="far fa-share-square me-1"></i> Chia sẻ
                                    </div>
                                </div>
                                <div class="post-comments" id="comments-${post.id}" style="display: none;">
                                    <div class="mb-3">
                                        <form onsubmit="addComment(event, ${post.id})">
                                            <div class="input-group">
                                                <input type="text" class="form-control" placeholder="Viết bình luận..." required>
                                                <button class="btn btn-outline-success" type="submit">Gửi</button>
                                            </div>
                                        </form>
                                    </div>
                                    <div class="comments-list" id="comments-list-${post.id}">
                                        <!-- Comments will be loaded here -->
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="no-posts bg-white rounded">
                            <i class="fas fa-newspaper fa-3x mb-3"></i>
                            <h5>Chưa có bài đăng nào</h5>
                            <p>Hãy theo dõi một số người bạn để xem bài đăng của họ, hoặc tạo bài đăng đầu tiên của bạn!</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Right Sidebar - Utilities -->
            <div class="col-md-3">
                <div class="sidebar bg-white p-3 rounded shadow-sm">
                    <h5 class="sidebar-title">Tiện ích học tập</h5>
                    
                    <!-- Notes Utility -->
                    <div class="utility-card">
                        <div class="utility-card-header">
                            <i class="fas fa-sticky-note me-2"></i> Ghi chú
                        </div>
                        <div class="utility-card-body">
                            <p class="mb-2">Tạo ghi chú cho các môn học của bạn.</p>
                            <a href="${pageContext.request.contextPath}/notes" class="btn btn-sm btn-outline-success w-100">
                                <i class="fas fa-plus me-1"></i> Tạo ghi chú mới
                            </a>
                        </div>
                    </div>

                    <!-- Schedule Utility -->
                    <div class="utility-card">
                        <div class="utility-card-header">
                            <i class="fas fa-calendar-alt me-2"></i> Lịch học
                        </div>
                        <div class="utility-card-body">
                            <p class="mb-2">Quản lý lịch học và thời gian biểu.</p>
                            <a href="${pageContext.request.contextPath}/schedule" class="btn btn-sm btn-outline-success w-100">
                                <i class="fas fa-plus me-1"></i> Tạo lịch học mới
                            </a>
                        </div>
                    </div>

                    <!-- Study Materials Utility -->
                    <div class="utility-card">
                        <div class="utility-card-header">
                            <i class="fas fa-book me-2"></i> Tài liệu học tập
                        </div>
                        <div class="utility-card-body">
                            <p class="mb-2">Lưu trữ và chia sẻ tài liệu học tập.</p>
                            <a href="${pageContext.request.contextPath}/materials" class="btn btn-sm btn-outline-success w-100">
                                <i class="fas fa-upload me-1"></i> Tải lên tài liệu
                            </a>
                        </div>
                    </div>

                    <!-- Subjects Utility -->
                    <div class="utility-card">
                        <div class="utility-card-header">
                            <i class="fas fa-graduation-cap me-2"></i> Môn học
                        </div>
                        <div class="utility-card-body">
                            <p class="mb-2">Quản lý danh sách môn học của bạn.</p>
                            <a href="${pageContext.request.contextPath}/subjects" class="btn btn-sm btn-outline-success w-100">
                                <i class="fas fa-list me-1"></i> Xem danh sách
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-white py-4 mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5>StudyMate</h5>
                    <p>Nền tảng quản lý học tập hiệu quả.</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <p>&copy; 2025 StudyMate. All rights reserved.</p>
                </div>
            </div>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
   