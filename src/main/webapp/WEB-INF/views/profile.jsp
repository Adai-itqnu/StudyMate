<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${isOwnProfile}">Thông tin cá nhân - StudyMate</c:when>
            <c:otherwise>Trang cá nhân của ${profileUser.fullName} - StudyMate</c:otherwise>
        </c:choose>
    </title>
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
        .follow-stats {
            display: flex;
            gap: 2rem;
            margin-top: 1rem;
        }
        .stat-item {
            text-align: center;
        }
        .stat-number {
            font-size: 1.5rem;
            font-weight: bold;
            display: block;
        }
        .stat-label {
            font-size: 0.9rem;
            opacity: 0.8;
        }
        .post-card {
            border: none;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 10px;
            margin-bottom: 1.5rem;
        }
        .post-actions button {
            border: none;
            background: none;
            color: #6c757d;
            padding: 0.5rem 1rem;
            border-radius: 5px;
            transition: all 0.3s;
        }
        .post-actions button:hover {
            background-color: #f8f9fa;
            color: #495057;
        }
        .post-actions button.liked {
            color: #dc3545;
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
                            <c:when test="${not empty profileUser.avatarUrl}">
                                <img src="${profileUser.avatarUrl}" class="rounded-circle" width="150" height="150" alt="Avatar"/>
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
                    <h2 class="mb-2">${profileUser.fullName}</h2>
                    <p class="mb-2">
                        <i class="fas fa-at"></i> ${profileUser.username}
                    </p>
                    <c:if test="${not empty profileUser.bio}">
                        <p class="mb-3">
                            <i class="fas fa-quote-left"></i> ${profileUser.bio}
                        </p>
                    </c:if>
                    
                    <!-- Follow Statistics -->
                    <div class="follow-stats">
                        <div class="stat-item">
                            <span class="stat-number">${followers.size()}</span>
                            <span class="stat-label">Người theo dõi</span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number">${followees.size()}</span>
                            <span class="stat-label">Đang theo dõi</span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number">${userPosts.size()}</span>
                            <span class="stat-label">Bài viết</span>
                        </div>
                    </div>

                    <div class="d-flex gap-3 mt-3">
                        <c:choose>
                            <c:when test="${isOwnProfile}">
                                <a href="<c:url value='/profile/settings'/>" class="btn btn-light">
                                    <i class="fas fa-edit"></i> Chỉnh sửa thông tin
                                </a>
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${isFollowing}">
                                        <button class="btn btn-outline-light" onclick="unfollowUser(${profileUser.userId})">
                                            <i class="fas fa-user-minus"></i> Bỏ theo dõi
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="btn btn-light" onclick="followUser(${profileUser.userId})">
                                            <i class="fas fa-user-plus"></i> Theo dõi
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
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
                            <div class="info-value">${profileUser.fullName}</div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Tên đăng nhập</div>
                            <div class="info-value">@${profileUser.username}</div>
                        </div>
                        
                        <!-- Chỉ hiển thị thông tin nhạy cảm nếu là profile của chính mình -->
                        <c:if test="${isOwnProfile}">
                            <div class="info-item">
                                <div class="info-label">Email</div>
                                <div class="info-value">
                                    <i class="fas fa-envelope text-muted"></i> ${profileUser.email}
                                </div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Số điện thoại</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty profileUser.phone}">
                                            <i class="fas fa-phone text-muted"></i> ${profileUser.phone}
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
                                        <c:when test="${not empty profileUser.dateOfBirth}">
                                            <i class="fas fa-calendar text-muted"></i> 
                                            <fmt:formatDate value="${profileUser.dateOfBirth}" pattern="dd/MM/yyyy"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="empty-value">Chưa cập nhật</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:if>
                        
                        <div class="info-item">
                            <div class="info-label">Giới thiệu bản thân</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${not empty profileUser.bio}">
                                        ${profileUser.bio}
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
                                    <c:when test="${profileUser.role == 'ADMIN'}">
                                        <span class="badge bg-danger">
                                            <i class="fas fa-crown"></i> Quản trị viên
                                        </span>
                                    </c:when>
                                    <c:when test="${profileUser.role == 'TEACHER'}">
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
                                    <c:when test="${profileUser.status == 'ACTIVE'}">
                                        <span class="badge bg-success">
                                            <i class="fas fa-check-circle"></i> Hoạt động
                                        </span>
                                    </c:when>
                                    <c:when test="${profileUser.status == 'INACTIVE'}">
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
                                <fmt:formatDate value="${profileUser.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                            </div>
                        </div>
                        
                        <!-- Chỉ hiển thị thông tin cập nhật nếu là profile của chính mình -->
                        <c:if test="${isOwnProfile}">
                            <div class="info-item">
                                <div class="info-label">Cập nhật lần cuối</div>
                                <div class="info-value">
                                    <c:choose>
                                        <c:when test="${not empty profileUser.updatedAt}">
                                            <i class="fas fa-edit text-muted"></i>
                                            <fmt:formatDate value="${profileUser.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="empty-value">Chưa có cập nhật</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:if>
                        
                        <div class="info-item">
                            <div class="info-label">Trường học</div>
                            <div class="info-value">
                                <c:choose>
                                    <c:when test="${profileUser.schoolId > 0}">
                                        <i class="fas fa-school text-muted"></i> ID: ${profileUser.schoolId}
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

        <!-- User Posts -->
        <div class="row">
            <div class="col-12">
                <div class="card info-card">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-newspaper"></i> 
                            <c:choose>
                                <c:when test="${isOwnProfile}">Bài viết của tôi</c:when>
                                <c:otherwise>Bài viết của ${profileUser.fullName}</c:otherwise>
                            </c:choose>
                            (${userPosts.size()})
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${empty userPosts}">
                                <div class="text-center py-5">
                                    <i class="fas fa-file-alt fa-3x text-muted mb-3"></i>
                                    <p class="text-muted">
                                        <c:choose>
                                            <c:when test="${isOwnProfile}">Bạn chưa có bài viết nào</c:when>
                                            <c:otherwise>Người dùng này chưa có bài viết nào</c:otherwise>
                                        </c:choose>
                                    </p>
                                    <c:if test="${isOwnProfile}">
                                        <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary">
                                            <i class="fas fa-plus"></i> Tạo bài viết đầu tiên
                                        </a>
                                    </c:if>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="post" items="${userPosts}">
                                    <div class="post-card card mb-3">
                                        <div class="card-header d-flex justify-content-between align-items-center">
                                            <div class="d-flex align-items-center">
                                                <c:choose>
                                                    <c:when test="${not empty profileUser.avatarUrl}">
                                                        <img src="${profileUser.avatarUrl}" class="rounded-circle me-2" width="40" height="40" alt="Avatar"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 40px; height: 40px;">
                                                            <i class="fas fa-user"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <div>
                                                    <strong>${profileUser.fullName}</strong>
                                                    <br>
                                                    <small class="text-muted">
                                                        <fmt:formatDate value="${post.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </small>
                                                </div>
                                            </div>
                                            <c:if test="${isOwnProfile}">
                                                <div class="dropdown">
                                                    <button class="btn btn-sm btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                                        <i class="fas fa-ellipsis-h"></i>
                                                    </button>
                                                    <ul class="dropdown-menu">
                                                        <li><a class="dropdown-item" href="#"><i class="fas fa-edit"></i> Chỉnh sửa</a></li>
                                                        <li><a class="dropdown-item text-danger" href="#" onclick="deletePost(${post.postId})"><i class="fas fa-trash"></i> Xóa</a></li>
                                                    </ul>
                                                </div>
                                            </c:if>
                                        </div>
                                        <div class="card-body">
                                            <h6 class="card-title">${post.title}</h6>
                                            <p class="card-text">${post.body}</p>
                                            
                                            <!-- Attachments -->
                                            <c:if test="${not empty post.attachments}">
                                                <div class="mb-3">
                                                    <c:forEach var="attachment" items="${post.attachments}">
                                                        <c:if test="${attachment.fileType == 'IMAGE'}">
                                                            <img src="${attachment.fileUrl}" class="img-fluid rounded mb-2" style="max-height: 400px;" alt="Post Image"/>
                                                        </c:if>
                                                    </c:forEach>
                                                </div>
                                            </c:if>
                                        </div>
                                        <div class="card-footer">
                                            <div class="post-actions d-flex justify-content-between align-items-center">
                                                <div class="d-flex gap-3">
                                                    <button class="btn-like" onclick="toggleLike(${post.postId})">
                                                        <i class="fas fa-heart"></i> ${post.likeCount}
                                                    </button>
                                                    <button onclick="toggleComments(${post.postId})">
                                                        <i class="fas fa-comment"></i> ${post.comments.size()}
                                                    </button>
                                                    <button onclick="sharePost(${post.postId})">
                                                        <i class="fas fa-share"></i> ${post.shares.size()}
                                                    </button>
                                                </div>
                                                <small class="text-muted">
                                                    <i class="fas fa-eye"></i> ${post.privacy}
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quick Actions (chỉ hiển thị cho profile của chính mình) -->
        <c:if test="${isOwnProfile}">
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
                                <div class="col-md-3 col-sm-6 mb-3">
                                    <a href="<c:url value='/dashboard'/>" class="btn btn-outline-info w-100">
                                        <i class="fas fa-home"></i><br>
                                        <small>Về trang chủ</small>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:if>
    </div>

    <script src="<c:url value='/assets/js/bootstrap.bundle.min.js'/>"></script>
    <script>
        function followUser(userId) {
            fetch(`/studymate/profile/follow/${userId}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    location.reload();
                } else {
                    alert('Có lỗi xảy ra khi theo dõi!');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra!');
            });
        }

        function unfollowUser(userId) {
            fetch(`/studymate/profile/unfollow/${userId}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                }
            })
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    location.reload();
                } else {
                    alert('Có lỗi xảy ra khi bỏ theo dõi!');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Có lỗi xảy ra!');
            });
        }

        function toggleLike(postId) {
            // Logic để like/unlike bài viết
            fetch(`/studymate/profile/like/${postId}`, {
                method: 'POST'
            })
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    location.reload();
                }
            });
        }

        function sharePost(postId) {
            fetch(`/studymate/profile/share/${postId}`, {
                method: 'POST'
            })
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    alert('Đã chia sẻ bài viết!');
                    location.reload();
                }
            });
        }

        function deletePost(postId) {
            if (confirm('Bạn có chắc chắn muốn xóa bài viết này?')) {
                fetch(`/studymate/post/delete/${postId}`, {
                    method: 'POST'
                })
                .then(response => response.text())
                .then(data => {
                    if (data === 'success') {
                        location.reload();
                    } else {
                        alert('Có lỗi xảy ra khi xóa bài viết!');
                    }
                });
            }
        }
    </script>
</body>
</html>