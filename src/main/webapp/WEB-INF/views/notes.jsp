<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ghi chú của tôi</title>
    <link rel="stylesheet" href="<c:url value='/resources/assets/css/dashboard.css'/>">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- Header -->
        <jsp:include page="header.jsp" />

        <!-- Main Content -->
        <div class="main-content">
            <!-- Left Sidebar -->
            <jsp:include page="left_sidebar.jsp" />

            <!-- Center Content -->
            <div class="center-content">
                <div class="notes-section">
                    <h2>Ghi chú của tôi</h2>

                    <!-- Add New Note Form -->
                    <div class="post-form-container">
                        <h3>${note.noteId == 0 ? "Tạo ghi chú mới" : "Chỉnh sửa ghi chú"}</h3>
                        <form:form action="${pageContext.request.contextPath}/notes${note.noteId == 0 ? '' : '/update'}" method="post" modelAttribute="note" class="post-form">
                            <form:hidden path="noteId"/>
                            <div class="form-group">
                                <label for="title">Tiêu đề:</label>
                                <form:input path="title" id="title" class="post-input" placeholder="Nhập tiêu đề ghi chú" required="true"/>
                            </div>
                            <div class="form-group">
                                <label for="content">Nội dung:</label>
                                <form:textarea path="content" id="content" class="post-textarea" placeholder="Nhập nội dung ghi chú" rows="10"></form:textarea>
                            </div>
                            <button type="submit" class="post-button">${note.noteId == 0 ? "Thêm ghi chú" : "Cập nhật ghi chú"}</button>
                            <c:if test="${note.noteId != 0}">
                                <a href="<c:url value='/notes'/>" class="cancel-button">Hủy</a>
                            </c:if>
                        </form:form>
                    </div>

                    <!-- List of Notes -->
                    <div class="note-list">
                        <c:forEach var="noteItem" items="${notes}">
                            <div class="note-item">
                                <h3>${noteItem.title}</h3>
                                <p>${noteItem.content}</p>
                                <p>Tạo lúc: ${noteItem.createdAt}</p>
                                <p>Cập nhật lúc: ${noteItem.updatedAt}</p>
                                <div class="note-actions">
                                    <a href="<c:url value='/notes/edit/${noteItem.noteId}'/>" class="edit-button">Chỉnh sửa</a>
                                    <a href="<c:url value='/notes/delete/${noteItem.noteId}'/>" class="delete-button" onclick="return confirm('Bạn có chắc chắn muốn xóa ghi chú này không?');">Xóa</a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- Right Sidebar -->
            <jsp:include page="right_sidebar.jsp" />
        </div>
    </div>
</body>
</html> 