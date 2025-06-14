<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StudyMate - Đăng Nhập</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/auth-styles.css"/>
    <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="auth-container">
        <!-- Left Panel - StudyMate Branding -->
        <div class="left-panel">
            <div class="floating-elements">
                <div class="book-icon">
                    <i class="fas fa-book-open"></i>
                </div>
                <div class="lightbulb-icon">
                    <i class="fas fa-lightbulb"></i>
                </div>
                <div class="graduation-icon">
                    <i class="fas fa-graduation-cap"></i>
                </div>
                <div class="chat-icon">
                    <i class="fas fa-comments"></i>
                </div>
            </div>
            
            <div class="logo-container">
                <div class="logo">
                    <i class="fas fa-brain"></i>
                    <span>StudyMate</span>
                </div>
            </div>
            
            <div class="welcome-text">
                <h1>Chào mừng trở lại!</h1>
                <p>Nền tảng học tập thông minh nơi bạn có thể:</p>
                <ul class="feature-list">
                    <li><i class="fas fa-question-circle"></i> Hỏi đáp thắc mắc</li>
                    <li><i class="fas fa-users"></i> Kết bạn giao lưu</li>
                    <li><i class="fas fa-sticky-note"></i> Ghi chú thông minh</li>
                    <li><i class="fas fa-calendar-alt"></i> Thời khóa biểu</li>
                    <li><i class="fas fa-tasks"></i> Quản lý task</li>
                </ul>
            </div>
        </div>

        <!-- Right Panel - Login Form -->
        <div class="right-panel">
            <div class="form-container">
                <div class="form-header">
                    <h2>Đăng Nhập</h2>
                    <p>Đăng nhập để tiếp tục hành trình học tập của bạn</p>
                </div>
                
                <c:if test="${not empty message}">
                    <div class="alert alert-success">
                        <i class="fas fa-check-circle"></i>
                        ${message}
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i>
                        ${error}
                    </div>
                </c:if>

                <form method="post" action="login" class="auth-form">
                 
                    
                    <div class="form-group">
                        <label for="email">
                            <i class="fas fa-envelope"></i>
                            Username
                        </label>
                        <input type="username" id="username" name="username" placeholder="Nhập username của bạn" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">
                            <i class="fas fa-lock"></i>
                            Mật khẩu
                        </label>
                        <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>
                    </div>
                    
                    <div class="form-options">
                        <div class="checkbox-group">
                            <input type="checkbox" id="remember" name="remember">
                            <label for="remember">Ghi nhớ đăng nhập</label>
                        </div>
                        <a href="forgot-password" class="forgot-link">Quên mật khẩu?</a>
                    </div>
                    
                    <button type="submit" class="submit-btn">
                        <i class="fas fa-sign-in-alt"></i>
                        Đăng Nhập
                    </button>
                    
                    <div class="divider">
                        <span>hoặc</span>
                    </div>
                    
                    <div class="form-links">
                        <p>Chưa có tài khoản? <a href="register">Đăng ký ngay</a></p>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>