<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký - Quản Lý Rạp Phim</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Be Vietnam Pro', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh; /* Sử dụng min-height để form dài không bị cắt */
            padding: 40px 0; /* Thêm padding trên dưới cho màn hình nhỏ */
            background-image: linear-gradient(rgba(0,0,0,0.7), rgba(0,0,0,0.7)), url('https://images.unsplash.com/photo-1542204165-65bf26472b9b?q=80&w=1974&auto=format&fit=crop');
            background-size: cover;
            background-position: center;
            background-attachment: fixed; /* Giữ nền cố định khi cuộn */
        }

        .register-container {
            max-width: 550px;
            width: 100%;
            padding: 30px 40px;
            background-color: rgba(20, 20, 20, 0.8);
            backdrop-filter: blur(12px);
            border-radius: 15px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.37);
            border: 1px solid rgba(255, 255, 255, 0.18);
            color: #fff;
        }

        .register-container h1 {
            font-weight: 700;
            font-size: 2rem;
            margin-bottom: 25px;
        }

        .register-container h1 .fa-film {
            color: #e50914; /* Màu đỏ nổi bật */
        }
        
        .form-control {
            background: rgba(70, 70, 70, 0.7);
            border: 1px solid #555;
            color: #fff;
            height: 48px;
            padding-left: 45px; /* Tạo không gian cho icon */
        }
        
        /* CSS cho input date và radio button */
        .form-control[type="date"]::-webkit-calendar-picker-indicator {
            filter: invert(0.8); /* Làm icon lịch sáng hơn trên nền tối */
        }
        .form-check-input {
            background-color: #555;
            border-color: #777;
        }
        .form-check-input:checked {
            background-color: #e50914;
            border-color: #e50914;
        }
        
        .form-control:focus {
            background: rgba(80, 80, 80, 0.8);
            border-color: #e50914;
            box-shadow: 0 0 0 0.25rem rgba(229, 9, 20, 0.25);
            color: #fff;
        }

        .form-label {
            color: #ccc;
            margin-bottom: 0.5rem;
        }
        
        .input-group-custom {
            position: relative;
        }

        .input-group-custom .fa-solid {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
            z-index: 2;
        }
        
        /* Điều chỉnh vị trí icon cho các trường có label */
        .input-group-custom .fa-solid {
           top: 40px;
        }
        
        .btn-cinema {
            background-color: #e50914;
            border: none;
            padding: 12px;
            font-weight: 700;
            transition: background-color 0.3s ease;
        }

        .btn-cinema:hover {
            background-color: #f6121d;
        }
        
        .login-link a {
            color: #fff;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }
        
        .login-link a:hover {
            color: #e50914;
            text-decoration: underline;
        }
        
        .error-message {
            color: #ffcdd2;
            font-size: 0.875em;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <h1 class="text-center"><i class="fa-solid fa-film"></i> Tạo Tài Khoản Mới</h1>
        
        <%-- Lấy map lỗi từ request --%>
        <% Map<String, String> errors = (Map<String, String>) request.getAttribute("errors"); %>
        
        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger" role="alert">
            <%= request.getAttribute("error") %>
        </div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="name" class="form-label">Họ và tên</label>
                    <div class="input-group-custom">
                        <i class="fa-solid fa-user"></i>
                        <input type="text" class="form-control" id="name" name="name" value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : "" %>" required>
                    </div>
                    <% if (errors != null && errors.containsKey("name")) { %>
                        <div class="error-message"><%= errors.get("name") %></div>
                    <% } %>
                </div>
                <div class="col-md-6 mb-3">
                    <label for="phone" class="form-label">Số điện thoại</label>
                    <div class="input-group-custom">
                        <i class="fa-solid fa-phone"></i>
                        <input type="text" class="form-control" id="phone" name="phone" value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>">
                    </div>
                    <% if (errors != null && errors.containsKey("phone")) { %>
                         <div class="error-message"><%= errors.get("phone") %></div>
                    <% } %>
                </div>
            </div>
            
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <div class="input-group-custom">
                    <i class="fa-solid fa-envelope"></i>
                    <input type="email" class="form-control" id="email" name="email" value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" required>
                </div>
                <% if (errors != null && errors.containsKey("email")) { %>
                     <div class="error-message"><%= errors.get("email") %></div>
                <% } %>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="password" class="form-label">Mật khẩu</label>
                    <div class="input-group-custom">
                         <i class="fa-solid fa-lock"></i>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                    <% if (errors != null && errors.containsKey("password")) { %>
                        <div class="error-message"><%= errors.get("password") %></div>
                    <% } %>
                </div>
                <div class="col-md-6 mb-3">
                    <label for="confirmPassword" class="form-label">Xác nhận mật khẩu</label>
                    <div class="input-group-custom">
                         <i class="fa-solid fa-check-double"></i>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                    </div>
                    <% if (errors != null && errors.containsKey("confirmPassword")) { %>
                        <div class="error-message"><%= errors.get("confirmPassword") %></div>
                    <% } %>
                </div>
            </div>
            
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="dob" class="form-label">Ngày sinh</label>
                    <input type="date" class="form-control" id="dob" name="dob" value="<%= request.getAttribute("dob") != null ? request.getAttribute("dob") : "" %>">
                    <% if (errors != null && errors.containsKey("dob")) { %>
                        <div class="error-message"><%= errors.get("dob") %></div>
                    <% } %>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Giới tính</label>
                    <div class="d-flex align-items-center h-100">
                        <div class="form-check me-3">
                            <input type="radio" class="form-check-input" id="male" name="gender" value="1" <%= "1".equals(request.getAttribute("gender")) ? "checked" : "" %> required>
                            <label class="form-check-label" for="male">Nam</label>
                        </div>
                        <div class="form-check">
                            <input type="radio" class="form-check-input" id="female" name="gender" value="0" <%= "0".equals(request.getAttribute("gender")) ? "checked" : "" %>>
                            <label class="form-check-label" for="female">Nữ</label>
                        </div>
                    </div>
                     <% if (errors != null && errors.containsKey("gender")) { %>
                        <div class="error-message"><%= errors.get("gender") %></div>
                    <% } %>
                </div>
            </div>
            
            <button type="submit" class="btn btn-cinema w-100 mt-3">Tạo tài khoản</button>
        </form>
        
        <p class="text-center mt-4 login-link">
            Đã có tài khoản? <a href="${pageContext.request.contextPath}/auth/login">Đăng nhập ngay</a>
        </p>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>