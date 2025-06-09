<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html><head><title>Admin Login</title></head><body>
  <h2>Đăng nhập Admin</h2>
  <c:if test="${not empty error}">
    <div style="color:red">${error}</div>
  </c:if>
  <form method="post" action="${pageContext.request.contextPath}/admin/login">
    <input type="hidden" name="csrfToken" value="${csrfToken}"/>
    Email:    <input name="email"/><br/>
    Mật khẩu:<input type="password" name="password"/><br/>
    <button type="submit">Đăng nhập</button>
  </form>
</body></html>