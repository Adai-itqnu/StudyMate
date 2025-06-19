<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StudyMate - Quản lý Task</title>
    <link href="<c:url value='/assets/css/bootstrap.min.css'/>" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/dashboard.css"/>
    <style>
        body {
            font-family: 'Segoe UI', 'Roboto', 'Helvetica Neue', sans-serif;
            background: linear-gradient(135deg, #faf8f7 0%, #f8f5f3 50%, #ffffff 100%);
            min-height: 100vh;
            color: #333;
        }
        
        /* Task Styles */
        .task-section {
            background: white;
            border-radius: 18px;
            box-shadow: 0 4px 20px rgba(142,36,170,0.10);
            border: 1.5px solid #e1bee7;
            margin-bottom: 24px;
            overflow: hidden;
        }
        
        .section-header {
            background: linear-gradient(135deg, #8e24aa 0%, #ba68c8 60%, #e1bee7 100%);
            color: white;
            padding: 16px 24px;
            font-weight: 700;
            font-size: 1.1rem;
        }
        
        .task-form {
            background: linear-gradient(135deg, #f3e5f5, #e1bee7);
            padding: 20px 24px;
            border-bottom: 1px solid #e1bee7;
        }
        
        .task-form input[type="text"], 
        .task-form input[type="date"] {
            border: 2px solid #e1bee7;
            border-radius: 12px;
            padding: 10px 16px;
            margin-right: 8px;
            margin-bottom: 8px;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        
        .task-form input[type="text"]:focus, 
        .task-form input[type="date"]:focus {
            border-color: #8e24aa;
            box-shadow: 0 0 0 3px rgba(142,36,170,0.1);
            outline: none;
        }
        
        .btn-purple {
            background: linear-gradient(135deg, #8e24aa, #ba68c8);
            color: #fff;
            border: none;
            font-weight: 600;
            border-radius: 12px;
            padding: 10px 20px;
            transition: all 0.2s;
        }
        
        .btn-purple:hover {
            background: linear-gradient(135deg, #6a1b9a, #8e24aa);
            color: #fff;
            box-shadow: 0 6px 20px rgba(142,36,170,0.18);
            transform: translateY(-1px);
        }
        
        .task-box {
            border: none;
            border-bottom: 1px solid #f0f0f0;
            padding: 20px 24px;
            margin-bottom: 0;
            border-radius: 0;
            background: white;
            transition: background-color 0.2s;
        }
        
        .task-box:hover {
            background-color: #fafafa;
        }
        
        .task-box:last-child {
            border-bottom: none;
        }
        
        .task-title {
            font-weight: 600;
            font-size: 1.1rem;
            color: #333;
            margin-bottom: 4px;
        }
        
        .task-description {
            color: #666;
            font-size: 0.9rem;
            margin-bottom: 8px;
        }
        
        .task-meta {
            color: #888;
            font-size: 0.8rem;
            margin-bottom: 12px;
        }
        
        .task-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            align-items: center;
            margin-bottom: 16px;
        }
        
        .btn-sm {
            padding: 6px 12px;
            font-size: 0.85rem;
            border-radius: 8px;
            font-weight: 500;
        }
        
        .btn-success {
            background: #28a745;
            border-color: #28a745;
        }
        
        .btn-warning {
            background: #ffc107;
            border-color: #ffc107;
            color: #212529;
        }
        
        .btn-danger {
            background: #dc3545;
            border-color: #dc3545;
        }
        
        .btn-info {
            background: #17a2b8;
            border-color: #17a2b8;
        }
        
        .btn-secondary {
            background: #6c757d;
            border-color: #6c757d;
        }
        
        .completed {
            opacity: 0.6;
        }
        
        .completed .task-title {
            text-decoration: line-through;
            color: #999;
        }
        
        .pinned {
            background: linear-gradient(135deg, #fff8e1, #ffecb3) !important;
            border-left: 4px solid #ff9800;
        }
        
        .pinned .task-title {
            color: #e65100;
        }
        
        .error {
            background: #f8d7da;
            color: #721c24;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 16px;
            border: 1px solid #f5c6cb;
        }
        
        .success {
            background: #d4edda;
            color: #155724;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 16px;
            border: 1px solid #c3e6cb;
        }
        
        .update-form {
            background: #f8f9fa;
            padding: 16px;
            border-radius: 8px;
            margin-top: 12px;
            border: 1px solid #dee2e6;
            display: none;
        }
        
        .update-form.show {
            display: block;
        }
        
        .update-form input {
            margin-right: 8px;
            margin-bottom: 8px;
        }
        
        .no-tasks {
            text-align: center;
            padding: 40px 20px;
            color: #666;
        }
        
        .no-tasks i {
            font-size: 3rem;
            color: #e1bee7;
            margin-bottom: 16px;
        }
        
        .toggle-edit {
            background: #6c757d;
            border-color: #6c757d;
        }
        
        .toggle-edit:hover {
            background: #5a6268;
            border-color: #545b62;
        }
        
        @media (max-width: 768px) {
            .task-form .row > div {
                margin-bottom: 10px;
            }
            
            .task-actions {
                flex-direction: column;
                align-items: stretch;
            }
            
            .task-actions form {
                width: 100%;
            }
            
            .task-actions .btn {
                width: 100%;
                margin-bottom: 5px;
            }
        }
    </style>
</head>
<body>
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
            <!-- Sidebar trái -->
            <div class="col-md-3">
                <div class="sidebar">
                    <h5 class="mb-3">
                        <i class="fas fa-users"></i> Gợi ý theo dõi
                    </h5>
                    <c:forEach var="suggestion" items="${suggestions}">
                        <div class="suggestion-card">
                            <div class="d-flex align-items-center">
                                <img src="${suggestion.avatarUrl != null ? suggestion.avatarUrl : '/assets/images/default-avatar.png'}" alt="Avatar" class="avatar me-3">
                                <div class="flex-grow-1">
                                    <h6 class="mb-1">${suggestion.fullName}</h6>
                                    <small class="text-muted">@${suggestion.username}</small>
                                </div>
                            </div>
                            <div class="mt-2">
                                <button class="btn btn-primary btn-sm me-2" onclick="followUser(${suggestion.userId})">
                                    <i class="fas fa-plus"></i> Theo dõi
                                </button>
                                <a href="<c:url value='/profile/${suggestion.userId}'/>" class="btn btn-outline-secondary btn-sm">Xem trang</a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Main Content Area: Task Management -->
            <div class="col-md-6">
                <div class="main-content">
                    <!-- Error Display -->
                    <c:if test="${not empty error}">
                        <div class="error">
                            <i class="fas fa-exclamation-triangle me-2"></i>${error}
                        </div>
                    </c:if>

                    <!-- Success Display -->
                    <c:if test="${not empty success}">
                        <div class="success">
                            <i class="fas fa-check-circle me-2"></i>${success}
                        </div>
                    </c:if>

                    <!-- Task Creation Form -->
                    <div class="task-section">
                        <div class="section-header">
                            <i class="fas fa-plus-circle me-2"></i>Tạo Task Mới
                        </div>
                        <div class="task-form">
                            <form method="post" action="${pageContext.request.contextPath}/tasks">
                                <input type="hidden" name="action" value="add" />
                                <div class="row">
                                    <div class="col-md-4">
                                        <input type="text" name="title" class="form-control" placeholder="Tên task *" required maxlength="255" />
                                    </div>
                                    <div class="col-md-4">
                                        <input type="text" name="description" class="form-control" placeholder="Mô tả" maxlength="500" />
                                    </div>
                                    <div class="col-md-2">
                                        <input type="date" name="dueDate" class="form-control" title="Hạn hoàn thành" />
                                    </div>
                                    <div class="col-md-2">
                                        <button type="submit" class="btn btn-purple w-100">
                                            <i class="fas fa-plus me-1"></i>Tạo
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Todo Tasks -->
                    <div class="task-section">
                        <div class="section-header">
                            <i class="fas fa-list-check me-2"></i>Task Chưa Hoàn Thành 
                            <span class="badge bg-light text-dark ms-2">${not empty todoTasks ? todoTasks.size() : 0}</span>
                        </div>
                        <c:choose>
                            <c:when test="${not empty todoTasks}">
                                <c:forEach var="task" items="${todoTasks}">
                                    <div class="task-box ${task.pinned ? 'pinned' : ''}">
                                        <div class="task-title">
                                            <c:if test="${task.pinned}">
                                                <i class="fas fa-thumbtack me-2 text-warning"></i>
                                            </c:if>
                                            ${task.title}
                                        </div>
                                        
                                        <c:if test="${not empty task.description}">
                                            <div class="task-description">${task.description}</div>
                                        </c:if>
                                        
                                        <div class="task-meta">
                                            <i class="fas fa-calendar me-1"></i>
                                            Tạo: <fmt:formatDate value="${task.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            <c:if test="${task.dueDate != null}">
                                                | <i class="fas fa-clock me-1"></i>
                                                Hạn: <fmt:formatDate value="${task.dueDate}" pattern="dd/MM/yyyy"/>
                                                <c:set var="now" value="<%= new java.util.Date() %>" />
                                                <c:if test="${task.dueDate.time < now.time}">
                                                    <span class="badge bg-danger ms-1">Quá hạn</span>
                                                </c:if>
                                            </c:if>
                                        </div>
                                        
                                        <div class="task-actions">
                                            <!-- Pin/Unpin Button -->
                                            <form method="post" action="${pageContext.request.contextPath}/tasks" style="display:inline;">
                                                <input type="hidden" name="action" value="pin" />
                                                <input type="hidden" name="taskId" value="${task.taskId}" />
                                                <button type="submit" class="btn ${task.pinned ? 'btn-secondary' : 'btn-warning'} btn-sm" 
                                                        onclick="return confirm('${task.pinned ? 'Bỏ ghim task này?' : 'Ghim task này lên đầu danh sách?'}')">
                                                    <i class="fas fa-thumbtack me-1"></i>${task.pinned ? 'Bỏ ghim' : 'Ghim'}
                                                </button>
                                            </form>
                                            
                                            <!-- Complete Button -->
                                            <form method="post" action="${pageContext.request.contextPath}/tasks" style="display:inline;">
                                                <input type="hidden" name="action" value="complete" />
                                                <input type="hidden" name="taskId" value="${task.taskId}" />
                                                <button type="submit" class="btn btn-success btn-sm" 
                                                        onclick="return confirm('Đánh dấu task này là hoàn thành?')">
                                                    <i class="fas fa-check me-1"></i>Hoàn thành
                                                </button>
                                            </form>
                                            
                                            <!-- Edit Toggle Button -->
                                            <button type="button" class="btn btn-secondary btn-sm" onclick="toggleEdit(${task.taskId})">
                                                <i class="fas fa-edit me-1"></i>Sửa
                                            </button>
                                            
                                            <!-- Delete Button -->
                                            <form method="post" action="${pageContext.request.contextPath}/tasks" style="display:inline;">
                                                <input type="hidden" name="action" value="delete" />
                                                <input type="hidden" name="taskId" value="${task.taskId}" />
                                                <button type="submit" class="btn btn-danger btn-sm" 
                                                        onclick="return confirm('Bạn có chắc chắn muốn xóa task này?')">
                                                    <i class="fas fa-trash me-1"></i>Xóa
                                                </button>
                                            </form>
                                        </div>

                                        <!-- Update Form -->
                                        <div class="update-form" id="editForm-${task.taskId}">
                                            <form method="post" action="${pageContext.request.contextPath}/tasks">
                                                <input type="hidden" name="action" value="update" />
                                                <input type="hidden" name="taskId" value="${task.taskId}" />
                                                <div class="row">
                                                    <div class="col-md-4">
                                                        <input type="text" name="title" value="${task.title}" class="form-control" required maxlength="255" placeholder="Tên task *" />
                                                    </div>
                                                    <div class="col-md-4">
                                                        <input type="text" name="description" value="${task.description}" class="form-control" maxlength="500" placeholder="Mô tả" />
                                                    </div>
                                                    <div class="col-md-2">
                                                        <c:choose>
                                                            <c:when test="${task.dueDate != null}">
                                                                <fmt:formatDate value="${task.dueDate}" pattern="yyyy-MM-dd" var="formattedDate"/>
                                                                <input type="date" name="dueDate" value="${formattedDate}" class="form-control" />
                                                            </c:when>
                                                            <c:otherwise>
                                                                <input type="date" name="dueDate" value="" class="form-control" />
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                    <div class="col-md-2">
                                                        <button type="submit" class="btn btn-info btn-sm w-100">
                                                            <i class="fas fa-save me-1"></i>Lưu
                                                        </button>
                                                    </div>
                                                </div>
                                                <div class="mt-2">
                                                    <button type="button" class="btn btn-secondary btn-sm" onclick="toggleEdit(${task.taskId})">
                                                        <i class="fas fa-times me-1"></i>Hủy
                                                    </button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="no-tasks">
                                    <i class="fas fa-clipboard-list"></i>
                                    <p>Chưa có task nào cần hoàn thành.</p>
                                    <small class="text-muted">Hãy tạo task đầu tiên của bạn!</small>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Completed Tasks -->
                    <div class="task-section">
                        <div class="section-header">
                            <i class="fas fa-check-circle me-2"></i>Task Đã Hoàn Thành
                            <span class="badge bg-light text-dark ms-2">${not empty doneTasks ? doneTasks.size() : 0}</span>
                        </div>
                        <c:choose>
                            <c:when test="${not empty doneTasks}">
                                <c:forEach var="task" items="${doneTasks}">
                                    <div class="task-box completed">
                                        <div class="task-title">
                                            <i class="fas fa-check-circle me-2 text-success"></i>
                                            ${task.title}
                                        </div>
                                        
                                        <c:if test="${not empty task.description}">
                                            <div class="task-description">${task.description}</div>
                                        </c:if>
                                        
                                        <div class="task-meta">
                                            <i class="fas fa-calendar me-1"></i>
                                            Hoàn thành: <fmt:formatDate value="${task.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            <c:if test="${task.dueDate != null}">
                                                | <i class="fas fa-clock me-1"></i>
                                                Hạn: <fmt:formatDate value="${task.dueDate}" pattern="dd/MM/yyyy"/>
                                            </c:if>
                                        </div>
                                        
                                        <div class="task-actions">
                                            <!-- Uncomplete Button -->
                                            <form method="post" action="${pageContext.request.contextPath}/tasks" style="display:inline;">
                                                <input type="hidden" name="action" value="uncomplete" />
                                                <input type="hidden" name="taskId" value="${task.taskId}" />
                                                <button type="submit" class="btn btn-secondary btn-sm" 
                                                        onclick="return confirm('Chuyển task này về trạng thái chưa hoàn thành?')">
                                                    <i class="fas fa-undo me-1"></i>Chuyển về TODO
                                                </button>
                                            </form>
                                            
                                            <!-- Delete Button -->
                                            <form method="post" action="${pageContext.request.contextPath}/tasks" style="display:inline;">
                                                <input type="hidden" name="action" value="delete" />
                                                <input type="hidden" name="taskId" value="${task.taskId}" />
                                                <button type="submit" class="btn btn-danger btn-sm" 
                                                        onclick="return confirm('Bạn có chắc chắn muốn xóa task này?')">
                                                    <i class="fas fa-trash me-1"></i>Xóa
                                                </button>
                                            </form>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="no-tasks">
                                    <i class="fas fa-check-circle"></i>
                                    <p>Chưa có task nào được hoàn thành.</p>
                                    <small class="text-muted">Hoàn thành các task để thấy chúng ở đây!</small>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Sidebar phải -->
            <div class="col-md-3">
                <div class="right-sidebar">
                    <h5 class="mb-3"><i class="fas fa-tools"></i> Tính năng</h5>
                    
                    <!-- 1. Tạo lịch học -->
                    <div class="feature-card" onclick="window.location.href='<c:url value="/schedule"/>'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-calendar-alt text-primary fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Tạo lịch học</h6>
                                <small class="text-muted">Lên kế hoạch học tập</small>
                            </div>
                        </div>
                    </div>
                    
                    <!-- 2. Xem ghi chú -->
                    <div class="feature-card" onclick="window.location.href='<c:url value="/notes"/>'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-sticky-note text-warning fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Xem ghi chú</h6>
                                <small class="text-muted">Quản lý ghi chú cá nhân</small>
                            </div>
                        </div>
                    </div>
                    
                    <!-- 3. Xem task -->
                    <div class="feature-card active" onclick="window.location.href='<c:url value="/tasks"/>'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-list-check text-success fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Xem task</h6>
                                <small class="text-muted">Theo dõi công việc</small>
                            </div>
                        </div>
                    </div>
                    
                    <!-- 4. Thư viện tài liệu -->
                    <div class="feature-card" onclick="window.location.href='<c:url value="/documents"/>'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-book-open text-info fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Thư viện tài liệu</h6>
                                <small class="text-muted">Tài liệu học tập</small>
                            </div>
                        </div>
                    </div>
                    
                    <!-- 5. Nhóm học tập -->
                    <div class="feature-card" onclick="window.location.href='<c:url value="/rooms"/>'">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-users text-primary fa-2x me-3"></i>
                            <div>
                                <h6 class="mb-1">Nhóm học tập</h6>
                                <small class="text-muted">Tham gia nhóm học</small>
                            </div>
                        </div>
                    </div>
                    
                    
                </div>
            </div>
        </div>
    </div>
    
    <script src="${pageContext.request.contextPath}/resources/assets/js/dashboard.js"></script>
    <script>
        // Simple JavaScript - No complex classes
        function toggleEdit(taskId) {
            var form = document.getElementById('editForm-' + taskId);
            if (form.style.display === 'none' || form.style.display === '') {
                // Hide all other edit forms first
                var allForms = document.querySelectorAll('.update-form');
                for (var i = 0; i < allForms.length; i++) {
                    allForms[i].style.display = 'none';
                }
                // Show current form
                form.style.display = 'block';
            } else {
                form.style.display = 'none';
            }
        }
    </script>
</body>
</html>