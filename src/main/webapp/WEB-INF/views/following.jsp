<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Danh sách người bạn theo dõi</title>
    <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body>
<div class="container mt-5">
    <div class="card">
        <div class="card-header bg-secondary text-white">
            Danh sách người bạn theo dõi
        </div>
        <div class="card-body">
            <c:if test="${not empty following}">
                <ul class="list-group">
                    <c:forEach var="followed" items="${following}">
                        <li class="list-group-item">${followed.fullName} (${followed.username})</li>
                    </c:forEach>
                </ul>
            </c:if>
            <c:if test="${empty following}">
                <p>Bạn chưa theo dõi ai.</p>
            </c:if>
            <a href="${pageContext.request.contextPath}/user/dashboard" class="btn btn-secondary mt-2">Quay lại</a>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
</body>
</html>