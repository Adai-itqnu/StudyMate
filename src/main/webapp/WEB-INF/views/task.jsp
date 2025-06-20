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
	<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/task.css"/>
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
                   
                </div>
                <div class="col-md-3">
                    
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