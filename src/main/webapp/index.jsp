<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>StudyMate - Nền tảng học tập thông minh</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/css/index.css" rel="stylesheet">
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar">
        <div class="nav-container">
            <a href="#" class="logo">StudyMate</a>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">Trang chủ</a>
                <a href="#features" class="nav-link">Tính năng</a>
                <a href="#" class="nav-link">Hỗ trợ</a>
                <a href="${pageContext.request.contextPath}/user/login" class="btn-outline">Đăng nhập</a>
                <a href="${pageContext.request.contextPath}/user/register" class="btn-primary">Đăng ký ngay</a>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero">
        <div class="blob blob-1"></div>
        <div class="blob blob-2"></div>
        
        <div class="hero-container">
            <div class="hero-content">
                <h1>Quản lý học tập <span class="highlight">hiệu quả</span> cùng StudyMate</h1>
                <p>Nền tảng học tập thông minh giúp học sinh, sinh viên quản lý quá trình học tập một cách khoa học. Tạo môn học, đặt mục tiêu, viết ghi chú và kết nối với cộng đồng học tập.</p>
                
                <div class="hero-cta">
                    <a href="#" class="btn-primary">Bắt đầu ngay</a>
                    <a href="#" class="btn-outline">Tìm hiểu thêm</a>
                </div>

                <div class="stats">
                    <div class="stat-item">
                        <span class="stat-number">10K+</span>
                        <span class="stat-label">Học viên</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">500+</span>
                        <span class="stat-label">Môn học</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number">50K+</span>
                        <span class="stat-label">Ghi chú</span>
                    </div>
                </div>
            </div>

            <div class="hero-visual">
                <div class="main-visual">
                    📚 StudyMate
                </div>
                
                <div class="floating-card card-1">
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <div style="width: 30px; height: 30px; background: #8B5CF6; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white;">📝</div>
                        <div>
                            <strong>Ghi chú mới</strong>
                            <div style="font-size: 0.8rem; color: #666;">Toán học - Đạo hàm</div>
                        </div>
                    </div>
                </div>

                <div class="floating-card card-2">
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <div style="width: 30px; height: 30px; background: #10B981; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white;">✓</div>
                        <div>
                            <strong>Hoàn thành</strong>
                            <div style="font-size: 0.8rem; color: #666;">Bài tập Vật lý</div>
                        </div>
                    </div>
                </div>

                <div class="floating-card card-3">
                    <div style="display: flex; align-items: center; gap: 10px;">
                        <div style="width: 30px; height: 30px; background: #F59E0B; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white;">💬</div>
                        <div>
                            <strong>3 câu hỏi mới</strong>
                            <div style="font-size: 0.8rem; color: #666;">Cộng đồng</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="features" id="features">
        <div class="features-container">
            <div class="section-title">
                <h2>Tính năng nổi bật</h2>
                <p>Khám phá những công cụ mạnh mẽ giúp bạn học tập hiệu quả hơn</p>
            </div>

            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon">📚</div>
                    <h3>Quản lý môn học</h3>
                    <p>Tạo và quản lý các môn học, lịch học, và tài liệu học tập một cách thuận tiện. Theo dõi tiến độ học tập và đặt mục tiêu cụ thể.</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">📝</div>
                    <h3>Ghi chú thông minh</h3>
                    <p>Lưu trữ ý tưởng và kiến thức quan trọng với công cụ ghi chú hiện đại. Tổ chức, tìm kiếm và chia sẻ ghi chú dễ dàng.</p>
                </div>

                <div class="feature-card">
                    <div class="feature-icon">💬</div>
                    <h3>Cộng đồng học tập</h3>
                    <p>Kết nối và trao đổi với cộng đồng học tập. Đặt câu hỏi, thảo luận và giải đáp những vấn đề khó khăn cùng nhau.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-container">
            <h3>StudyMate</h3>
            <p>Nền tảng quản lý học tập hiệu quả - Xây dựng không gian học tập thông minh và kết nối</p>
            
            <div class="footer-bottom">
                <p>&copy; 2025 StudyMate. All rights reserved.</p>
            </div>
        </div>
    </footer>
</body>
</html>