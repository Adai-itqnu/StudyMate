<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html><head><title>Admin Dashboard</title></head><body>
  <h2>Chào, Admin ${sessionScope.adminUser.fullName}</h2>
  <a href="${pageContext.request.contextPath}/logout">Đăng xuất</a>

  <h3>Quản lý Người dùng</h3>
  <table border="1">
    <tr><th>ID</th><th>Username</th><th>Email</th><th>Role</th><th>Action</th></tr>
    <c:forEach var="u" items="${users}">
      <tr>
        <td>${u.userId}</td>
        <td><c:out value="${u.username}"/></td>
        <td><c:out value="${u.email}"/></td>
        <td>${u.role}</td>
        <td><a href="${pageContext.request.contextPath}/admin/user/delete?userId=${u.userId}">Xóa</a></td>
      </tr>
    </c:forEach>
  </table>

  <h3>Báo cáo</h3>
  <table border="1">
    <tr><th>Report ID</th><th>Post ID</th><th>Reporter ID</th><th>Reason</th><th>Action</th></tr>
    <c:forEach var="r" items="${reports}">
      <tr>
        <td>${r.reportId}</td>
        <td>${r.reportedPostId}</td>
        <td>${r.reporterId}</td>
        <td><c:out value="${r.reason}"/></td>
        <td><a href="${pageContext.request.contextPath}/admin/report/delete?reportId=${r.reportId}">Xóa</a></td>
      </tr>
    </c:forEach>
  </table>
</body></html>
