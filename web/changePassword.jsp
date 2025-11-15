<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu - Hola Cinema</title>

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css">

    <style>
        :root {
            --cinema-red: #e50914;
            --cinema-red-dark: #d40000;
            --cinema-red-light: #ff2b2b;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Be Vietnam Pro', sans-serif;
        }

        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            position: relative;
            overflow: hidden;
        }

        /* Cinema Background */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?q=80&w=2070') center/cover;
            animation: bgZoom 20s ease-in-out infinite alternate;
            z-index: -2;
        }

        body::after {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.6);
            z-index: -1;
        }

        @keyframes bgZoom {
            0% { transform: scale(1); }
            100% { transform: scale(1.1); }
        }

        /* Floating Particles */
        .particle {
            position: fixed;
            width: 4px;
            height: 4px;
            background: var(--cinema-red);
            border-radius: 50%;
            opacity: 0.6;
            animation: float 15s ease-in-out infinite;
            z-index: 0;
        }

        .particle:nth-child(1) { top: 20%; left: 20%; animation-delay: 0s; }
        .particle:nth-child(2) { top: 60%; left: 80%; animation-delay: 2s; }
        .particle:nth-child(3) { top: 80%; left: 30%; animation-delay: 4s; }
        .particle:nth-child(4) { top: 40%; left: 70%; animation-delay: 6s; }

        @keyframes float {
            0%, 100% { transform: translateY(0) translateX(0); opacity: 0.6; }
            50% { transform: translateY(-30px) translateX(20px); opacity: 1; }
        }

        /* Main Container */
        .password-container {
            max-width: 580px;
            width: 100%;
            background: rgba(0, 0, 0, 0.45);
            backdrop-filter: blur(20px);
            border-radius: 28px;
            padding: 50px 45px;
            box-shadow: 0 8px 40px rgba(0, 0, 0, 0.5);
            border: 1px solid rgba(255, 255, 255, 0.1);
            animation: fadeInUp 0.8s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            z-index: 1;
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Header */
        .password-header {
            text-align: center;
            margin-bottom: 2.5rem;
        }

        .password-header .icon {
            width: 90px;
            height: 90px;
            background: linear-gradient(135deg, var(--cinema-red-light), var(--cinema-red-dark));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            font-size: 42px;
            color: white;
            box-shadow: 0 8px 25px rgba(229, 9, 20, 0.4);
            animation: pulse 2s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { transform: scale(1); box-shadow: 0 8px 25px rgba(229, 9, 20, 0.4); }
            50% { transform: scale(1.05); box-shadow: 0 12px 35px rgba(229, 9, 20, 0.6); }
        }

        .password-header h2 {
            font-size: 2rem;
            font-weight: 800;
            color: white;
            margin-bottom: 0.8rem;
            letter-spacing: -0.5px;
        }

        .password-header p {
            color: #b3b3b3;
            font-size: 15px;
            line-height: 1.6;
        }

        /* Info Box */
        .info-box {
            background: rgba(229, 9, 20, 0.15);
            border-left: 4px solid var(--cinema-red);
            padding: 1rem 1.2rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            display: flex;
            align-items: flex-start;
            gap: 12px;
        }

        .info-box i {
            color: var(--cinema-red);
            font-size: 20px;
            margin-top: 2px;
        }

        .info-box p {
            color: #e0e0e0;
            font-size: 14px;
            line-height: 1.6;
            margin: 0;
        }

        /* Form */
        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            color: #e0e0e0;
            font-weight: 600;
            margin-bottom: 0.6rem;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .form-label i {
            color: var(--cinema-red);
            font-size: 18px;
        }

        .input-wrapper {
            position: relative;
        }

        .form-control {
            width: 100%;
            padding: 14px 18px 14px 48px;
            background: rgba(255, 255, 255, 0.1);
            border: 2px solid rgba(255, 255, 255, 0.2);
            border-radius: 14px;
            color: white;
            font-size: 15px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            background: rgba(255, 255, 255, 0.15);
            border-color: var(--cinema-red);
            box-shadow: 0 0 0 4px rgba(229, 9, 20, 0.2);
        }

        .form-control::placeholder {
            color: #888;
        }

        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #888;
            font-size: 20px;
            pointer-events: none;
        }

        /* Alert Messages */
        .alert {
            padding: 1rem 1.2rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
            font-weight: 500;
            animation: shake 0.5s ease-in-out;
        }

        .alert-danger {
            background: rgba(214, 48, 49, 0.2);
            color: #ff6b6b;
            border-left: 4px solid #D63031;
        }

        .alert-success {
            background: rgba(0, 184, 148, 0.2);
            color: #55efc4;
            border-left: 4px solid #00B894;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }

        /* Button */
        .btn-cinema {
            width: 100%;
            padding: 16px;
            background: linear-gradient(90deg, var(--cinema-red-light), var(--cinema-red-dark));
            border: none;
            border-radius: 12px;
            color: white;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 15px rgba(229, 9, 20, 0.4);
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .btn-cinema:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 25px rgba(229, 9, 20, 0.6);
        }

        .btn-cinema:active {
            transform: translateY(0);
        }

        /* Back Link */
        .back-link {
            text-align: center;
            margin-top: 1.5rem;
        }

        .back-link a {
            color: #b3b3b3;
            text-decoration: none;
            font-size: 14px;
            transition: color 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }

        .back-link a:hover {
            color: var(--cinema-red);
        }

        /* Responsive */
        @media (max-width: 576px) {
            .password-container {
                padding: 40px 30px;
                border-radius: 24px;
            }

            .password-header h2 {
                font-size: 1.6rem;
            }
        }
    </style>
</head>
<body>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>
    <div class="particle"></div>

    <div class="password-container">
        <div class="password-header">
            <div class="icon">
                <i class="ri-lock-password-line"></i>
            </div>
            <h2>Đổi mật khẩu</h2>
            <p>Cập nhật mật khẩu của bạn để bảo mật tài khoản</p>
        </div>

        <div class="info-box">
            <i class="ri-information-line"></i>
            <p>Mật khẩu phải có ít nhất 6 ký tự và nên bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt.</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger">
            <i class="ri-error-warning-line"></i>
            <%= request.getAttribute("error") %>
        </div>
        <% } %>

        <% if (request.getAttribute("message") != null) { %>
        <div class="alert alert-success">
            <i class="ri-checkbox-circle-line"></i>
            <%= request.getAttribute("message") %>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/newPassword" method="post">
            <div class="form-group">
                <label class="form-label">
                    <i class="ri-lock-line"></i>
                    New Password
                </label>
                <div class="input-wrapper">
                    <i class="ri-lock-line input-icon"></i>
                    <input type="password" class="form-control" id="password" name="password"
                           placeholder="Enter new password" required>
                </div>
                <small style="display: block; margin-top: 0.5rem; font-size: 0.875rem; color: rgba(255,255,255,0.7);">
                    <i class="ri-information-line"></i>
                    Min 6 characters, 1 uppercase, 1 special character (!@#$%^&*...)
                </small>
            </div>

            <div class="form-group">
                <label class="form-label">
                    <i class="ri-lock-2-line"></i>
                    Confirm Password
                </label>
                <div class="input-wrapper">
                    <i class="ri-lock-2-line input-icon"></i>
                    <input type="password" class="form-control" id="confPassword" name="confPassword"
                           placeholder="Confirm new password" required>
                </div>
            </div>

            <button type="submit" class="btn-cinema">
                <i class="ri-check-line"></i>
                Change Password
            </button>
        </form>

        <div class="back-link">
            <a href="${pageContext.request.contextPath}/home">
                <i class="ri-arrow-left-line"></i>
                Quay về trang chủ
            </a>
        </div>
    </div>
</body>
</html>

