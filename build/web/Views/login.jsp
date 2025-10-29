<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Nhập - Quản Lý Rạp Phim</title>

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
                height: 100vh;
                /* Ảnh nền chủ đề rạp phim */
                background-image: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)), url('https://images.unsplash.com/photo-1542204165-65bf26472b9b?q=80&w=1974&auto=format&fit=crop');
                background-size: cover;
                background-position: center;
            }

            .login-container {
                max-width: 420px;
                width: 100%;
                padding: 40px;
                /* Hiệu ứng Glassmorphism */
                background-color: rgba(20, 20, 20, 0.75);
                backdrop-filter: blur(10px);
                border-radius: 15px;
                box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.37);
                border: 1px solid rgba(255, 255, 255, 0.18);
                color: #fff;
            }

            .login-container h1 {
                font-weight: 700;
                font-size: 2rem;
                margin-bottom: 10px;
            }

            .login-container h1 .fa-film {
                color: #e50914; /* Màu đỏ nổi bật */
            }

            .login-container p {
                color: #b3b3b3;
                margin-bottom: 30px;
            }

            .form-control {
                background: rgba(70, 70, 70, 0.7);
                border: 1px solid #555;
                color: #fff;
                height: 50px;
                padding-left: 40px; /* Tạo không gian cho icon */
            }

            .form-control:focus {
                background: rgba(80, 80, 80, 0.8);
                border-color: #e50914;
                box-shadow: 0 0 0 0.25rem rgba(229, 9, 20, 0.25);
                color: #fff;
            }

            .form-control::placeholder {
                color: #aaa;
            }

            .form-label {
                color: #ccc;
            }

            /* Định vị cho icon bên trong input */
            .input-group-custom {
                position: relative;
            }

            .input-group-custom .fa-solid {
                position: absolute;
                left: 15px;
                top: 50%;
                transform: translateY(-50%);
                color: #aaa;
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

            .register-link a {
                color: #fff;
                text-decoration: none;
                font-weight: 500;
                transition: color 0.3s ease;
            }

            .register-link a:hover {
                color: #e50914;
                text-decoration: underline;
            }

        </style>
    </head>
    <body>
        <div class="login-container">
            <h1 class="text-center"><i class="fa-solid fa-film"></i> Hola Cinema</h1>
            <p class="text-center">Log in to access the management system</p>

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger" role="alert">
                <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <form action="login" method="post">
                <div class="mb-3 input-group-custom">
                    <i class="fa-solid fa-envelope"></i>
                    <input type="email" class="form-control" id="email" name="email" placeholder="Enter your email" required>
                </div>
                <div class="mb-4 input-group-custom">
                    <i class="fa-solid fa-lock"></i>
                    <input type="password" class="form-control" id="password" name="password" placeholder="Enter your password" required>
                </div>
                <button type="submit" class="btn btn-cinema w-100">Login</button>
            </form>

            <p class="text-center mt-4 register-link">
                Don't have an account? <a href="register">Register now</a>
            </p>
            
             <p class="text-center mt-4 register-link">
                Forgot your password? <a href="forgotPassword.jsp">Recover it here</a>
            </p>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>