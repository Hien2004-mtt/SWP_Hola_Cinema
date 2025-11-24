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
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Be Vietnam Pro', sans-serif;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                position: relative;
                overflow: hidden;
                background: #000;
            }

            /* Background với cinema theme + animation */
            .cinema-background {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background:
                    linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)),
                    url('https://images.unsplash.com/photo-1542204165-65bf26472b9b?q=80&w=1974&auto=format&fit=crop') center/cover;
                animation: bgZoom 20s ease-in-out infinite alternate;
            }

            @keyframes bgZoom {
                0% { transform: scale(1); }
                100% { transform: scale(1.06); }
            }

            /* Floating particles effect */
            .cinema-background::before {
                content: '';
                position: absolute;
                width: 100%;
                height: 100%;
                background:
                    radial-gradient(circle at 20% 50%, rgba(229, 9, 20, 0.15) 0%, transparent 50%),
                    radial-gradient(circle at 80% 20%, rgba(229, 9, 20, 0.1) 0%, transparent 50%),
                    radial-gradient(circle at 40% 80%, rgba(229, 9, 20, 0.12) 0%, transparent 50%);
                animation: float 15s ease-in-out infinite;
            }

            @keyframes float {
                0%, 100% { transform: translate(0, 0); opacity: 0.5; }
                33% { transform: translate(30px, -30px); opacity: 0.8; }
                66% { transform: translate(-20px, 20px); opacity: 0.6; }
            }

            /* Login container với glassmorphism nâng cấp */
            .login-container {
                max-width: 520px;
                width: 100%;
                padding: 55px 50px;
                margin: 20px;
                /* Glassmorphism premium */
                background: rgba(0, 0, 0, 0.45);
                backdrop-filter: blur(20px);
                border-radius: 28px;
                box-shadow: 0 8px 40px rgba(0, 0, 0, 0.5);
                border: 1px solid rgba(255, 255, 255, 0.1);
                color: #fff;
                position: relative;
                z-index: 1;
                animation: fadeInUp 0.8s cubic-bezier(0.16, 1, 0.3, 1);
            }

            @keyframes fadeInUp {
                from { opacity: 0; transform: translateY(40px); }
                to { opacity: 1; transform: translateY(0); }
            }

            /* Logo với animation */
            .logo-wrapper {
                text-align: center;
                margin-bottom: 35px;
                animation: fadeIn 0.3s ease-out;
            }

            @keyframes fadeIn {
                from { opacity: 0; }
                to { opacity: 1; }
            }

            .login-container h1 {
                font-weight: 800;
                font-size: 2.2rem;
                margin-bottom: 8px;
                letter-spacing: -0.5px;
            }

            .login-container h1 .fa-film {
                color: #e50914;
                margin-right: 8px;
            }

            .tagline {
                color: #b3b3b3;
                font-size: 0.95rem;
                margin-bottom: 8px;
                font-weight: 500;
            }

            .subheadline {
                color: #888;
                font-size: 0.85rem;
                margin-bottom: 0;
                font-weight: 400;
            }

            /* Form inputs nâng cấp */
            .input-group-custom {
                position: relative;
                margin-bottom: 20px;
            }

            .input-group-custom .fa-solid {
                position: absolute;
                left: 18px;
                top: 50%;
                transform: translateY(-50%);
                color: #999;
                font-size: 18px;
                transition: color 0.3s ease;
                z-index: 2;
            }

            .form-control {
                background: rgba(255, 255, 255, 0.05);
                border: 1px solid rgba(255, 255, 255, 0.1);
                color: #fff;
                height: 56px;
                padding-left: 52px;
                border-radius: 12px;
                font-size: 15px;
                transition: all 0.3s ease;
            }

            .form-control:focus {
                background: rgba(0, 0, 0, 0.6);
                border-color: #e50914;
                box-shadow: 0 0 0 3px rgba(229, 9, 20, 0.15);
                color: #fff;
                outline: none;
            }

            .form-control:focus + .fa-solid {
                color: #e50914;
            }

            .form-control::placeholder {
                color: #888;
            }

            /* Button Netflix style với gradient */
            .btn-cinema {
                background: linear-gradient(90deg, #ff2b2b, #d40000);
                border: none;
                padding: 16px;
                font-weight: 700;
                font-size: 16px;
                border-radius: 12px;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                box-shadow: 0 4px 15px rgba(229, 9, 20, 0.3);
                letter-spacing: 0.5px;
            }

            .btn-cinema:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(229, 9, 20, 0.5);
                background: linear-gradient(90deg, #ff3838, #e50914);
            }

            .btn-cinema:active {
                transform: translateY(0);
            }

            /* Links styling */
            .register-link {
                color: #b3b3b3;
                font-size: 0.9rem;
                margin-bottom: 0;
            }

            .register-link a {
                color: #fff;
                text-decoration: none;
                font-weight: 600;
                transition: all 0.3s ease;
                position: relative;
            }

            .register-link a::after {
                content: '';
                position: absolute;
                bottom: -2px;
                left: 0;
                width: 0;
                height: 2px;
                background: #e50914;
                transition: width 0.3s ease;
            }

            .register-link a:hover {
                color: #e50914;
            }

            .register-link a:hover::after {
                width: 100%;
            }

            /* Alert styling */
            .alert {
                border-radius: 12px;
                border: none;
                background: rgba(220, 53, 69, 0.15);
                border-left: 4px solid #dc3545;
                color: #fff;
                animation: shake 0.5s ease;
            }

            @keyframes shake {
                0%, 100% { transform: translateX(0); }
                25% { transform: translateX(-10px); }
                75% { transform: translateX(10px); }
            }

            /* Responsive */
            @media (max-width: 576px) {
                .login-container {
                    padding: 40px 30px;
                    border-radius: 24px;
                }

                .login-container h1 {
                    font-size: 1.8rem;
                }
            }
        </style>
    </head>
    <body>
        <!-- Cinema Background -->
        <div class="cinema-background"></div>

        <!-- Login Container -->
        <div class="login-container">
            <div class="logo-wrapper">
                <h1 class="text-center">
                    <i class="fa-solid fa-film"></i> Hola Cinema
                </h1>
                <p class="tagline">Experience the best cinema management system</p>
                <p class="subheadline">Your system, your screen, your control.</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger" role="alert">
                <i class="fa-solid fa-exclamation-circle me-2"></i>
                <%= request.getAttribute("error") %>
            </div>
            <% } %>

            <form action="login" method="post">
                <div class="input-group-custom">
                    <input type="email" class="form-control" id="email" name="email"
                           placeholder="Enter your email address"
                           value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" required>
                    <i class="fa-solid fa-envelope"></i>
                </div>
                <div class="input-group-custom">
                    <input type="password" class="form-control" id="password" name="password"
                           placeholder="Enter your password" required>
                    <i class="fa-solid fa-lock"></i>
                </div>
                <button type="submit" class="btn btn-cinema w-100">
                    <i class="fa-solid fa-sign-in-alt me-2"></i>Login
                </button>
            </form>

            <p class="text-center mt-4 register-link">
                Don't have an account? <a href="${pageContext.request.contextPath}/register">Register now</a>
            </p>

            <p class="text-center mt-3 register-link">
                Forgot your password? <a href="${pageContext.request.contextPath}/forgotPassword">Recover it here</a>
            </p>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>