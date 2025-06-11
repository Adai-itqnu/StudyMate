<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StudyMate - Nền tảng học tập thông minh</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/index.css"/>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg" id="navbar">
        <div class="container">
            <a class="navbar-brand" href="#home">
                <i class="fas fa-brain me-2"></i>StudyMate
            </a>
            
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="#home">Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#features">Tính năng</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#about">Giới thiệu</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#contact">Liên hệ</a>
                    </li>
                </ul>
                
                <div class="auth-buttons">
                    <a href="${pageContext.request.contextPath}/login" class="btn-login">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn-register">Đăng ký</a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section" id="home">
        <div class="floating-elements">
            <div class="floating-icon">
                <i class="fas fa-book"></i>
            </div>
            <div class="floating-icon">
                <i class="fas fa-lightbulb"></i>
            </div>
            <div class="floating-icon">
                <i class="fas fa-graduation-cap"></i>
            </div>
            <div class="floating-icon">
                <i class="fas fa-users"></i>
            </div>
            <div class="floating-icon">
                <i class="fas fa-chart-line"></i>
            </div>
        </div>
        
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <div class="hero-content">
                        <h1>Quản lý học tập hiệu quả</h1>
                        <p class="subtitle">
                            StudyMate là nền tảng học tập thông minh giúp bạn quản lý quá trình học tập một cách khoa học và hiệu quả. 
                            Tạo môn học, đặt mục tiêu, viết ghi chú và kết nối với cộng đồng học tập.
                        </p>
                        
                        <div class="hero-cta">
                            <a href="/register" class="btn-primary-hero">
                                Bắt đầu ngay <i class="fas fa-arrow-right ms-2"></i>
                            </a>
                            <a href="#features" class="btn-secondary-hero">
                                Khám phá tính năng
                            </a>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-6">
                    <div class="hero-image">
                        <div class="image-card">
                            <div class="image-placeholder">
                                <i class="fas fa-graduation-cap"></i>
                            </div>
                            <h5 class="text-center mb-0">Học tập thông minh</h5>
                            <p class="text-center text-muted mb-0">Với StudyMate</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="stats-section">
        <div class="container">
            <div class="row">
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number">1000+</div>
                        <div class="stat-label">Học viên</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number">500+</div>
                        <div class="stat-label">Môn học</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number">2000+</div>
                        <div class="stat-label">Ghi chú</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number">95%</div>
                        <div class="stat-label">Hài lòng</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features-section" id="features">
        <div class="container">
            <div class="section-title">
                <h2>Tính năng nổi bật</h2>
                <p>Khám phá những tính năng mạnh mẽ giúp bạn học tập hiệu quả hơn</p>
            </div>
            
            <div class="row g-4">
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-book-open"></i>
                        </div>
                        <h4>Quản lý môn học</h4>
                        <p>Tạo và quản lý các môn học, lịch học, và tài liệu học tập một cách thuận tiện và có hệ thống.</p>
                    </div>
                </div>
                
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-sticky-note"></i>
                        </div>
                        <h4>Ghi chú thông minh</h4>
                        <p>Lưu trữ ý tưởng và kiến thức quan trọng, tổ chức ghi chú để ôn tập và chia sẻ dễ dàng.</p>
                    </div>
                </div>
                
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <h4>Cộng đồng học tập</h4>
                        <p>Kết nối với cộng đồng, trao đổi kiến thức và giải đáp thắc mắc cùng nhau.</p>
                    </div>
                </div>
                
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-target"></i>
                        </div>
                        <h4>Đặt mục tiêu</h4>
                        <p>Thiết lập mục tiêu học tập rõ ràng và theo dõi tiến độ hoàn thành một cách khoa học.</p>
                    </div>
                </div>
                
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <h4>Theo dõi tiến độ</h4>
                        <p>Giám sát quá trình học tập với biểu đồ trực quan và báo cáo chi tiết về hiệu suất.</p>
                    </div>
                </div>
                
                <div class="col-lg-4 col-md-6">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <h4>Lập kế hoạch</h4>
                        <p>Tạo lịch học tập cá nhân hóa, nhắc nhở và quản lý thời gian hiệu quả.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-lg-4">
                    <h5>
                        <i class="fas fa-brain me-2"></i>StudyMate
                    </h5>
                    <p>Nền tảng học tập thông minh giúp bạn quản lý quá trình học tập một cách hiệu quả và khoa học.</p>
                </div>
                <div class="col-lg-2">
                    <h5>Sản phẩm</h5>
                    <p><a href="#features">Tính năng</a></p>
                    <p><a href="#pricing">Bảng giá</a></p>
                    <p><a href="#download">Tải app</a></p>
                </div>
                <div class="col-lg-2">
                    <h5>Hỗ trợ</h5>
                    <p><a href="#help">Trung tâm trợ giúp</a></p>
                    <p><a href="#contact">Liên hệ</a></p>
                    <p><a href="#faq">FAQ</a></p>
                </div>
                <div class="col-lg-2">
                    <h5>Công ty</h5>
                    <p><a href="#about">Về chúng tôi</a></p>
                    <p><a href="#blog">Blog</a></p>
                    <p><a href="#careers">Tuyển dụng</a></p>
                </div>
                <div class="col-lg-2">
                    <h5>Kết nối</h5>
                    <p><a href="#facebook">Facebook</a></p>
                    <p><a href="#twitter">Twitter</a></p>
                    <p><a href="#instagram">Instagram</a></p>
                </div>
            </div>
            
            <hr style="border-color: #374151; margin: 2rem 0;">
            
            <div class="row align-items-center">
                <div class="col-md-6">
                    <p>&copy; 2025 StudyMate. All rights reserved.</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <p>
                        <a href="#privacy">Chính sách bảo mật</a> | 
                        <a href="#terms">Điều khoản sử dụng</a>
                    </p>
                </div>
            </div>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Navbar scroll effect
        window.addEventListener('scroll', function() {
            const navbar = document.getElementById('navbar');
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });

        // Smooth scroll for navigation links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Animation on scroll
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver(function(entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);

        // Observe all feature cards
        document.querySelectorAll('.feature-card').forEach(card => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(50px)';
            card.style.transition = 'all 0.6s ease';
            observer.observe(card);
        });

        // Counter animation for stats
        function animateCounter(element, start, end, duration) {
            let startTimestamp = null;
            const step = (timestamp) => {
                if (!startTimestamp) startTimestamp = timestamp;
                const progress = Math.min((timestamp - startTimestamp) / duration, 1);
                const value = Math.floor(progress * (end - start) + start);
                element.textContent = value + (element.textContent.includes('%') ? '%' : '+');
                if (progress < 1) {
                    window.requestAnimationFrame(step);
                }
            };
            window.requestAnimationFrame(step);
        }

        // Animate stats when in view
        const statsObserver = new IntersectionObserver(function(entries) {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const numbers = entry.target.querySelectorAll('.stat-number');
                    numbers.forEach(number => {
                        const text = number.textContent;
                        const value = parseInt(text.replace(/[^0-9]/g, ''));
                        animateCounter(number, 0, value, 2000);
                    });
                    statsObserver.unobserve(entry.target);
                }
            });
        });

        document.querySelector('.stats-section') && statsObserver.observe(document.querySelector('.stats-section'));
    </script>
</body>
</html>