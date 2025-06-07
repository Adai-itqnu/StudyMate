<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Đăng ký tài khoản - StudyMate</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
     <link href="${pageContext.request.contextPath}/resources/css/register.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <div class="left-panel">
            <div class="rocket-container">
                <div class="rocket">🚀</div>
                <h2>Khởi tạo hành trình học tập</h2>
                <p>Tham gia StudyMate để kết nối với cộng đồng học tập năng động và chia sẻ kiến thức cùng nhau!</p>
            </div>
        </div>
        
        <div class="right-panel">
            <div class="form-header">
                <h1>Tạo tài khoản</h1>
                <p>Điền thông tin của bạn để bắt đầu</p>
            </div>
            
            <% if (session.getAttribute("error") != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle"></i>
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
            
            <form action="${pageContext.request.contextPath}/user/register" method="post" onsubmit="return validateForm()">
                <div class="form-group">
                    <label for="fullName">
                        <i class="fas fa-user"></i> Họ và tên
                    </label>
                    <input type="text" id="fullName" name="fullName" required maxlength="100">
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="username">
                            <i class="fas fa-at"></i> Tên đăng nhập
                        </label>
                        <input type="text" id="username" name="username" required minlength="3" maxlength="20" pattern="[a-zA-Z0-9_]+" title="Chỉ chứa chữ cái, số và dấu gạch dưới">
                    </div>
                    
                    <div class="form-group">
                        <label for="email">
                            <i class="fas fa-envelope"></i> Email
                        </label>
                        <input type="email" id="email" name="email" required>
                    </div>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="phone">
                            <i class="fas fa-phone"></i> Số điện thoại
                        </label>
                        <input type="tel" id="phone" name="phone" pattern="[0-9]{10,11}" title="Số điện thoại phải có 10-11 chữ số">
                    </div>
                    
                    <div class="form-group">
                        <label for="dateOfBirth">
                            <i class="fas fa-calendar"></i> Ngày sinh
                        </label>
                        <input type="date" id="dateOfBirth" name="dateOfBirth" max="">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="password">
                        <i class="fas fa-lock"></i> Mật khẩu
                    </label>
                    <div class="input-container">
                        <input type="password" id="password" name="password" required minlength="6" maxlength="50" onkeyup="checkPasswordStrength()">
                        <i class="fas fa-eye password-toggle" onclick="togglePassword('password')" id="togglePassword"></i>
                    </div>
                    <div id="passwordStrength" class="password-strength"></div>
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">
                        <i class="fas fa-lock"></i> Xác nhận mật khẩu
                    </label>
                    <div class="input-container">
                        <input type="password" id="confirmPassword" name="confirmPassword" required onkeyup="checkPasswordMatch()">
                        <i class="fas fa-eye password-toggle" onclick="togglePassword('confirmPassword')" id="toggleConfirmPassword"></i>
                    </div>
                    <div id="passwordMatch" class="password-match"></div>
                </div>
                
                <button type="submit" class="submit-btn">
                    <i class="fas fa-rocket"></i> Tạo tài khoản
                </button>
                
                <div class="login-link">
                    Đã có tài khoản? <a href="${pageContext.request.contextPath}/user/login">Đăng nhập ngay</a>
                </div>
            </form>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/register.js"></script>
</body>
</html>