<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tài liệu học tập</title>
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
                <div class="documents-section">
                    <h2>Tài liệu học tập</h2>
                    <a href="<c:url value='/documents/upload'/>" class="upload-document-button">Tải lên tài liệu mới</a>
                    <div class="document-list">
                        <c:forEach var="document" items="${documents}">
                            <div class="document-item">
                                <h3>${document.title}</h3>
                                <p>${document.description}</p>
                                <p>Ngày tải lên: ${document.uploadDate}</p>
                                <a href="${document.fileUrl}" target="_blank">Xem tài liệu</a>
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