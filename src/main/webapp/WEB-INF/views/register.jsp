<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StudyMate - Đăng Ký</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/auth-styles.css"/>
    <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="auth-container register-container">
        <!-- Left Panel - StudyMate Branding -->
        <div class="left-panel">
            <div class="floating-elements">
                <div class="book-icon">
                    <i class="fas fa-book"></i>
                </div>
                <div class="lightbulb-icon">
                    <i class="fas fa-lightbulb"></i>
                </div>
                <div class="graduation-icon">
                    <i class="fas fa-graduation-cap"></i>
                </div>
                <div class="chat-icon">
                    <i class="fas fa-user-friends"></i>
                </div>
                <div class="note-icon">
                    <i class="fas fa-clipboard-list"></i>
                </div>
            </div>
            
            <div class="logo-container">
                <div class="logo">
                    <i class="fas fa-brain"></i>
                    <span>StudyMate</span>
                </div>
            </div>
            
            <div class="welcome-text">
                <h1>Bắt đầu hành trình học tập!</h1>
                <p>Tham gia cộng đồng học tập thông minh và khám phá:</p>
                <ul class="feature-list">
                    <li><i class="fas fa-question-circle"></i> Hỏi đáp mọi thắc mắc</li>
                    <li><i class="fas fa-users"></i> Kết nối bạn bè cùng chí hướng</li>
                    <li><i class="fas fa-sticky-note"></i> Ghi chú thông minh</li>
                    <li><i class="fas fa-calendar-check"></i> Lên kế hoạch học tập</li>
                    <li><i class="fas fa-chart-line"></i> Theo dõi tiến độ</li>
                </ul>
            </div>
        </div>

        <!-- Right Panel - Register Form -->
        <div class="right-panel">
            <div class="form-container">
                <div class="form-header">
                    <h2>Đăng Ký Tài Khoản</h2>
                    <p>Tạo tài khoản để bắt đầu học tập hiệu quả</p>
                </div>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        <i class="fas fa-exclamation-circle"></i>
                        ${error}
                    </div>
                </c:if>

                <form method="post" action="register" class="auth-form">
                    <input type="hidden" name="csrfToken" value="${csrfToken}" />
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="fullName">
                                <i class="fas fa-user"></i>
                                Họ và tên
                            </label>
                            <input type="text" id="fullName" name="fullName" 
                                   value="${param.fullName}" placeholder="Nhập họ và tên" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="username">
                                <i class="fas fa-at"></i>
                                Username
                            </label>
                            <input type="text" id="username" name="username" 
                                   value="${param.username}" placeholder="Nhập username" required>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="email">
                                <i class="fas fa-envelope"></i>
                                Email
                            </label>
                            <input type="email" id="email" name="email" 
                                   value="${param.email}" placeholder="Nhập email" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="phone">
                                <i class="fas fa-phone"></i>
                                Số điện thoại
                            </label>
                            <input type="tel" id="phone" name="phone" 
                                   value="${param.phone}" placeholder="Nhập số điện thoại">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="dateOfBirth">
                            <i class="fas fa-calendar"></i>
                            Ngày sinh
                        </label>
                        <input type="date" id="dateOfBirth" name="dateOfBirth" 
                               value="${param.dateOfBirth}">
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="password">
                                <i class="fas fa-lock"></i>
                                Mật khẩu
                            </label>
                            <input type="password" id="password" name="password" 
                                   placeholder="Nhập mật khẩu" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="confirmPassword">
                                <i class="fas fa-lock"></i>
                                Nhập lại mật khẩu
                            </label>
                            <input type="password" id="confirmPassword" name="confirmPassword" 
                                   placeholder="Nhập lại mật khẩu" required>
                        </div>
                    </div>
                    
                    <button type="submit" class="submit-btn">
                        <i class="fas fa-user-plus"></i>
                        Tạo Tài Khoản
                    </button>
                    
                    <div class="divider">
                        <span>hoặc</span>
                    </div>
                    
                    <div class="form-links">
                        <p>Đã có tài khoản? <a href="login">Đăng nhập ngay</a></p>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>