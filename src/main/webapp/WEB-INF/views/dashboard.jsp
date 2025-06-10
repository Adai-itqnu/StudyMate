<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard – StudyMate</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/assets/css/dashboard.css"/>
</head>
<body>
  <!-- Navbar -->
  <nav class="navbar navbar-expand-lg navbar-light bg-light px-4">
    <a class="navbar-brand" href="<c:url value='/'/>">StudyMate</a>
    <form class="d-flex mx-auto" action="<c:url value='/search'/>" method="get">
      <input class="form-control me-2" name="q" type="search" placeholder="Tìm kiếm bài viết hoặc người dùng"/>
      <button class="btn btn-outline-success" type="submit">Tìm</button>
    </form>
    <div class="dropdown">
      <a class="d-flex align-items-center text-decoration-none dropdown-toggle" href="#" id="userMenu" data-bs-toggle="dropdown">
        <c:choose>
          <c:when test="${not empty sessionScope.currentUser.avatarUrl}">
            <img src="${sessionScope.currentUser.avatarUrl}" class="avatar-sm me-2"/>
          </c:when>
          <c:otherwise>
            <img src="<c:url value='/assets/images/default-avatar.png'/>" class="avatar-sm me-2"/>
          </c:otherwise>
        </c:choose>
        <span>${sessionScope.currentUser.fullName}</span>
      </a>
      <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userMenu">
        <li><a class="dropdown-item" href="<c:url value='/profile'/>">Trang cá nhân</a></li>
        <li><a class="dropdown-item" href="<c:url value='/profile/edit'/>">Chỉnh sửa thông tin</a></li>
        <li><a class="dropdown-item" href="<c:url value='/profile/change-password'/>">Đổi mật khẩu</a></li>
        <li><hr class="dropdown-divider"/></li>
        <li><a class="dropdown-item" href="<c:url value='/logout'/>">Đăng xuất</a></li>
      </ul>
    </div>
  </nav>

  <div class="container-fluid mt-4">
    <div class="row">
      <!-- Sidebar trái -->
      <div class="col-md-3 sidebar">
        <h5>Gợi ý theo dõi</h5>
        <c:forEach var="u" items="${suggestions}">
          <div class="d-flex align-items-center mb-2">
            <img src="${u.avatarUrl}" class="avatar-sm me-2"/>
            <div>
              <strong>${u.username}</strong><br/>
              <small>${u.fullName}</small>
            </div>
            <form action="<c:url value='/follow'/>" method="post" class="ms-auto">
              <input type="hidden" name="userId" value="${u.userId}"/>
              <button type="submit" class="btn btn-sm btn-primary">Theo dõi</button>
            </form>
          </div>
        </c:forEach>
      </div>

      <!-- Cột giữa -->
      <div class="col-md-6">
        <!-- Form đăng bài mới -->
        <div class="card mb-4">
          <div class="card-body">
          
            <form action="<c:url value='/posts/create'/>" method="post" enctype="multipart/form-data">
              <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}"/>
              <div class="mb-3">
                <input type="text" name="title" class="form-control" placeholder="Tiêu đề" required/>
              </div>
              <div class="mb-3">
                <textarea name="body" class="form-control" rows="3" placeholder="Bạn đang nghĩ gì?" required></textarea>
              </div>
              <div class="mb-3">
                <input type="file" name="attachment" class="form-control"/>
              </div>
              <div class="d-flex justify-content-between">
                <select name="privacy" class="form-select w-auto">
                  <option value="PUBLIC">Công khai</option>
                  <option value="FOLLOWERS">Chỉ người theo dõi</option>
                  <option value="PRIVATE">Chỉ mình tôi</option>
                </select>
                <button type="submit" class="btn btn-primary">Đăng</button>
              </div>
            </form>
          </div>
        </div>

        <!-- Danh sách bài viết -->
        <c:forEach var="p" items="${posts}">
          <div class="card post-card">
            <div class="card-header d-flex align-items-center">
              <img src="${p.user.avatarUrl}" class="avatar-sm me-2"/>
              <div>
                <strong>${p.user.fullName}</strong><br/>
                <small class="text-muted"><fmt:formatDate value="${p.createdAt}" pattern="dd/MM/yyyy HH:mm"/></small>
              </div>
            </div>
            <div class="card-body">
              <h5 class="card-title">${p.title}</h5>
              <p class="card-text">${p.body}</p>
              <c:if test="${not empty p.attachments}">
                <div class="mt-2">
                  <c:forEach var="att" items="${p.attachments}">
                    <c:choose>
                      <c:when test="${att.fileType=='IMAGE'}">
                        <img src="${att.fileUrl}" class="img-fluid mb-2"/>
                      </c:when>
                      <c:otherwise>
                        <a href="${att.fileUrl}" target="_blank">Tải file</a>
                      </c:otherwise>
                    </c:choose>
                  </c:forEach>
                </div>
              </c:if>
              <!-- Like, comment, share -->
              <div class="mt-3">
                <form action="<c:url value='/like'/>" method="post" class="d-inline">
                  <input type="hidden" name="postId" value="${p.postId}"/>
                  <button type="submit" class="btn btn-sm btn-outline-primary">
                    Like (${p.likeCount})
                  </button>
                </form>
                <button class="btn btn-sm btn-outline-secondary" type="button" data-bs-toggle="collapse" data-bs-target="#comments-${p.postId}">
                  Bình luận (${p.commentCount})
                </button>
                <form action="<c:url value='/share'/>" method="post" class="d-inline ms-2">
                  <input type="hidden" name="postId" value="${p.postId}"/>
                  <button type="submit" class="btn btn-sm btn-outline-success">Chia sẻ</button>
                </form>
                <!-- Comments collapse -->
                <div class="collapse mt-2" id="comments-${p.postId}">
                  <c:forEach var="cmt" items="${p.comments}">
                    <div class="border p-2 mb-1">
                      <strong>${cmt.user.fullName}:</strong> ${cmt.content}
                    </div>
                  </c:forEach>
                  <form action="<c:url value='/comment'/>" method="post">
                    <div class="input-group">
                      <input type="hidden" name="postId" value="${p.postId}"/>
                      <input type="text" name="content" class="form-control" placeholder="Viết bình luận" required/>
                      <button class="btn btn-primary" type="submit">Gửi</button>
                    </div>
                  </form>
                </div>
              </div>
            </div>
          </div>
        </c:forEach>
      </div>

      <!-- Sidebar phải -->
      <div class="col-md-3 sidebar">
        <h5>Chức năng nhanh</h5>
        <ul class="list-group">
          <li class="list-group-item"><a href="<c:url value='/schedule'/>">Thời khóa biểu</a></li>
          <li class="list-group-item"><a href="<c:url value='/notes'/>">Ghi chú</a></li>
          <li class="list-group-item"><a href="<c:url value='/tasks'/>">Task</a></li>
          <li class="list-group-item"><a href="<c:url value='/documents'/>">Tài liệu</a></li>
        </ul>
      </div>
    </div>
  </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script>
        // Add smooth scrolling
        document.addEventListener('DOMContentLoaded', function() {
            // File upload preview
            const fileInput = document.getElementById('file-upload');
            const fileLabel = document.querySelector('.file-upload-label');
            
            fileInput.addEventListener('change', function(e) {
                if (e.target.files.length > 0) {
                    const fileName = e.target.files[0].name;
                    fileLabel.innerHTML = `<i class="fas fa-check-circle me-2"></i>Đã chọn: ${fileName}`;
                    fileLabel.style.background = 'rgba(34, 197, 94, 0.2)';
                    fileLabel.style.borderColor = 'rgba(34, 197, 94, 0.5)';
                    fileLabel.style.color = '#22c55e';
                } else {
                    fileLabel.innerHTML = '<i class="fas fa-cloud-upload-alt me-2"></i>Thêm hình ảnh hoặc tệp đính kèm';
                    fileLabel.style.background = 'rgba(255,255,255,0.1)';
                    fileLabel.style.borderColor = 'rgba(255,255,255,0.3)';
                    fileLabel.style.color = 'rgba(255,255,255,0.7)';
                }
            });

            // Add stagger animation to cards
            const cards = document.querySelectorAll('.glass-card');
            cards.forEach((card, index) => {
                card.style.animationDelay = `${index * 0.1}s`;
            });

            // Add parallax effect to particles
            window.addEventListener('scroll', () => {
                const scrolled = window.pageYOffset;
                const particles = document.querySelectorAll('.particle');
                
                particles.forEach((particle, index) => {
                    const speed = (index + 1) * 0.5;
                    particle.style.transform = `translateY(${scrolled * speed}px)`;
                });
            });
        });
    </script>
</body>
</html>