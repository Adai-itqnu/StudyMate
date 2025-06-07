<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>StudyMate - Đăng nhập</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/login.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <div class="left-panel">
            <div class="rocket">🚀</div>
            <h2>Khởi động ứng dụng học tập</h2>
            <p>Tham gia cộng đồng học tập StudyMate và nâng cao kiến thức của bạn</p>
            
            <div class="feature-list">
                <div class="feature-item">
                    <i class="fas fa-check"></i>
                    <span>Học tập cùng bạn bè</span>
                </div>
                <div class="feature-item">
                    <i class="fas fa-check"></i>
                    <span>Chia sẻ tài liệu học tập</span>
                </div>
                <div class="feature-item">
                    <i class="fas fa-check"></i>
                    <span>Theo dõi tiến độ học tập</span>
                </div>
                <div class="feature-item">
                    <i class="fas fa-check"></i>
                    <span>Tạo nhóm học tập</span>
                </div>
            </div>
        </div>

        <div class="right-panel">
            <div class="form-header">
                <h3>Đăng nhập</h3>
                <p>Chào mừng bạn trở lại! Vui lòng đăng nhập vào tài khoản của bạn</p>
            </div>

            <% if (session.getAttribute("error") != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= session.getAttribute("error") %>
                </div>
                <% session.removeAttribute("error"); %>
            <% } %>

            <% if (session.getAttribute("message") != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <%= session.getAttribute("message") %>
                </div>
                <% session.removeAttribute("message"); %>
            <% } %>

            <form action="${pageContext.request.contextPath}/user/login" method="post" id="loginForm">
                <div class="form-group">
                    <label for="username">Tên đăng nhập</label>
                    <div class="input-container">
                        <input type="text" name="username" id="username" class="form-control" 
                               placeholder="Nhập tên đăng nhập của bạn" required>
                        <i class="fas fa-user input-icon"></i>
                    </div>
                </div>

                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <div class="input-container">
                        <input type="password" name="password" id="password" class="form-control" 
                               placeholder="Nhập mật khẩu của bạn" required>
                        <i class="fas fa-lock input-icon"></i>
                    </div>
                </div>

                <div class="remember-me">
                    <input type="checkbox" id="rememberMe" name="rememberMe">
                    <label for="rememberMe">Ghi nhớ đăng nhập</label>
                </div>

                <button type="submit" class="btn-login" id="loginBtn">
                    <span class="loading" id="loadingSpinner"></span>
                    <span id="loginText">Đăng nhập</span>
                </button>

                <div class="forgot-password">
                    <a href="#" onclick="alert('Tính năng đang phát triển!')">Quên mật khẩu?</a>
                </div>
            </form>

            <div class="divider">
                <span>hoặc</span>
            </div>

            <div class="register-link">
                <p>Chưa có tài khoản? <a href="${pageContext.request.contextPath}/user/register">Tạo tài khoản mới</a></p>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/login.js"></script>
</body>
</html>