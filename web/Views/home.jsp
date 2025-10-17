<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Models.User" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trang chủ</title>
        <!-- Bootstrap CSS CDN -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f5f5f5;
            }
            .container {
                max-width: 800px;
                margin-top: 50px;
            }
            .welcome-card {
                background-color: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
        </style>
    </head>
    <body>
        <div class="container">
            <div class="welcome-card">
                <% 
                    User user = (User) request.getAttribute("user");
                    if (user == null) {
                        response.sendRedirect("login");
                        return;
                    }
                %>
                <h2 class="text-center mb-4">Chào mừng, <%= user.getName() %>!</h2>
                <p><strong>Email:</strong> <%= user.getEmail() %></p>
                <p><strong>Vai trò:</strong> 
                    <% 
                        switch (user.getRole()) {
                            case 0: out.print("Admin"); break;
                            case 1: out.print("Nhân viên"); break;
                            case 2: out.print("Khách hàng"); break;
                            default: out.print("Không xác định");
                        }
                    %>
                </p>
                <div class="d-flex justify-content-center gap-2 mt-3">
                    <a href="${pageContext.request.contextPath}/updateProfile" class="btn btn-primary">Cập nhật hồ sơ</a>
                    <a href="logout" class="btn btn-danger">Đăng xuất</a>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS CDN -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>