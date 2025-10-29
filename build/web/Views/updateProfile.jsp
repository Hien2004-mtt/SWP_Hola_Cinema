<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Models.User, java.util.Map" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Cập nhật hồ sơ</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                background-color: #f5f5f5;
            }
            .form-container {
                max-width: 500px;
                width: 100%;
                padding: 20px;
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            .error {
                color: red;
                font-size: 0.9em;
            }
            .form-label {
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <div class="form-container">
            <h2 class="text-center mb-4">Cập nhật hồ sơ</h2>
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getAttribute("message") != null) { %>
            <div class="alert alert-success"><%= request.getAttribute("message") %></div>
            <% } %>
            <% User user = (User) request.getAttribute("user"); %>
            <form action="${pageContext.request.contextPath}/updateProfile" method="post">
                <div class="mb-3">
                    <label for="email" class="form-label">Email (không thay đổi)</label>
                    <input type="email" class="form-control" id="email" value="<%= user.getEmail() %>" disabled>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Mật khẩu mới (để trống nếu không thay đổi)</label>
                    <input type="password" class="form-control" id="password" name="password">
                    <% Map<String, String> errors = (Map<String, String>) request.getAttribute("errors"); 
                   if (errors != null && errors.containsKey("password")) { %>
                    <div class="error"><%= errors.get("password") %></div>
                    <% } %>
                </div>
                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">Xác nhận mật khẩu mới</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword">
                    <% if (errors != null && errors.containsKey("confirmPassword")) { %>
                    <div class="error"><%= errors.get("confirmPassword") %></div>
                    <% } %>
                </div>
                <div class="mb-3">
                    <label for="name" class="form-label">Họ và tên</label>
                    <input type="text" class="form-control" id="name" name="name" value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : (user.getName() != null ? user.getName() : "") %>" required>
                    <% if (errors != null && errors.containsKey("name")) { %>
                    <div class="error"><%= errors.get("name") %></div>
                    <% } %>
                </div>
                <div class="mb-3">
                    <label for="phone" class="form-label">Số điện thoại</label>
                    <input type="text" class="form-control" id="phone" name="phone" value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : (user.getPhone() != null ? user.getPhone() : "") %>">
                    <% if (errors != null && errors.containsKey("phone")) { %>
                    <div class="error"><%= errors.get("phone") %></div>
                    <% } %>
                </div>
                <div class="mb-3">
                    <label for="dob" class="form-label">Ngày sinh</label>
                    <input type="date" class="form-control" id="dob" name="dob" value="<%= request.getAttribute("dob") != null ? request.getAttribute("dob") : (user.getDob() != null ? user.getDob().toString() : "") %>">
                    <% if (errors != null && errors.containsKey("dob")) { %>
                    <div class="error"><%= errors.get("dob") %></div>
                    <% } %>
                </div>
                <div class="mb-3">
                    <label class="form-label">Giới tính</label>
                    <div class="form-check">
                        <input type="radio" class="form-check-input" id="male" name="gender" value="1" <%= (request.getAttribute("gender") != null ? request.getAttribute("gender") : (user.isGender() ? "1" : "0")).equals("1") ? "checked" : "" %> required>
                        <label class="form-check-label" for="male">Nam</label>
                    </div>
                    <div class="form-check">
                        <input type="radio" class="form-check-input" id="female" name="gender" value="0" <%= (request.getAttribute("gender") != null ? request.getAttribute("gender") : (user.isGender() ? "1" : "0")).equals("0") ? "checked" : "" %>>
                        <label class="form-check-label" for="female">Nữ</label>
                    </div>
                    <% if (errors != null && errors.containsKey("gender")) { %>
                    <div class="error"><%= errors.get("gender") %></div>
                    <% } %>
                </div>
                <button type="submit" class="btn btn-primary w-100">Cập nhật</button>
            </form>
            <p class="text-center mt-3"><a href="home" class="btn btn-secondary">Quay về trang chủ</a></p>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>