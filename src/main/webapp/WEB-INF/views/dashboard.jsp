	<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
	<!DOCTYPE html>
	<html lang="vi">
	<head>
	    <meta charset="UTF-8">
	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	    <title>StudyMate - Trang chủ</title>
	    <link href="<c:url value='/assets/css/bootstrap.min.css'/>" rel="stylesheet">
	    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
	   <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/dashboard.css"/>
	</head>
	<body>
	    <!-- Header -->
	    <div class="header">
	        <div class="container-fluid">
	            <div class="row align-items-center py-3">
	                <!-- Logo/Trang chủ -->
	                <div class="col-md-3">
	                    <a href="<c:url value='/dashboard'/>" class="text-decoration-none">
	                        <h4 class="mb-0 text-primary">
	                            <i class="fas fa-graduation-cap"></i> StudyMate
	                        </h4>
	                    </a>
	                </div>
	                
	                <!-- Ô tìm kiếm -->
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
	                
	                <!-- User info -->
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
	            <!-- Left Sidebar - Gợi ý người dùng -->
	            <div class="col-md-3">
	                <div class="sidebar">
	                    <h5 class="mb-3">
	                        <i class="fas fa-users"></i> Gợi ý theo dõi
	                    </h5>
	                    
	                    <c:forEach var="suggestion" items="${suggestions}">
	                        <div class="suggestion-card">
	                            <div class="d-flex align-items-center">
	                                <img src="${suggestion.avatarUrl != null ? suggestion.avatarUrl : 'resources/assets/images/avatar.png'}" 
	                                     alt="Avatar" class="avatar me-3">
	                                <div class="flex-grow-1">
	                                    <h6 class="mb-1">${suggestion.fullName}</h6>
	                                    <small class="text-muted">@${suggestion.username}</small>
	                                </div>
	                            </div>
	                            <div class="mt-2">
	                                <button class="btn btn-primary btn-sm me-2" 
	                                        onclick="followUser(${suggestion.userId})">
	                                    <i class="fas fa-plus"></i> Theo dõi
	                                </button>
	                                <a href="<c:url value='/profile/${suggestion.userId}'/>" 
	                                   class="btn btn-outline-secondary btn-sm">
	                                    Xem trang
	                                </a>
	                            </div>
	                        </div>
	                    </c:forEach>
	                </div>
	            </div>
	
	            <!-- Main Content Area -->
	            <div class="col-md-6">
	                <div class="main-content">
	                    <!-- Post Form -->
	                    <div class="post-form">
	                        <h5 class="mb-3">
	                            <i class="fas fa-edit"></i> Chia sẻ bài viết mới
	                        </h5>
	                        <form action="<c:url value='/posts/create'/>" method="post" enctype="multipart/form-data">
	                            <div class="mb-3">
	                                <input type="text" name="title" class="form-control" 
	                                       placeholder="Tiêu đề bài viết..." required>
	                            </div>
	                            <div class="mb-3">
	                                <textarea name="body" class="form-control" rows="4" 
	                                          placeholder="Bạn đang nghĩ gì?" required></textarea>
	                            </div>
	                            <div class="row">
	                                <div class="col-md-6 mb-3">
	                                    <select name="privacy" class="form-select">
	                                        <option value="PUBLIC">Công khai</option>
	                                        <option value="FOLLOWERS">Chỉ người theo dõi</option>
	                                        <option value="PRIVATE">Chỉ riêng tôi</option>
	                                    </select>
	                                </div>
	                                <div class="col-md-6 mb-3">
	                                    <input type="file" name="attachment" class="form-control" 
	                                           accept=".jpg,.jpeg,.png">
	                                </div>
	                            </div>
	                            <button type="submit" class="btn btn-primary">
	                                <i class="fas fa-paper-plane"></i> Đăng bài
	                            </button>
	                        </form>
	                    </div>
	
	                    <!-- Posts List -->
	                    <c:if test="${not empty posts}">
	                        <c:forEach var="post" items="${posts}">
	                            <div class="post-card">
	                                <div class="d-flex align-items-center mb-3">
	                                    <img src="resources/assets/images/avatar.png" alt="Avatar" class="avatar me-3">
	                                    <div>
	                                        <h6 class="mb-0">User ${post.userId}</h6>
	                                        <small class="text-muted">
	                                            <fmt:formatDate value="${post.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
	                                        </small>
	                                    </div>
	                                    <div class="ms-auto">
	                                        <span class="badge bg-secondary">${post.privacy}</span>
	                                    </div>
	                                </div>
	                                
	                                <h5 class="mb-2">${post.title}</h5>
	                                <p class="mb-3">${post.body}</p>
	                                
	                                <!-- Attachments -->
	                                <c:if test="${not empty post.attachments}">
	                                    <div class="mb-3">
	                                        <c:forEach var="attachment" items="${post.attachments}">
	                                            <img src="${attachment.fileUrl}" 
	                                                 alt="Attachment" 
	                                                 class="img-fluid rounded" 
	                                                 style="max-width: 100%; max-height: 350px;">
	                                        </c:forEach>
	                                    </div>
	                                </c:if>
	                                
	                                <!-- Post Actions -->
	                                <div class="d-flex justify-content-between border-top pt-3">
	                                    <button class="btn btn-outline-primary btn-sm" 
	                                            onclick="likePost(${post.postId})">
	                                        <i class="fas fa-heart"></i> Like
	                                        <span id="like-count-${post.postId}">${post.likeCount}</span>
	                                    </button>
	                                    <button class="btn btn-outline-secondary btn-sm">
	                                        <i class="fas fa-comment"></i> Comment
	                                        <span>${post.comments != null ? post.comments.size() : 0}</span>
	                                    </button>
	                                    <button class="btn btn-outline-success btn-sm" 
	                                            onclick="sharePost(${post.postId})">
	                                        <i class="fas fa-share"></i> Share
	                                        <span>${post.shares != null ? post.shares.size() : 0}</span>
	                                    </button>
	                                </div>
	                            </div>
	                        </c:forEach>
	                    </c:if>
	                    
	                    <c:if test="${empty posts}">
	                        <div class="post-card text-center">
	                            <i class="fas fa-info-circle text-muted fa-3x mb-3"></i>
	                            <h5>Chưa có bài viết nào</h5>
	                            <p class="text-muted">Hãy tạo bài viết đầu tiên của bạn!</p>
	                        </div>
	                    </c:if>
	                </div>
	            </div>
	
	            <!-- Right Sidebar - Features -->
	            <div class="col-md-3">
	                <div class="right-sidebar">
	                    <h5 class="mb-3">
	                        <i class="fas fa-tools"></i> Tính năng
	                    </h5>
	                    
	                    <div class="feature-card" onclick="window.location.href='#'">
	                        <div class="d-flex align-items-center">
	                            <i class="fas fa-calendar-alt text-primary fa-2x me-3"></i>
	                            <div>
	                                <h6 class="mb-1">Tạo lịch học</h6>
	                                <small class="text-muted">Lên kế hoạch học tập</small>
	                            </div>
	                        </div>
	                    </div>
	                    
	                    <div class="feature-card" onclick="window.location.href='#'">
	                        <div class="d-flex align-items-center">
	                            <i class="fas fa-sticky-note text-warning fa-2x me-3"></i>
	                            <div>
	                                <h6 class="mb-1">Xem ghi chú</h6>
	                                <small class="text-muted">Quản lý ghi chú cá nhân</small>
	                            </div>
	                        </div>
	                    </div>
	                    
	                    <div class="feature-card" onclick="window.location.href='#'">
	                        <div class="d-flex align-items-center">
	                            <i class="fas fa-tasks text-success fa-2x me-3"></i>
	                            <div>
	                                <h6 class="mb-1">Xem task</h6>
	                                <small class="text-muted">Theo dõi công việc</small>
	                            </div>
	                        </div>
	                    </div>
	                    
	                    <div class="feature-card" onclick="window.location.href='#'">
	                        <div class="d-flex align-items-center">
	                            <i class="fas fa-book text-info fa-2x me-3"></i>
	                            <div>
	                                <h6 class="mb-1">Thư viện tài liệu</h6>
	                                <small class="text-muted">Tài liệu học tập</small>
	                            </div>
	                        </div>
	                    </div>
	                    
	                    <div class="feature-card" onclick="window.location.href='#'">
	                        <div class="d-flex align-items-center">
	                            <i class="fas fa-users text-purple fa-2x me-3"></i>
	                            <div>
	                                <h6 class="mb-1">Nhóm học tập</h6>
	                                <small class="text-muted">Tham gia nhóm học</small>
	                            </div>
	                        </div>
	                    </div>
	                    
	                    <div class="feature-card" onclick="window.location.href='#'">
	                        <div class="d-flex align-items-center">
	                            <i class="fas fa-chart-line text-danger fa-2x me-3"></i>
	                            <div>
	                                <h6 class="mb-1">Thống kê học tập</h6>
	                                <small class="text-muted">Theo dõi tiến độ</small>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>
	
<!-- Search Results Modal -->
<c:if test="${not empty searchResults}">
<div class="modal fade show" style="display: block; background: rgba(0,0,0,0.5);" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content shadow-lg">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title">
                    <i class="fas fa-search me-2"></i>
                    Kết quả tìm kiếm: "${searchKeyword}"
                </h5>
                <button type="button" class="btn-close btn-close-white" onclick="closeSearchModal()"></button>
            </div>
            
            <div class="modal-body" style="max-height: 400px; overflow-y: auto;">
                <c:choose>
                    <c:when test="${empty searchResults}">
                        <!-- Không tìm thấy kết quả -->
                        <div class="text-center py-5">
                            <div class="mb-4">
                                <i class="fas fa-search-minus text-muted" style="font-size: 4rem;"></i>
                            </div>
                            <h5 class="text-muted mb-3">Không tìm thấy kết quả</h5>
                            <p class="text-muted mb-4">
                                Không có kết quả nào cho từ khóa "<strong>${searchKeyword}</strong>"
                            </p>
                            <div class="alert alert-info" role="alert">
                                <i class="fas fa-lightbulb me-2"></i>
                                <strong>Gợi ý:</strong> Hãy thử tìm kiếm với từ khóa khác hoặc kiểm tra lại chính tả
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <!-- Có kết quả -->
                        <c:forEach var="result" items="${searchResults}">
                            <div class="d-flex align-items-center mb-3 p-3 border rounded-3 hover-card">
                                <img src="${result.avatarUrl != null ? result.avatarUrl : 'resources/assets/images/avatar.png'}"
                                     alt="Avatar" class="avatar me-3">
                                <div class="flex-grow-1">
                                    <h6 class="mb-1 fw-bold">${result.fullName}</h6>
                                    <small class="text-muted">@${result.username}</small>
                                </div>
                                <a href="<c:url value='/profile/${result.userId}'/>"
                                   class="btn btn-outline-primary btn-sm">
                                    <i class="fas fa-user me-1"></i>Xem trang
                                </a>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Modal Footer với các nút thoát -->
            <div class="modal-footer d-flex justify-content-between align-items-center">
                <div>
                    <small class="text-muted">
                        <i class="fas fa-info-circle me-1"></i>
                        <c:choose>
                            <c:when test="${empty searchResults}">
                                Không tìm thấy kết quả nào
                            </c:when>
                            <c:otherwise>
                                Tìm thấy ${searchResults.size()} kết quả
                            </c:otherwise>
                        </c:choose>
                    </small>
                </div>
                <div>
                    <button type="button" class="btn btn-secondary me-2" onclick="closeSearchModal()">
                        <i class="fas fa-times me-1"></i>Đóng
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
</c:if>
	
	    <script src="<c:url value='/assets/js/bootstrap.bundle.min.js'/>"></script>
	    <script>
	    function toggleDropdown() {
	        const dropdown = document.getElementById('userDropdown');
	        dropdown.classList.toggle('show');
	    }

	    // Close dropdown when clicking outside
	    document.addEventListener('click', function(event) {
	        const dropdown = document.getElementById('userDropdown');
	        const userDropdown = document.querySelector('.user-dropdown');

	        if (userDropdown && !userDropdown.contains(event.target)) {
	            dropdown.classList.remove('show');
	        }
	    });

	    function followUser(userId) {
	        fetch(`/profile/follow/${userId}`, {
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
	                alert('Có lỗi xảy ra');
	            }
	        });
	    }

	    function likePost(postId) {
	        fetch(`/profile/like/${postId}`, {
	            method: 'POST',
	            headers: {
	                'Content-Type': 'application/json',
	            }
	        })
	        .then(response => response.text())
	        .then(data => {
	            if (data === 'success') {
	                const likeCount = document.getElementById(`like-count-${postId}`);
	                if (likeCount) {
	                    likeCount.textContent = parseInt(likeCount.textContent) + 1;
	                }
	            } else {
	                alert('Có lỗi xảy ra');
	            }
	        });
	    }

	    function sharePost(postId) {
	        fetch(`/profile/share/${postId}`, {
	            method: 'POST',
	            headers: {
	                'Content-Type': 'application/json',
	            }
	        })
	        .then(response => response.text())
	        .then(data => {
	            if (data === 'success') {
	                alert('Đã chia sẻ bài viết!');
	                location.reload();
	            } else {
	                alert('Có lỗi xảy ra');
	            }
	        });
	    }

	    // Hàm đóng modal (giữ nguyên trang hiện tại)
	    function closeSearchModal() {
	    	window.location.href = '${pageContext.request.contextPath}/dashboard';
	    }


	    // Đóng modal khi nhấn ESC
	    document.addEventListener('keydown', function(event) {
	        if (event.key === 'Escape') {
	            closeSearchModal();
	        }
	    });
	    </script>
	</body>
	</html>