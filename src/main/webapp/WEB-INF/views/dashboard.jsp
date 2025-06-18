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
    <style>
        .post-actions {
            border-top: 1px solid #e9ecef;
            padding-top: 15px;
            margin-top: 15px;
        }
        .action-btn {
            border: none;
            background: none;
            color: #6c757d;
            padding: 8px 12px;
            border-radius: 20px;
            transition: all 0.3s ease;
            margin-right: 10px;
            cursor: pointer;
        }
        .action-btn:hover {
            background-color: #f8f9fa;
            color: #495057;
        }
        .action-btn.liked {
            color: #dc3545;
            background-color: #ffeaea;
        }
        .action-btn.liked:hover {
            color: #dc3545;
            background-color: #ffe0e0;
        }
        .comments-section {
            border-top: 1px solid #e9ecef;
            margin-top: 15px;
            padding-top: 15px;
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
        }
        .comment-item {
            background: white;
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 10px;
            border-left: 3px solid #007bff;
        }
        .comment-form {
            background: white;
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 15px;
        }
        .flash-message {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1050;
            min-width: 300px;
        }
        .follow-btn {
            transition: all 0.3s ease;
        }
        .follow-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }
        .comment-input {
            width: 100%;
            border: 1px solid #ddd;
            border-radius: 20px;
            padding: 8px 15px;
            outline: none;
            resize: none;
        }
        .comment-input:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
        }
        .loading-btn {
            opacity: 0.6;
            pointer-events: none;
        }
    </style>
</head>
<body>
    <!-- Flash Messages -->
    <c:if test="${not empty message}">
        <div class="flash-message">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="flash-message">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </div>
    </c:if>

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
            <!-- Left Sidebar -->
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
                                <form action="<c:url value='/posts/follow'/>" method="post" style="display: inline;" 
                                      onsubmit="return handleFollowSubmit(this)">
                                    <input type="hidden" name="userId" value="${suggestion.userId}">
                                    <button class="btn ${suggestion.followed ? 'btn-secondary' : 'btn-primary'} btn-sm me-2 follow-btn" 
        								type="submit">
    										<i class="fas ${suggestion.followed ? 'fa-user-minus' : 'fa-plus'}"></i>
   										 <span class="btn-text">${suggestion.followed ? 'Hủy theo dõi' : 'Theo dõi'}</span>
									</button>
                                </form>
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
                        <form action="<c:url value='/posts/create'/>" method="post" enctype="multipart/form-data"
                              onsubmit="return handlePostSubmit(this)">
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
                            <button type="submit" class="btn btn-primary" id="postSubmitBtn">
                                <i class="fas fa-paper-plane"></i>
                                <span class="btn-text">Đăng bài</span>
                            </button>
                        </form>
                    </div>

                    <!-- Posts List -->
                    <c:if test="${not empty posts}">
                        <c:forEach var="post" items="${posts}" varStatus="status">
                            <div class="post-card" id="post-${post.postId}">
                                <div class="d-flex align-items-center mb-3">
    <img src="${post.userAvatar != null ? post.userAvatar : 'resources/assets/images/avatar.png'}" 
         alt="Avatar" class="avatar me-3">
    <div class="flex-grow-1">
        <h6 class="mb-0">
            <a href="<c:url value='/profile/${post.userId}'/>" class="text-decoration-none">
                ${post.userFullName}
            </a>
        </h6>
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
                                <div class="post-actions">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <!-- Like Button -->
                                        <form action="<c:url value='/posts/like'/>" method="post" style="display: inline;"
                                              onsubmit="return handleLikeSubmit(this, ${post.postId})">
                                            <input type="hidden" name="postId" value="${post.postId}">
                                            <button class="action-btn like-btn ${post.likedByCurrentUser ? 'liked' : ''}" 
       											 type="submit" 
       											 id="like-btn-${post.postId}">
    										<i class="fas fa-heart"></i>
    										<span id="like-count-${post.postId}">${post.likeCount}</span>
											</button>
                                        </form>
                                        
                                        <!-- Comment Button -->
                                        <button class="action-btn" onclick="toggleComments(${post.postId})" type="button">
                                            <i class="fas fa-comment"></i>
                                            <span id="comment-count-${post.postId}">
                                                ${post.comments != null ? post.comments.size() : 0}
                                            </span>
                                        </button>
                                        

                                    </div>
                                </div>
                                
                                <!-- Comments Section -->
                                <div id="comments-${post.postId}" class="comments-section" style="display: none;">
                                    <!-- Comment Form -->
                                    <div class="comment-form">
                                        <form action="<c:url value='/posts/comment'/>" method="post" 
                                              onsubmit="return handleCommentSubmit(this, ${post.postId})">
                                            <input type="hidden" name="postId" value="${post.postId}">
                                            <div class="d-flex align-items-center">
                                                <img src="${currentUser.avatarUrl != null ? currentUser.avatarUrl : 'resources/assets/images/avatar.png'}" 
                                                     alt="Avatar" class="avatar me-2" style="width: 32px; height: 32px;">
                                                <input type="text" name="content" class="comment-input me-2" 
                                                       placeholder="Viết bình luận..." required 
                                                       style="flex: 1;">
                                                <button class="btn btn-primary btn-sm comment-submit-btn" type="submit">
                                                    <i class="fas fa-paper-plane"></i>
                                                </button>
                                            </div>
                                        </form>
                                    </div>
                                    
                                    <!-- Comments List -->
                                    <div id="comments-list-${post.postId}">
                                        <c:if test="${not empty post.comments}">
                                            <c:forEach var="comment" items="${post.comments}">
                                                <div class="comment-item" id="comment-${comment.commentId}">
                                                    <div class="d-flex justify-content-between align-items-start">
                                                        <div class="flex-grow-1">
                                                            <div class="d-flex align-items-center mb-1">
    													<img src="${comment.user.avatarUrl != null ? comment.user.avatarUrl : 'resources/assets/images/avatar.png'}" 
         												alt="Avatar" class="avatar me-2" style="width: 24px; height: 24px;">
   														 <strong>User ${comment.userId}</strong>
    													<small class="text-muted ms-2">
        															<fmt:formatDate value="${comment.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
    														</small>
														</div>
                                                            <div class="ms-4">${comment.content}</div>
                                                        </div>
                                                        <c:if test="${comment.userId == currentUser.userId}">
                                                            <form action="<c:url value='/posts/comment/delete'/>" method="post" 
                                                                  style="display: inline;" onsubmit="return handleDeleteComment(this, ${comment.commentId})">
                                                                <input type="hidden" name="commentId" value="${comment.commentId}">
                                                                <input type="hidden" name="postId" value="${post.postId}">
                                                                <button class="btn btn-sm btn-outline-danger" type="submit">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:if>
                                    </div>
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

            <!-- Right Sidebar -->
            <div class="col-md-3">
                <div class="right-sidebar">
                    <h5 class="mb-3">
                        <i class="fas fa-tools"></i> Tính năng
                    </h5>
                    
                    <div class="feature-card" onclick="window.location.href='<c:url value='/schedule'/>'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-calendar-alt text-primary fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Tạo lịch học</h6>
                                <small class="text-muted">Lên kế hoạch học tập</small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="feature-card" onclick="window.location.href='<c:url value='/notes'/>'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-sticky-note text-warning fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Xem ghi chú</h6>
                                <small class="text-muted">Quản lý ghi chú cá nhân</small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="feature-card" onclick="window.location.href='<c:url value='/tasks'/>'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-tasks text-success fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Xem task</h6>
                                <small class="text-muted">Theo dõi công việc</small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="feature-card" onclick="window.location.href='<c:url value='/documents'/>'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-book text-info fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Thư viện tài liệu</h6>
                                <small class="text-muted">Tài liệu học tập</small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="feature-card" onclick="window.location.href='<c:url value='/rooms'/>'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-users text-purple fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Nhóm học tập</h6>
                                <small class="text-muted">Tham gia nhóm học</small>
                            </div>
                        </div>
                    </div>
                    
                    <div class="feature-card" onclick="window.location.href='<c:url value='/statistics'/>'">
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
                            <div class="text-center py-5">
                                <div class="mb-4">
                                    <i class="fas fa-search-minus text-muted" style="font-size: 4rem;"></i>
                                </div>
                                <h5 class="text-muted mb-3">Không tìm thấy kết quả</h5>
                                <p class="text-muted mb-4">
                                    Không có kết quả nào cho từ khóa "<strong>${searchKeyword}</strong>"
                                </p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="result" items="${searchResults}">
                                <div class="d-flex align-items-center mb-3 p-3 border rounded-3">
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
                
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeSearchModal()">
                        <i class="fas fa-times me-1"></i>Đóng
                    </button>
                </div>
            </div>
        </div>
    </div>
    </c:if>

    <!-- Loading Overlay -->
    <div id="loadingOverlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; 
         background: rgba(0,0,0,0.5); z-index: 9999; align-items: center; justify-content: center;">
        <div class="spinner-border text-primary" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
    </div>

    <script src="<c:url value='/assets/js/bootstrap.bundle.min.js'/>"></script>
    
    <script>

 // Toggle user dropdown
 function toggleDropdown() {
     const dropdown = document.getElementById('userDropdown');
     dropdown.style.display = dropdown.style.display === 'block' ? 'none' : 'block';
 }

 // Close dropdown when clicking outside
 document.addEventListener('click', function(event) {
     const dropdown = document.getElementById('userDropdown');
     const userDropdown = document.querySelector('.user-dropdown');
     
     if (!userDropdown.contains(event.target)) {
         dropdown.style.display = 'none';
     }
 });

 // Toggle comments section
 function toggleComments(postId) {
     const commentsSection = document.getElementById('comments-' + postId);
     const commentBtn = document.querySelector(`button[onclick="toggleComments(${postId})"]`);
     
     if (commentsSection.style.display === 'none' || commentsSection.style.display === '') {
         commentsSection.style.display = 'block';
         commentBtn.classList.add('active');
         
         // Focus on comment input
         const commentInput = commentsSection.querySelector('input[name="content"]');
         if (commentInput) {
             setTimeout(() => commentInput.focus(), 100);
         }
     } else {
         commentsSection.style.display = 'none';
         commentBtn.classList.remove('active');
     }
 }

 // Handle post form submission
 function handlePostSubmit(form) {
     const submitBtn = form.querySelector('#postSubmitBtn');
     const btnText = submitBtn.querySelector('.btn-text');
     const originalText = btnText.textContent;
     
     // Disable button and show loading
     submitBtn.disabled = true;
     submitBtn.classList.add('loading-btn');
     btnText.textContent = 'Đang đăng...';
     
     // Validate form
     const title = form.querySelector('input[name="title"]').value.trim();
     const body = form.querySelector('textarea[name="body"]').value.trim();
     
     if (!title || !body) {
         // Re-enable button
         submitBtn.disabled = false;
         submitBtn.classList.remove('loading-btn');
         btnText.textContent = originalText;
         
         alert('Vui lòng điền đầy đủ tiêu đề và nội dung!');
         return false;
     }
     
     // Show loading overlay
     showLoading();
     
     return true;
 }

 // Handle comment form submission
 function handleCommentSubmit(form, postId) {
     const submitBtn = form.querySelector('.comment-submit-btn');
     const contentInput = form.querySelector('input[name="content"]');
     const content = contentInput.value.trim();
     
     // Validate content
     if (!content) {
         alert('Vui lòng nhập nội dung bình luận!');
         contentInput.focus();
         return false;
     }
     
     if (content.length > 500) {
         alert('Bình luận không được quá 500 ký tự!');
         contentInput.focus();
         return false;
     }
     
     // Disable button and show loading
     submitBtn.disabled = true;
     submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
     
     // Add hidden redirect parameter to maintain current page
     const redirectInput = document.createElement('input');
     redirectInput.type = 'hidden';
     redirectInput.name = 'redirect';
     redirectInput.value = 'dashboard';
     form.appendChild(redirectInput);
     
     return true;
 }

 // Handle like button submission
 function handleLikeSubmit(form, postId) {
     const likeBtn = form.querySelector('.like-btn');
     const likeCount = document.getElementById('like-count-' + postId);
     
     // Disable button temporarily
     likeBtn.disabled = true;
     
     // Add hidden redirect parameter
     const redirectInput = document.createElement('input');
     redirectInput.type = 'hidden';
     redirectInput.name = 'redirect';
     redirectInput.value = 'dashboard';
     form.appendChild(redirectInput);
     
     // Optimistic UI update
     const isLiked = likeBtn.classList.contains('liked');
     const currentCount = parseInt(likeCount.textContent) || 0;
     
     if (isLiked) {
         likeBtn.classList.remove('liked');
         likeCount.textContent = Math.max(0, currentCount - 1);
     } else {
         likeBtn.classList.add('liked');
         likeCount.textContent = currentCount + 1;
     }
     
     // Re-enable after short delay
     setTimeout(() => {
         likeBtn.disabled = false;
     }, 1000);
     
     return true;
 }

 // Handle share button submission
 function handleShareSubmit(form, postId) {
     const shareBtn = form.querySelector('.share-btn');
     const shareCount = document.getElementById('share-count-' + postId);
     
     // Confirm share action
     if (!confirm('Bạn có chắc chắn muốn chia sẻ bài viết này không?')) {
         return false;
     }
     
     // Disable button and show loading
     shareBtn.disabled = true;
     shareBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang chia sẻ...';
     
     // Add hidden redirect parameter
     const redirectInput = document.createElement('input');
     redirectInput.type = 'hidden';
     redirectInput.name = 'redirect';
     redirectInput.value = 'dashboard';
     form.appendChild(redirectInput);
     
     // Show loading overlay
     showLoading();
     
     return true;
 }

 // Handle follow button submission
 function handleFollowSubmit(form) {
     const followBtn = form.querySelector('.follow-btn');
     const btnText = followBtn.querySelector('.btn-text');
     const icon = followBtn.querySelector('i');
     const originalText = btnText.textContent;
     const originalIcon = icon.className;
     
     // Disable button and show loading
     followBtn.disabled = true;
     btnText.textContent = 'Đang xử lý...';
     icon.className = 'fas fa-spinner fa-spin';
     
     // Add hidden redirect parameter
     const redirectInput = document.createElement('input');
     redirectInput.type = 'hidden';
     redirectInput.name = 'redirect';
     redirectInput.value = 'dashboard';
     form.appendChild(redirectInput);
     
     return true;
 }

 // Handle delete comment
 function handleDeleteComment(form, commentId) {
     if (!confirm('Bạn có chắc chắn muốn xóa bình luận này không?')) {
         return false;
     }
     
     const deleteBtn = form.querySelector('button[type="submit"]');
     deleteBtn.disabled = true;
     deleteBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
     
     // Add hidden redirect parameter
     const redirectInput = document.createElement('input');
     redirectInput.type = 'hidden';
     redirectInput.name = 'redirect';
     redirectInput.value = 'dashboard';
     form.appendChild(redirectInput);
     
     return true;
 }

 // Show loading overlay
 function showLoading() {
     const overlay = document.getElementById('loadingOverlay');
     if (overlay) {
         overlay.style.display = 'flex';
     }
 }

 // Hide loading overlay
 function hideLoading() {
     const overlay = document.getElementById('loadingOverlay');
     if (overlay) {
         overlay.style.display = 'none';
     }
 }

 // Close search modal
 function closeSearchModal() {
     const modal = document.querySelector('.modal.show');
     if (modal) {
         modal.style.display = 'none';
     }
 }

 // Auto-hide flash messages
 document.addEventListener('DOMContentLoaded', function() {
     const flashMessages = document.querySelectorAll('.flash-message .alert');
     flashMessages.forEach(function(message) {
         setTimeout(function() {
             message.classList.remove('show');
             setTimeout(function() {
                 message.remove();
             }, 150);
         }, 5000);
     });
     
     // Hide loading overlay when page loads
     hideLoading();
     
     // Auto-open comments if specified
     const openCommentsPostId = '${openComments}';
     if (openCommentsPostId && openCommentsPostId !== '' && openCommentsPostId !== '${openComments}') {
         setTimeout(function() {
             toggleComments(parseInt(openCommentsPostId));
         }, 500);
     }
     
     // Handle Enter key in comment inputs
     const commentInputs = document.querySelectorAll('.comment-input');
     commentInputs.forEach(function(input) {
         input.addEventListener('keypress', function(e) {
             if (e.key === 'Enter' && !e.shiftKey) {
                 e.preventDefault();
                 const form = input.closest('form');
                 const postId = form.querySelector('input[name="postId"]').value;
                 if (handleCommentSubmit(form, postId)) {
                     form.submit();
                 }
             }
         });
     });
     
     // Improve textarea auto-resize for comment inputs
     commentInputs.forEach(function(input) {
         input.addEventListener('input', function() {
             this.style.height = 'auto';
             this.style.height = this.scrollHeight + 'px';
         });
     });
 });

 // Handle window beforeunload to hide loading
 window.addEventListener('beforeunload', function() {
     showLoading();
 });

 // Handle page load complete
 window.addEventListener('load', function() {
     hideLoading();
 });

 // Utility function to scroll to element
 function scrollToElement(elementId) {
     const element = document.getElementById(elementId);
     if (element) {
         element.scrollIntoView({ 
             behavior: 'smooth',
             block: 'center'
         });
     }
 }

 // Handle scroll to post after page load (for anchors)
 document.addEventListener('DOMContentLoaded', function() {
     if (window.location.hash) {
         const targetId = window.location.hash.substring(1);
         setTimeout(function() {
             scrollToElement(targetId);
         }, 1000);
     }
 });

 // Feature card click handlers with loading
 document.addEventListener('DOMContentLoaded', function() {
     const featureCards = document.querySelectorAll('.feature-card');
     featureCards.forEach(function(card) {
         card.addEventListener('click', function() {
             showLoading();
         });
     });
 });

 // Handle AJAX-like behavior for better UX (optional enhancement)
 function submitFormAjax(form, successCallback) {
     const formData = new FormData(form);
     const url = form.action;
     
     fetch(url, {
         method: 'POST',
         body: formData,
         headers: {
             'X-Requested-With': 'XMLHttpRequest'
         }
     })
     .then(response => {
         if (response.ok) {
             return response.text();
         }
         throw new Error('Network response was not ok');
     })
     .then(data => {
         if (successCallback) {
             successCallback(data);
         } else {
             // Default behavior - reload page
             window.location.reload();
         }
     })
     .catch(error => {
         console.error('Error:', error);
         alert('Có lỗi xảy ra. Vui lòng thử lại!');
     })
     .finally(() => {
         hideLoading();
     });
 }

 // Enhanced comment submission with real-time update
 function submitCommentAjax(form, postId) {
     const contentInput = form.querySelector('input[name="content"]');
     const content = contentInput.value.trim();
     
     if (!content) {
         alert('Vui lòng nhập nội dung bình luận!');
         return;
     }
     
     const submitBtn = form.querySelector('.comment-submit-btn');
     submitBtn.disabled = true;
     submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
     
     submitFormAjax(form, function(response) {
         // Clear input
         contentInput.value = '';
         
         // Re-enable button
         submitBtn.disabled = false;
         submitBtn.innerHTML = '<i class="fas fa-paper-plane"></i>';
         
         // Update comment count
         const commentCountEl = document.getElementById('comment-count-' + postId);
         if (commentCountEl) {
             const currentCount = parseInt(commentCountEl.textContent) || 0;
             commentCountEl.textContent = currentCount + 1;
         }
         
         // Show success message
         showTempMessage('Thêm bình luận thành công!', 'success');
         
         // Reload to show new comment (or implement dynamic insertion)
         setTimeout(() => window.location.reload(), 1000);
     });
 }
        </script>
</body>
</html>