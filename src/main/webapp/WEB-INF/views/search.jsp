<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm kiếm - StudyMate</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .search-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        .search-form {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 2rem;
        }
        .search-input {
            border-radius: 25px;
            border: 2px solid #e9ecef;
            padding: 12px 20px;
            font-size: 16px;
        }
        .search-input:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
        }
        .search-btn {
            border-radius: 25px;
            padding: 12px 30px;
            font-weight: 600;
        }
        .search-filters {
            margin-top: 1rem;
        }
        .filter-chip {
            display: inline-block;
            padding: 8px 16px;
            margin: 4px;
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .filter-chip:hover, .filter-chip.active {
            background: #007bff;
            color: white;
            border-color: #007bff;
        }
        .recent-searches {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 1.5rem;
        }
        .search-suggestion {
            padding: 10px;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s;
        }
        .search-suggestion:hover {
            background: #f8f9fa;
        }
    </style>
</head>
<body class="bg-light">
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="/">
                <i class="fas fa-graduation-cap"></i> StudyMate
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="/dashboard">Dashboard</a>
                <a class="nav-link" href="/profile">Profile</a>
                <a class="nav-link" href="/logout">Đăng xuất</a>
            </div>
        </div>
    </nav>

    <div class="search-container">
        <!-- Form tìm kiếm chính -->
        <div class="search-form">
            <h2 class="text-center mb-4">
                <i class="fas fa-search text-primary"></i> Tìm kiếm
            </h2>
            
            <form id="searchForm" method="post" action="/search">
                <div class="row">
                    <div class="col-md-8">
                        <div class="input-group">
                            <span class="input-group-text bg-white border-end-0">
                                <i class="fas fa-search text-muted"></i>
                            </span>
                            <input type="text" 
                                   class="form-control search-input border-start-0" 
                                   name="query" 
                                   id="searchQuery"
                                   placeholder="Nhập từ khóa tìm kiếm..."
                                   value="${param.query}"
                                   required>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <button type="submit" class="btn btn-primary search-btn w-100">
                            <i class="fas fa-search"></i> Tìm kiếm
                        </button>
                    </div>
                </div>

                <!-- Bộ lọc tìm kiếm -->
                <div class="search-filters">
                    <h6 class="mb-3">Tìm kiếm trong:</h6>
                    <div class="d-flex flex-wrap">
                        <label class="filter-chip">
                            <input type="radio" name="type" value="all" checked hidden>
                            <i class="fas fa-globe"></i> Tất cả
                        </label>
                        <label class="filter-chip">
                            <input type="radio" name="type" value="posts" hidden>
                            <i class="fas fa-file-alt"></i> Bài viết
                        </label>
                        <label class="filter-chip">
                            <input type="radio" name="type" value="users" hidden>
                            <i class="fas fa-users"></i> Người dùng
                        </label>
                    </div>
                </div>

                <!-- Tìm kiếm nâng cao -->
                <div class="mt-4">
                    <a href="#" class="text-decoration-none" data-bs-toggle="collapse" data-bs-target="#advancedSearch">
                        <i class="fas fa-cog"></i> Tìm kiếm nâng cao
                    </a>
                    
                    <div class="collapse mt-3" id="advancedSearch">
                        <div class="row">
                            <div class="col-md-6">
                                <label class="form-label">Trường học:</label>
                                <select class="form-select" name="schoolFilter">
                                    <option value="">Tất cả trường</option>
                                    <!-- Danh sách trường sẽ được load từ DB -->
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Môn học:</label>
                                <select class="form-select" name="subjectFilter">
                                    <option value="">Tất cả môn</option>
                                    <!-- Danh sách môn sẽ được load từ DB -->
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <!-- Tìm kiếm gần đây -->
        <div class="recent-searches">
            <h5 class="mb-3"><i class="fas fa-history text-muted"></i> Tìm kiếm gần đây</h5>
            <div id="recentSearches">
                <p class="text-muted mb-0">Chưa có tìm kiếm nào</p>
            </div>
        </div>

        <!-- Gợi ý tìm kiếm -->
        <div class="recent-searches mt-3">
            <h5 class="mb-3"><i class="fas fa-lightbulb text-muted"></i> Gợi ý tìm kiếm</h5>
            <div class="d-flex flex-wrap">
                <span class="badge bg-light text-dark me-2 mb-2 search-suggestion" onclick="searchSuggestion('toán học')">
                    #toán học
                </span>
                <span class="badge bg-light text-dark me-2 mb-2 search-suggestion" onclick="searchSuggestion('vật lý')">
                    #vật lý
                </span>
                <span class="badge bg-light text-dark me-2 mb-2 search-suggestion" onclick="searchSuggestion('hóa học')">
                    #hóa học
                </span>
                <span class="badge bg-light text-dark me-2 mb-2 search-suggestion" onclick="searchSuggestion('sinh học')">
                    #sinh học
                </span>
                <span class="badge bg-light text-dark me-2 mb-2 search-suggestion" onclick="searchSuggestion('lịch sử')">
                    #lịch sử
                </span>
                <span class="badge bg-light text-dark me-2 mb-2 search-suggestion" onclick="searchSuggestion('địa lý')">
                    #địa lý
                </span>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Xử lý filter chips
        document.querySelectorAll('.filter-chip').forEach(chip => {
            chip.addEventListener('click', function() {
                // Bỏ active cho tất cả
                document.querySelectorAll('.filter-chip').forEach(c => c.classList.remove('active'));
                // Thêm active cho chip được click
                this.classList.add('active');
                // Check radio button
                this.querySelector('input[type="radio"]').checked = true;
            });
        });

        // Set active cho filter đã chọn
        const selectedType = "${param.type}" || "all";
        document.querySelector(`input[name="type"][value="${selectedType}"]`).parentElement.classList.add('active');

        // Lưu tìm kiếm gần đây
        function saveRecentSearch(query) {
            let recent = JSON.parse(localStorage.getItem('recentSearches') || '[]');
            recent = recent.filter(item => item !== query); // Xóa nếu đã tồn tại
            recent.unshift(query); // Thêm vào đầu
            recent = recent.slice(0, 5); // Giữ tối đa 5 item
            localStorage.setItem('recentSearches', JSON.stringify(recent));
            displayRecentSearches();
        }

        // Hiển thị tìm kiếm gần đây
        function displayRecentSearches() {
            const recent = JSON.parse(localStorage.getItem('recentSearches') || '[]');
            const container = document.getElementById('recentSearches');
            
            if (recent.length === 0) {
                container.innerHTML = '<p class="text-muted mb-0">Chưa có tìm kiếm nào</p>';
                return;
            }
            
            container.innerHTML = recent.map(query => 
                `<div class="search-suggestion" onclick="searchSuggestion('${query}')">
                    <i class="fas fa-search text-muted me-2"></i>${query}
                </div>`
            ).join('');
        }

        // Tìm kiếm với gợi ý
        function searchSuggestion(query) {
            document.getElementById('searchQuery').value = query;
            document.getElementById('searchForm').submit();
        }

        // Xử lý submit form
        document.getElementById('searchForm').addEventListener('submit', function(e) {
            const query = document.getElementById('searchQuery').value.trim();
            if (query) {
                saveRecentSearch(query);
            }
        };
    </script>
</body>
</html>