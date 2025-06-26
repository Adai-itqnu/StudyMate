<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>StudyMate - Quản lý Lịch học</title>
    <link href="<c:url value='/assets/css/bootstrap.min.css'/>" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/dashboard.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/schedule.css"/>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="container-fluid">
            <div class="row align-items-center py-3">
                <!-- Logo/Trang chủ -->
                <div class="col-md-3">
                    <a href="<c:url value='/dashboard'/>" class="text-decoration-none">
                        <h4 class="mb-0 text-primary">
                            <i class="fas fa-graduation-cap"></i> StudyMate
                        </h4>
                    </a>
                </div>
                
                <!-- Ô tìm kiếm (Đã bỏ) -->
                <div class="col-md-6 text-center">
                    <%-- Phần tìm kiếm đã bị loại bỏ theo yêu cầu --%>
                </div>
                
                <!-- User info -->
                <div class="col-md-3">
                    
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container-fluid">
        <div class="row">
            <!-- Left Sidebar - Gợi ý người dùng -->
            <div class="col-md-3">
                <div class="sidebar">
                    <h5 class="mb-3">
                        <i class="fas fa-users"></i> Gợi ý theo dõi
                    </h5>
                    
                    <c:forEach var="suggestion" items="${suggestions}">
                        <div class="suggestion-card">
                            <div class="d-flex align-items-center">
                                <img src="${suggestion.avatarUrl != null ? suggestion.avatarUrl : '/assets/images/default-avatar.png'}" 
                                     alt="Avatar" class="avatar me-3">
                                <div class="flex-grow-1">
                                    <h6 class="mb-1">${suggestion.fullName}</h6>
                                    <small class="text-muted">@${suggestion.username}</small>
                                </div>
                            </div>
                            <div class="mt-2">
                                <button class="btn btn-primary btn-sm me-2" 
                                        onclick="followUser(${suggestion.userId})">
                                    <i class="fas fa-plus"></i> Theo dõi
                                </button>
                                <a href="<c:url value='/profile/${suggestion.userId}'/>" 
                                   class="btn btn-outline-secondary btn-sm">
                                    Xem trang
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Main Content Area: Quản lý lịch học -->
            <div class="col-md-6">
                <div class="main-content">
                    <h2 class="page-title">
                        <i class="fas fa-calendar-alt"></i> Quản lý Lịch học
                    </h2>

                    <c:if test="${not empty error}">
                        <div class="error">
                            <i class="fas fa-exclamation-circle me-2"></i>${error}
                        </div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="success">
                            <i class="fas fa-check-circle me-2"></i>${success}
                        </div>
                    </c:if>

                    <div class="add-schedule-form">
                        <h5 class="mb-3">
                            <i class="fas fa-plus-circle"></i> Thêm Lịch học mới
                        </h5>
                        <form method="post" action="${pageContext.request.contextPath}/schedule/add">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <input type="text" name="subject" class="form-control" placeholder="Môn học" required>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <input type="text" name="room" class="form-control" placeholder="Phòng" required>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <select name="dayOfWeek" class="form-control" required>
                                        <option value="">Chọn thứ</option>
                                        <option value="1">Thứ 2</option>
                                        <option value="2">Thứ 3</option>
                                        <option value="3">Thứ 4</option>
                                        <option value="4">Thứ 5</option>
                                        <option value="5">Thứ 6</option>
                                        <option value="6">Thứ 7</option>
                                        <option value="7">chủ nhật</option>
                                    </select>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <input type="time" name="startTime" class="form-control" placeholder="Bắt đầu" required>
                                </div>
                                <div class="col-md-3 mb-3">
                                    <input type="time" name="endTime" class="form-control" placeholder="Kết thúc" required>
                                </div>
                                <div class="col-md-2 mb-3">
                                    <button type="submit" class="btn btn-purple w-100">
                                        <i class="fas fa-plus"></i> Thêm
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>

                    <div class="schedule-section">
                        <h5 class="mb-3">
                            <i class="fas fa-table"></i> Lịch học trong tuần
                        </h5>
                        <div class="table-responsive">
                            <table class="schedule-table">
                                <thead>
                                    <tr>
                                        <th>Thời gian</th>
                                        <th>Thứ 2</th>
                                        <th>Thứ 3</th>
                                        <th>Thứ 4</th>
                                        <th>Thứ 5</th>
                                        <th>Thứ 6</th>
                                        <th>Thứ 7</th>
                                        <th>Chủ nhật</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="time-slot-header">7:00-12:00</td>
                                        <c:forEach var="day" items="${weeklyGrid}">
                                            <td>
                                                <c:forEach var="schedule" items="${day.value}">
                                                    <c:if test="${schedule.startTime.toString().substring(0,2) >= '07' && schedule.startTime.toString().substring(0,2) < '12'}">
                                                        <div class="schedule-item">
                                                            <strong>${schedule.subject}</strong>
                                                            <div>${schedule.startTime.toString().substring(0,5)} - ${schedule.endTime.toString().substring(0,5)}</div>
                                                            <div>Phòng: ${schedule.room}</div>
                                                            <div class="mt-2">
                                                                
                                                                <button class="btn btn-sm btn-danger" onclick="deleteSchedule(${schedule.scheduleId})">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                </c:forEach>
                                            </td>
                                        </c:forEach>
                                    </tr>
                                    <tr>
                                        <td class="time-slot-header">12:00-17:00</td>
                                        <c:forEach var="day" items="${weeklyGrid}">
                                            <td>
                                                <c:forEach var="schedule" items="${day.value}">
                                                    <c:if test="${schedule.startTime.toString().substring(0,2) >= '12' && schedule.startTime.toString().substring(0,2) < '17'}">
                                                        <div class="schedule-item">
                                                            <strong>${schedule.subject}</strong>
                                                            <div>${schedule.startTime.toString().substring(0,5)} - ${schedule.endTime.toString().substring(0,5)}</div>
                                                            <div>Phòng: ${schedule.room}</div>
                                                            <div class="mt-2">
                                                                
                                                                <button class="btn btn-sm btn-danger" onclick="deleteSchedule(${schedule.scheduleId})">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                </c:forEach>
                                            </td>
                                        </c:forEach>
                                    </tr>
                                    <tr>
                                        <td class="time-slot-header">17:00-22:00</td>
                                        <c:forEach var="day" items="${weeklyGrid}">
                                            <td>
                                                <c:forEach var="schedule" items="${day.value}">
                                                    <c:if test="${schedule.startTime.toString().substring(0,2) >= '17' && schedule.startTime.toString().substring(0,2) <= '22'}">
                                                        <div class="schedule-item">
                                                            <strong>${schedule.subject}</strong>
                                                            <div>${schedule.startTime.toString().substring(0,5)} - ${schedule.endTime.toString().substring(0,5)}</div>
                                                            <div>Phòng: ${schedule.room}</div>
                                                            <div class="mt-2">
                                                                
                                                                <button class="btn btn-sm btn-danger" onclick="deleteSchedule(${schedule.scheduleId})">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                </c:forEach>
                                            </td>
                                        </c:forEach>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Sidebar - Features -->
            <div class="col-md-3">
                <div class="right-sidebar">
                    <h5 class="mb-3">
                        <i class="fas fa-tools"></i> Tính năng
                    </h5>
                    
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
                    <div class="feature-card" onclick="window.location.href='<c:url value="/tasks"/>'">
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

    <!-- Modal -->
    <div id="scheduleModal" class="modal">
        <div class="modal-content">
            <h4 id="modalTitle">
                <i class="fas fa-calendar-plus"></i> Thêm Lịch học
            </h4>
            <form id="scheduleForm" method="post" action="${pageContext.request.contextPath}/schedule/add">
                <input type="hidden" name="scheduleId" id="scheduleId" value="">
                <div class="form-group">
                    <label for="modalSubject">
                        <i class="fas fa-book"></i> Môn học
                    </label>
                    <input type="text" name="subject" id="modalSubject" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="modalRoom">
                        <i class="fas fa-door-open"></i> Phòng
                    </label>
                    <input type="text" name="room" id="modalRoom" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="modalDayOfWeek">
                        <i class="fas fa-calendar-day"></i> Thứ
                    </label>
                    <select name="dayOfWeek" id="modalDayOfWeek" class="form-control" required>
                        <option value="">Chọn thứ</option>
                        <option value="1">Chủ nhật</option>
                        <option value="2">Thứ 2</option>
                        <option value="3">Thứ 3</option>
                        <option value="4">Thứ 4</option>
                        <option value="5">Thứ 5</option>
                        <option value="6">Thứ 6</option>
                        <option value="7">Thứ 7</option>
                    </select>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="modalStartTime">
                                <i class="fas fa-clock"></i> Thời gian bắt đầu
                            </label>
                            <input type="time" name="startTime" id="modalStartTime" class="form-control" required>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label for="modalEndTime">
                                <i class="fas fa-clock"></i> Thời gian kết thúc
                            </label>
                            <input type="time" name="endTime" id="modalEndTime" class="form-control" required>
                        </div>
                    </div>
                </div>
                <div class="text-end">
                    <button type="submit" class="btn btn-purple me-2">
                        <i class="fas fa-save"></i> Lưu
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">
                        <i class="fas fa-times"></i> Hủy
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script src="<c:url value='/assets/js/bootstrap.bundle.min.js'/>"></script>
    <script src="${pageContext.request.contextPath}/resources/assets/js/dashboard.js"></script>
    <script>
 // schedule.js - Quản lý Lịch học JavaScript

    document.addEventListener('DOMContentLoaded', function() {
        initializeSchedulePage();
    });

    function initializeSchedulePage() {
        // Force time inputs to 24-hour format
        document.querySelectorAll('input[type="time"]').forEach(input => {
            input.addEventListener('click', () => {
                if (input.showPicker) {
                    input.showPicker();
                }
            });
        });

        // Initialize form validation
        initializeFormValidation();
        
        // Initialize modal event handlers
        initializeModalHandlers();
    }

    function initializeFormValidation() {
        // Client-side validation for add/update forms
        document.querySelectorAll('form[action*="/schedule/add"], form[action*="/schedule/update"]').forEach(form => {
            form.addEventListener('submit', function(event) {
                if (!validateScheduleForm(this)) {
                    event.preventDefault();
                    return false;
                }
            });
        });
    }

    function validateScheduleForm(form) {
        const subject = form.querySelector('input[name="subject"]');
        const room = form.querySelector('input[name="room"]');
        const dayOfWeek = form.querySelector('select[name="dayOfWeek"]');
        const startTime = form.querySelector('input[name="startTime"]');
        const endTime = form.querySelector('input[name="endTime"]');

        // Reset previous error styles
        clearFormErrors(form);

        let isValid = true;
        let errorMessages = [];

        // Validate subject
        if (!subject.value.trim()) {
            showFieldError(subject, 'Vui lòng nhập môn học');
            errorMessages.push('Môn học không được để trống');
            isValid = false;
        }

        // Validate room
        if (!room.value.trim()) {
            showFieldError(room, 'Vui lòng nhập phòng học');
            errorMessages.push('Phòng học không được để trống');
            isValid = false;
        }

        // Validate day of week
        if (!dayOfWeek.value) {
            showFieldError(dayOfWeek, 'Vui lòng chọn thứ');
            errorMessages.push('Vui lòng chọn thứ trong tuần');
            isValid = false;
        }

        // Validate start time
        if (!startTime.value) {
            showFieldError(startTime, 'Vui lòng chọn thời gian bắt đầu');
            errorMessages.push('Thời gian bắt đầu không được để trống');
            isValid = false;
        }

        // Validate end time
        if (!endTime.value) {
            showFieldError(endTime, 'Vui lòng chọn thời gian kết thúc');
            errorMessages.push('Thời gian kết thúc không được để trống');
            isValid = false;
        }

        // Validate time range
        if (startTime.value && endTime.value) {
            if (startTime.value >= endTime.value) {
                showFieldError(endTime, 'Thời gian kết thúc phải sau thời gian bắt đầu');
                errorMessages.push('Thời gian kết thúc phải sau thời gian bắt đầu');
                isValid = false;
            }

            // Check if duration is reasonable (at least 30 minutes, max 6 hours)
            const start = new Date('2000-01-01 ' + startTime.value);
            const end = new Date('2000-01-01 ' + endTime.value);
            const durationMinutes = (end - start) / (1000 * 60);

            if (durationMinutes < 30) {
                showFieldError(endTime, 'Thời lượng học tối thiểu là 30 phút');
                errorMessages.push('Thời lượng học tối thiểu là 30 phút');
                isValid = false;
            }

            if (durationMinutes > 360) { // 6 hours
                showFieldError(endTime, 'Thời lượng học tối đa là 6 giờ');
                errorMessages.push('Thời lượng học tối đa là 6 giờ');
                isValid = false;
            }
        }

        // Show error messages if validation failed
        if (!isValid) {
            showErrorMessage('Vui lòng kiểm tra lại thông tin:\n• ' + errorMessages.join('\n• '));
        }

        return isValid;
    }

    function showFieldError(field, message) {
        field.style.borderColor = '#dc3545';
        field.style.boxShadow = '0 0 0 0.2rem rgba(220, 53, 69, 0.25)';
        
        // Add error message if not exists
        let errorDiv = field.parentNode.querySelector('.error-message');
        if (!errorDiv) {
            errorDiv = document.createElement('div');
            errorDiv.className = 'error-message text-danger small mt-1';
            field.parentNode.appendChild(errorDiv);
        }
        errorDiv.textContent = message;
    }

    function clearFormErrors(form) {
        // Reset field styles
        form.querySelectorAll('input, select').forEach(field => {
            field.style.borderColor = '';
            field.style.boxShadow = '';
        });
        
        // Remove error messages
        form.querySelectorAll('.error-message').forEach(error => {
            error.remove();
        });
    }

    function showErrorMessage(message) {
        alert(message);
    }

    function showSuccessMessage(message) {
        // Create and show success notification
        const notification = document.createElement('div');
        notification.className = 'alert alert-success alert-dismissible fade show position-fixed';
        notification.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
        notification.innerHTML = `
            <i class="fas fa-check-circle me-2"></i>${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;
        
        document.body.appendChild(notification);
        
        // Auto remove after 5 seconds
        setTimeout(() => {
            if (notification.parentNode) {
                notification.remove();
            }
        }, 5000);
    }

    function editSchedule(scheduleId) {
        console.log('Fetching schedule with ID:', scheduleId);
        
        // Show loading state
        showLoadingModal();
        
        // Get context path from the page
        const contextPath = getContextPath();
        
        fetch(contextPath + '/schedule/' + scheduleId)
            .then(response => {
                console.log('Response status:', response.status);
                if (!response.ok) {
                    throw new Error('Network response was not ok: ' + response.statusText);
                }
                return response.json();
            })
            .then(data => {
                console.log('Received data:', data);
                hideLoadingModal();
                
                if (data.error) {
                    showErrorMessage('Lỗi: ' + data.error);
                    return;
                }
                
                // Populate modal with data
                populateEditModal(data);
                showModal();
            })
            .catch(error => {
                console.error('Error fetching schedule:', error);
                hideLoadingModal();
                showErrorMessage('Không thể tải thông tin lịch học. Vui lòng thử lại.');
            });
    }

    function populateEditModal(data) {
        document.getElementById('modalTitle').innerHTML = '<i class="fas fa-edit"></i> Sửa Lịch học';
        document.getElementById('scheduleForm').action = getContextPath() + '/schedule/update';
        document.getElementById('scheduleId').value = data.scheduleId || '';
        document.getElementById('modalSubject').value = data.subject || '';
        document.getElementById('modalRoom').value = data.room || '';
        document.getElementById('modalDayOfWeek').value = data.dayOfWeek || '';
        document.getElementById('modalStartTime').value = data.startTime || '';
        document.getElementById('modalEndTime').value = data.endTime || '';
    }

    function deleteSchedule(scheduleId) {
        // Custom confirmation dialog
        if (showConfirmDialog('Bạn có chắc muốn xóa lịch học này?', 'Xóa lịch học')) {
            const form = document.createElement('form');
            form.method = 'post';
            form.action = getContextPath() + '/schedule/delete';
            form.innerHTML = '<input type="hidden" name="scheduleId" value="' + scheduleId + '">';
            form.style.display = 'none';
            
            document.body.appendChild(form);
            form.submit();
        }
    }

    function showConfirmDialog(message, title = 'Xác nhận') {
        return confirm(message); // Can be replaced with custom modal later
    }

    function showModal() {
        const modal = document.getElementById('scheduleModal');
        if (modal) {
            modal.style.display = 'block';
            // Add fade-in effect
            modal.style.opacity = '0';
            setTimeout(() => {
                modal.style.opacity = '1';
            }, 10);
        }
    }

    function closeModal() {
        const modal = document.getElementById('scheduleModal');
        if (modal) {
            // Add fade-out effect
            modal.style.opacity = '0';
            setTimeout(() => {
                modal.style.display = 'none';
                resetModalForm();
            }, 150);
        }
    }

    function resetModalForm() {
        const form = document.getElementById('scheduleForm');
        if (form) {
            form.action = getContextPath() + '/schedule/add';
            document.getElementById('modalTitle').innerHTML = '<i class="fas fa-calendar-plus"></i> Thêm Lịch học';
            document.getElementById('scheduleId').value = '';
            document.getElementById('modalSubject').value = '';
            document.getElementById('modalRoom').value = '';
            document.getElementById('modalDayOfWeek').value = '';
            document.getElementById('modalStartTime').value = '';
            document.getElementById('modalEndTime').value = '';
            
            // Clear any validation errors
            clearFormErrors(form);
        }
    }

    function initializeModalHandlers() {
        // Close modal when clicking outside
        window.addEventListener('click', function(event) {
            const modal = document.getElementById('scheduleModal');
            if (event.target === modal) {
                closeModal();
            }
        });

        // Close modal with Escape key
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                const modal = document.getElementById('scheduleModal');
                if (modal && modal.style.display === 'block') {
                    closeModal();
                }
            }
        });
    }

    function showLoadingModal() {
        // Create loading overlay if not exists
        let loadingOverlay = document.getElementById('loadingOverlay');
        if (!loadingOverlay) {
            loadingOverlay = document.createElement('div');
            loadingOverlay.id = 'loadingOverlay';
            loadingOverlay.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 9999;
            `;
            loadingOverlay.innerHTML = `
                <div style="background: white; padding: 20px; border-radius: 8px; text-align: center;">
                    <i class="fas fa-spinner fa-spin fa-2x text-primary mb-2"></i>
                    <div>Đang tải...</div>
                </div>
            `;
            document.body.appendChild(loadingOverlay);
        }
        loadingOverlay.style.display = 'flex';
    }

    function hideLoadingModal() {
        const loadingOverlay = document.getElementById('loadingOverlay');
        if (loadingOverlay) {
            loadingOverlay.style.display = 'none';
        }
    }

    function getContextPath() {
        // Try to get context path from page context or meta tag
        const metaContextPath = document.querySelector('meta[name="context-path"]');
        if (metaContextPath) {
            return metaContextPath.content;
        }
        
        // Fallback: try to extract from current script or page
        const scripts = document.getElementsByTagName('script');
        for (let script of scripts) {
            if (script.src && script.src.includes('/resources/')) {
                const parts = script.src.split('/resources/');
                if (parts.length > 1) {
                    const contextPath = parts[0].substring(parts[0].lastIndexOf('/', parts[0].length - 1));
                    return contextPath === '/' ? '' : contextPath;
                }
            }
        }
        
        // Final fallback
        return window.location.pathname.split('/')[1] ? '/' + window.location.pathname.split('/')[1] : '';
    }

    // Utility functions for schedule management
    function formatTime(timeString) {
        if (!timeString) return '';
        return timeString.substring(0, 5); // HH:MM format
    }

    function formatDayOfWeek(dayNumber) {
        const days = {
            1: 'Chủ nhật',
            2: 'Thứ 2', 
            3: 'Thứ 3',
            4: 'Thứ 4',
            5: 'Thứ 5',
            6: 'Thứ 6',
            7: 'Thứ 7'
        };
        return days[dayNumber] || '';
    }

    function isTimeInRange(time, startRange, endRange) {
        const timeNum = parseInt(time.replace(':', ''));
        const startNum = parseInt(startRange.replace(':', ''));
        const endNum = parseInt(endRange.replace(':', ''));
        return timeNum >= startNum && timeNum < endNum;
    }

    // Export functions for global access
    window.editSchedule = editSchedule;
    window.deleteSchedule = deleteSchedule;
    window.closeModal = closeModal;
    window.showModal = showModal;
    
    </script>
    </body>
    </html>