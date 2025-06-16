<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo phòng học tập mới</title>
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
                <div class="create-room-section post-form-container">
                    <h2>Tạo phòng học tập mới</h2>
                    <form:form action="${pageContext.request.contextPath}/rooms" method="post" modelAttribute="room" class="post-form">
                        <div class="form-group">
                            <label for="roomName">Tên phòng:</label>
                            <form:input path="roomName" id="roomName" class="post-input" placeholder="Nhập tên phòng" required="true"/>
                        </div>
                        <div class="form-group">
                            <label for="description">Mô tả:</label>
                            <form:textarea path="description" id="description" class="post-textarea" placeholder="Mô tả phòng" rows="5"></form:textarea>
                        </div>
                        <button type="submit" class="post-button">Tạo phòng</button>
                    </form:form>
                </div>
            </div>

            <!-- Right Sidebar -->
            <jsp:include page="right_sidebar.jsp" />
        </div>
    </div>
</body>
</html> 