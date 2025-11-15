<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Ký - Hola Cinema</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Be Vietnam Pro', sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow-x: hidden;
            background: #000;
            padding: 40px 20px;
        }

        /* Background với cinema theme */
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

        /* Register container với glassmorphism nâng cấp */
        .register-container {
            max-width: 680px;
            width: 100%;
            padding: 50px 50px;
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

        .register-container h1 {
            font-weight: 800;
            font-size: 2.2rem;
            margin-bottom: 8px;
            letter-spacing: -0.5px;
        }

        .register-container h1 .fa-film {
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

        /* Form layout 2 cột */
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
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
            width: 100%;
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

        /* Gender radio buttons */
        .gender-group {
            display: flex;
            gap: 15px;
            margin-top: 10px;
        }

        .radio-option {
            flex: 1;
            position: relative;
        }

        .radio-option input[type="radio"] {
            position: absolute;
            opacity: 0;
        }

        .radio-option label {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 14px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            background: rgba(255, 255, 255, 0.05);
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 600;
            color: #999;
        }

        .radio-option input[type="radio"]:checked + label {
            border-color: #e50914;
            background: rgba(229, 9, 20, 0.15);
            color: #e50914;
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
            width: 100%;
            color: #fff;
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
        .login-link {
            color: #b3b3b3;
            font-size: 0.9rem;
            margin-bottom: 0;
            text-align: center;
            margin-top: 25px;
        }

        .login-link a {
            color: #fff;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            position: relative;
        }

        .login-link a::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 0;
            height: 2px;
            background: #e50914;
            transition: width 0.3s ease;
        }

        .login-link a:hover {
            color: #e50914;
        }

        .login-link a:hover::after {
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
            margin-bottom: 20px;
        }

        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-10px); }
            75% { transform: translateX(10px); }
        }

        /* Responsive */
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }

            .gender-group {
                flex-direction: column;
            }
        }

        @media (max-width: 576px) {
            .register-container {
                padding: 40px 30px;
                border-radius: 24px;
            }

            .register-container h1 {
                font-size: 1.8rem;
            }
        }
    </style>
</head>
<body>
    <!-- Cinema Background -->
    <div class="cinema-background"></div>

    <!-- Register Container -->
    <div class="register-container">
        <div class="logo-wrapper">
            <h1 class="text-center">
                <i class="fa-solid fa-film"></i> Hola Cinema
            </h1>
            <p class="tagline">Join the best cinema management system</p>
            <p class="subheadline">Create your account and start your journey</p>
        </div>

        <% 
        Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
        if (errors != null && !errors.isEmpty()) {
        %>
        <div class="alert alert-danger" role="alert">
            <i class="fa-solid fa-exclamation-circle me-2"></i>
            <% for (String error : errors.values()) { %>
                <%= error %><br>
            <% } %>
        </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/register" method="post">
            <div class="form-row">
                <div class="input-group-custom">
                    <input type="text" class="form-control" name="name"
                           placeholder="Full Name"
                           value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : "" %>" required>
                    <i class="fa-solid fa-id-card"></i>
                </div>

                <div class="input-group-custom">
                    <input type="email" class="form-control" name="email"
                           placeholder="Email Address"
                           value="<%= request.getAttribute("email") != null ? request.getAttribute("email") : "" %>" required>
                    <i class="fa-solid fa-envelope"></i>
                </div>
            </div>

            <div class="form-row">
                <div class="input-group-custom">
                    <input type="tel" class="form-control" name="phone"
                           placeholder="Phone Number (10-11 digits)"
                           value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : "" %>" required>
                    <i class="fa-solid fa-phone"></i>
                </div>

                <div class="input-group-custom">
                    <input type="date" class="form-control" name="dob"
                           value="<%= request.getAttribute("dob") != null ? request.getAttribute("dob") : "" %>" required>
                    <i class="fa-solid fa-calendar"></i>
                </div>
            </div>

            <div class="form-row">
                <div class="input-group-custom">
                    <input type="password" class="form-control" name="password"
                           placeholder="Password" required>
                    <i class="fa-solid fa-lock"></i>
                    <small style="display: block; margin-top: 0.25rem; font-size: 0.75rem; color: #6b7280;">
                        Min 6 characters, 1 uppercase, 1 special character (!@#$%^&*...)
                    </small>
                </div>

                <div class="input-group-custom">
                    <input type="password" class="form-control" name="confirmPassword"
                           placeholder="Confirm Password" required>
                    <i class="fa-solid fa-lock"></i>
                </div>
            </div>

            <div class="input-group-custom">
                <label style="color: #b3b3b3; font-size: 0.9rem; margin-bottom: 10px;">Gender</label>
                <div class="gender-group">
                    <%
                        String selectedGender = (String) request.getAttribute("gender");
                    %>
                    <div class="radio-option">
                        <input type="radio" id="male" name="gender" value="1"
                               <%= "1".equals(selectedGender) ? "checked" : "" %> required>
                        <label for="male">
                            <i class="fas fa-mars me-2"></i> Male
                        </label>
                    </div>
                    <div class="radio-option">
                        <input type="radio" id="female" name="gender" value="0"
                               <%= "0".equals(selectedGender) ? "checked" : "" %> required>
                        <label for="female">
                            <i class="fas fa-venus me-2"></i> Female
                        </label>
                    </div>
                </div>
            </div>

            <button type="submit" class="btn btn-cinema">
                <i class="fa-solid fa-user-plus me-2"></i>Register
            </button>
        </form>

        <p class="login-link">
            Already have an account? <a href="${pageContext.request.contextPath}/login">Login now</a>
        </p>
    </div>
</body>
</html>

