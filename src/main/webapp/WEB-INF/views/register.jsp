<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Đăng ký tài khoản</title>
    <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="card mx-auto" style="max-width: 500px;">
        <div class="card-header bg-primary text-white text-center">Đăng ký tài khoản</div>
        <div class="card-body">
            <% if (session.getAttribute("error") != null) { %>
                <div class="alert alert-danger" role="alert">
                    <%= session.getAttribute("error") %>
                </div>
                <% session.removeAttribute("error"); %>
            <% } %>
            <% if (session.getAttribute("message") != null) { %>
                <div class="alert alert-success" role="alert">
                    <%= session.getAttribute("message") %>
                </div>
                <% session.removeAttribute("message"); %>
            <% } %>
            <form action="${pageContext.request.contextPath}/user/register" method="post">
                <div class="form-group mb-3">
                    <label>Họ và tên</label>
                    <input type="text" name="fullName" class="form-control" required/>
                </div>
                <div class="form-group mb-3">
                    <label>Tên đăng nhập</label>
                    <input type="text" name="username" class="form-control" required/>
                </div>
                <div class="form-group mb-3">
                    <label>Email</label>
                    <input type="email" name="email" class="form-control" required/>
                </div>
                <div class="form-group mb-3">
                    <label>Mật khẩu</label>
                    <input type="password" name="password" class="form-control" required/>
                </div>
                <button type="submit" class="btn btn-success w-100">Đăng ký</button>
                <p class="mt-3 text-center"><a href="${pageContext.request.contextPath}/user/login">Đã có tài khoản?</a></p>
            </form>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
</body>
</html>