<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập nhật thành công</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { display: flex; justify-content: center; align-items: center; min-height: 100vh; background-color: #f5f5f5; }
        .success-container { max-width: 500px; width: 100%; padding: 20px; background-color: white; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1); text-align: center; }
    </style>
    <!-- Auto redirect to home after 3 seconds -->
    <meta http-equiv="refresh" content="3;url=${pageContext.request.contextPath}/home">
</head>
<body>
    <div class="success-container">
        <h2 class="text-success mb-4">Thành công!</h2>
        <% if (request.getAttribute("message") != null) { %>
            <p class="lead"><%= request.getAttribute("message") %></p>
        <% } %>
        <p>Đang chuyển bạn về trang chủ...</p>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>