<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>StudyMate - Nền tảng học tập thông minh</title>
    <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        .hero-section {
            background-color: #f8f9fa;
            padding: 80px 0;
            margin-bottom: 40px;
        }
        .feature-box {
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 5px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        .navbar-nav {
            margin-left: auto;
        }
        .nav-item{
        	margin-left: 5px;
        }
        .navbar-brand{
        	
        }
    </style>
</head>
<body>
    <!-- Thanh điều hướng -->
    <nav class="navbar navbar-expand-lg navbar-light bg-light">
        <div class="container">
            <a class="navbar-brand fw-bold text-success" href="${pageContext.request.contextPath}/">StudyMate</a>
            <div class="collapse navbar-collapse">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="btn btn-outline-success" href="${pageContext.request.contextPath}/user/login">Đăng nhập</a>
                    </li>
                    <li class="nav-item">
                        <a class="btn btn-outline-success" href="${pageContext.request.contextPath}/user/register">Đăng ký ngay</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Phần hero -->
    <div class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <h1 class="display-4 fw-bold mb-4">Quản lý học tập hiệu quả</h1>
                    <p class="lead mb-4">
                        StudyMate là một website giúp người dùng (đặc biệt là học sinh, sinh viên) quản lý quá trình học tập một cách khoa học và hiệu quả.
                         Người dùng có thể tự tạo các môn học, lên mục tiêu học tập, viết ghi chú học tập và có thể hỏi đáp với mọi người nếu gặp những vấn đề khó khăn trong quá trình học tập.
                         
                    </p> 
                    
                    <p class="lead mb-5">
                       Mục tiêu của StudyMate là xây dựng một không gian học tập thông minh, linh hoạt và kết nối – nơi người học không chỉ tiếp thu kiến thức mà còn được truyền cảm hứng để học tốt hơn mỗi ngày.         
                    </p> 
                    
                </div>
                <div class="col-lg-6 d-none d-lg-block">
                    <div class="text-center">
                        <img src="${pageContext.request.contextPath}/resources/img/study.png" alt="Học tập" class="img-fluid" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/resources/img/study.png';" style="max-height: 400px;">
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Các tính năng -->
    <div class="container mb-5">
        <h2 class="text-center mb-5">Tính năng nổi bật</h2>
        <div class="row">
            <div class="col-md-4">
                <div class="feature-box bg-light">
                    <h4 class="mb-3">Quản lý môn học</h4>
                    <p>Tạo và quản lý các môn học, lịch học, và tài liệu học tập một cách thuận tiện.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-box bg-light">
                    <h4 class="mb-3">Viết ghi chú học tập</h4>
                    <p>Lưu trữ ý tưởng hoặc kiến thức quan trọng để ôn tập và chia sẻ với mọi người dễ dàng.</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="feature-box bg-light">
                    <h4 class="mb-3">Trao đổi học tập</h4>
                    <p>Tạo ra một cộng đồng cùng nhau bàn luận về 1 chủ đề khó khăn mà bạn mắc phải</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-white py-4">
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
</body>
</html>