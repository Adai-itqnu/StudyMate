<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa thông tin cá nhân - StudyMate</title>
    <link href="<c:url value='/assets/css/bootstrap.min.css'/>" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet"/>
    <style>
        .settings-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
        }
        .form-card {
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            border: none;
            border-radius: 15px;
            overflow: hidden;
        }
        .form-card .card-header {
            background: linear-gradient(45deg, #007bff, #0056b3);
            color: white;
            border: none;
            padding: 1.5rem;
        }
        .form-group {
            margin-bottom: 1.5rem;
        }
        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.5rem;
        }
        .form-control, .form-select {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
        }
        .form-control:focus, .form-select:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,0.25);
        }
        .btn-custom {
            border-radius: 25px;
            padding: 0.75rem 2rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .alert {
            border-radius: 10px;
            border: none;
        }
        .avatar-preview {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 4px solid #dee2e6;
            object-fit: cover;
        }
        .avatar-placeholder {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 4px solid #dee2e6;
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
        }
        .password-section {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin-top: 2rem;
        }
        .section-divider {
            border: 0;
            height: 2px;
            background: linear-gradient(to right, transparent, #007bff, transparent);
            margin: 2rem 0;
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
                <a class="nav-link" href="<c:url value='/profile'/>">
                    <i class="fas fa-user"></i> Trang cá nhân
                </a>
                <a class="nav-link active" href="<c:url value='/profile/settings'/>">
                    <i class="fas fa-cog"></i> Cài đặt
                </a>
                <a class="nav-link" href="<c:url value='/logout'/>">
                    <i class="fas fa-sign-out-alt"></i> Đăng xuất
                </a>
            </div>
        </div>
    </nav>

    <!-- Settings Header -->
    <div class="settings-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h2 class="mb-2">
                        <i class="fas fa-user-cog"></i> Chỉnh sửa thông tin cá nhân
                    </h2>
                    <p class="mb-0">Cập nhật thông tin của bạn để hoàn thiện hồ sơ</p>
                </div>
                <div class="col-md-4 text-end">
                    <a href="<c:url value='/profile'/>" class="btn btn-outline-light btn-custom">
                        <i class="fas fa-arrow-left"></i> Quay lại trang cá nhân
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container mt-4 pb-5">
        <!-- Success/Error Messages -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty passwordSuccess}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>${passwordSuccess}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty passwordError}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>${passwordError}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Profile Settings Form -->
        <div class="card form-card">
            <div class="card-header">
                <h4 class="mb-0">
                    <i class="fas fa-user-edit"></i> Thông tin cá nhân
                </h4>
            </div>
            <div class="card-body p-4">
                <form action="<c:url value='/profile/settings/update'/>" method="post">
                    <div class="row">
                        <!-- Avatar Section -->
                        <div class="col-md-3 text-center mb-4">
                            <div class="mb-3">
                                <c:choose>
                                    <c:when test="${not empty user.avatarUrl}">
                                        <img src="${user.avatarUrl}" class="avatar-preview" alt="Avatar" id="avatarPreview"/>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="avatar-placeholder" id="avatarPlaceholder">
                                            <i class="fas fa-user fa-3x"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="form-group">
                                <label for="avatarUrl" class="form-label">URL Avatar</label>
                                <input type="url" class="form-control" id="avatarUrl" name="avatarUrl" 
                                       value="${user.avatarUrl}" placeholder="https://example.com/avatar.jpg"
                                       onchange="previewAvatar(this.value)">
                                <small class="text-muted">Nhập URL hình ảnh để làm avatar</small>
                            </div>
                        </div>

                        <!-- Personal Information -->
                        <div class="col-md-9">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="fullName" class="form-label">
                                            <i class="fas fa-user text-primary"></i> Họ và tên *
                                        </label>
                                        <input type="text" class="form-control" id="fullName" name="fullName" 
                                               value="${user.fullName}" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="username" class="form-label">
                                            <i class="fas fa-at text-primary"></i> Tên đăng nhập *
                                        </label>
                                        <input type="text" class="form-control" id="username" name="username" 
                                               value="${user.username}" required>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="email" class="form-label">
                                            <i class="fas fa-envelope text-primary"></i> Email *
                                        </label>
                                        <input type="email" class="form-control" id="email" name="email" 
                                               value="${user.email}" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="phone" class="form-label">
                                            <i class="fas fa-phone text-primary"></i> Số điện thoại
                                        </label>
                                        <input type="tel" class="form-control" id="phone" name="phone" 
                                               value="${user.phone}" placeholder="0123456789">
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="dateOfBirth" class="form-label">
                                            <i class="fas fa-calendar text-primary"></i> Ngày sinh
                                        </label>
                                        <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" 
                                               value="<fmt:formatDate value='${user.dateOfBirth}' pattern='yyyy-MM-dd'/>">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
   			 <label for="schoolId" class="form-label">
        <i class="fas fa-school text-primary"></i> Trường học
    </label>
    <select class="form-select" id="schoolId" name="schoolId">
        <option value="0" ${user.schoolId == 0 ? 'selected' : ''}>Chọn trường học</option>
        
        <!-- Duyệt qua danh sách trường học từ database -->
        <c:forEach var="school" items="${schools}">
            <option value="${school.schoolId}" ${user.schoolId == school.schoolId ? 'selected' : ''}>
                ${school.name}
            </option>
        </c:forEach>
        
        <!-- Option cho trường khác -->
        <option value="-1" ${user.schoolId == -1 ? 'selected' : ''}>Trường khác</option>
    </select>
</div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="bio" class="form-label">
                                    <i class="fas fa-quote-left text-primary"></i> Giới thiệu bản thân
                                </label>
                                <textarea class="form-control" id="bio" name="bio" rows="4" 
                                          placeholder="Viết vài dòng về bản thân bạn...">${user.bio}</textarea>
                                <small class="text-muted">Tối đa 500 ký tự</small>
                            </div>
                        </div>
                    </div>

                    <hr class="section-divider">
                    
                    <div class="text-center">
                        <button type="submit" class="btn btn-primary btn-custom me-3">
                            <i class="fas fa-save"></i> Lưu thay đổi
                        </button>
                        <a href="<c:url value='/profile'/>" class="btn btn-secondary btn-custom">
                            <i class="fas fa-times"></i> Hủy bỏ
                        </a>
                    </div>
                </form>
            </div>
        </div>

        <!-- Password Change Section -->
        <div class="card form-card mt-4">
            <div class="card-header">
                <h4 class="mb-0">
                    <i class="fas fa-lock"></i> Đổi mật khẩu
                </h4>
            </div>
            <div class="card-body p-4">
                <form action="<c:url value='/profile/settings/change-password'/>" method="post">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="oldPassword" class="form-label">
                                    <i class="fas fa-key text-warning"></i> Mật khẩu hiện tại *
                                </label>
                                <input type="password" class="form-control" id="oldPassword" name="oldPassword" required>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="newPassword" class="form-label">
                                    <i class="fas fa-lock text-success"></i> Mật khẩu mới *
                                </label>
                                <input type="password" class="form-control" id="newPassword" name="newPassword" 
                                       minlength="6" required>
                                <small class="text-muted">Ít nhất 6 ký tự</small>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label for="confirmPassword" class="form-label">
                                    <i class="fas fa-check-circle text-info"></i> Xác nhận mật khẩu *
                                </label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                       minlength="6" required>
                            </div>
                        </div>
                    </div>
                    
                    <div class="text-center mt-3">
                        <button type="submit" class="btn btn-warning btn-custom">
                            <i class="fas fa-key"></i> Đổi mật khẩu
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Account Information (Read-only) -->
        <div class="card form-card mt-4">
            <div class="card-header">
                <h4 class="mb-0">
                    <i class="fas fa-info-circle"></i> Thông tin tài khoản
                </h4>
            </div>
            <div class="card-body p-4">
                <div class="row">
                    <div class="col-md-3">
                        <strong>Vai trò:</strong>
                        <c:choose>
                            <c:when test="${user.role == 'ADMIN'}">
                                <span class="badge bg-danger ms-2">
                                    <i class="fas fa-crown"></i> Quản trị viên
                                </span>
                            </c:when>
                            <c:when test="${user.role == 'TEACHER'}">
                                <span class="badge bg-info ms-2">
                                    <i class="fas fa-chalkboard-teacher"></i> Giáo viên
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-primary ms-2">
                                    <i class="fas fa-user-graduate"></i> Học sinh
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col-md-3">
                        <strong>Trạng thái:</strong>
                        <c:choose>
                            <c:when test="${user.status == 'ACTIVE'}">
                                <span class="badge bg-success ms-2">
                                    <i class="fas fa-check-circle"></i> Hoạt động
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-warning ms-2">
                                    <i class="fas fa-pause-circle"></i> Tạm dừng
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col-md-3">
                        <strong>Ngày tham gia:</strong><br>
                        <small class="text-muted">
                            <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy"/>
                        </small>
                    </div>
                    <div class="col-md-3">
                        <strong>Cập nhật cuối:</strong><br>
                        <small class="text-muted">
                            <c:choose>
                                <c:when test="${not empty user.updatedAt}">
                                    <fmt:formatDate value="${user.updatedAt}" pattern="dd/MM/yyyy"/>
                                </c:when>
                                <c:otherwise>Chưa có</c:otherwise>
                            </c:choose>
                        </small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="<c:url value='/assets/js/bootstrap.bundle.min.js'/>"></script>
    <script>
        function previewAvatar(url) {
            const preview = document.getElementById('avatarPreview');
            const placeholder = document.getElementById('avatarPlaceholder');
            
            if (url && url.trim() !== '') {
                if (preview) {
                    preview.src = url;
                } else {
                    // Create new img element if placeholder exists
                    if (placeholder) {
                        const img = document.createElement('img');
                        img.src = url;
                        img.className = 'avatar-preview';
                        img.alt = 'Avatar';
                        img.id = 'avatarPreview';
                        placeholder.parentNode.replaceChild(img, placeholder);
                    }
                }
            } else {
                // Revert to placeholder
                if (preview) {
                    const placeholder = document.createElement('div');
                    placeholder.className = 'avatar-placeholder';
                    placeholder.id = 'avatarPlaceholder';
                    placeholder.innerHTML = '<i class="fas fa-user fa-3x"></i>';
                    preview.parentNode.replaceChild(placeholder, preview);
                }
            }
        }

        // Password confirmation validation
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = this.value;
            
            if (newPassword !== confirmPassword) {
                this.setCustomValidity('Mật khẩu xác nhận không khớp');
            } else {
                this.setCustomValidity('');
            }
        });

        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>