<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Đăng nhập</title>
    <link href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="card mx-auto" style="max-width: 450px;">
        <div class="card-header bg-success text-white text-center">Đăng nhập</div>
        <div class="card-body">
            <% if (session.getAttribute("error") != null) { %>
                <div class="alert alert-danger" role="alert">
                    <%= session.getAttribute("error") %>
                </div>
                <% session.removeAttribute("error"); %>
            <% } %>
            <form action="${pageContext.request.contextPath}/user/login" method="post">
                <div class="form-group mb-3">
                    <label>Tên đăng nhập</label>
                    <input type="text" name="username" class="form-control" required/>
                </div>
                <div class="form-group mb-3">
                    <label>Mật khẩu</label>
                    <input type="password" name="password" class="form-control" required/>
                </div>
                <button type="submit" class="btn btn-primary w-100">Đăng nhập</button>
                <p class="mt-3 text-center"><a href="${pageContext.request.contextPath}/user/register">Chưa có tài khoản?</a></p>
            </form>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/resources/js/bootstrap.bundle.min.js"></script>
</body>
</html>