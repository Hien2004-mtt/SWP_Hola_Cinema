<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Models.User, java.util.Map" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Profile - Hola Cinema</title>

    <!-- Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css">

    <style>
        :root {
            --primary: #6C63FF;
            --primary-dark: #5A52D5;
            --bg: #F8F9FC;
            --card: #FFFFFF;
            --text: #1A1D1F;
            --text-secondary: #6F767E;
            --border: #E4E7EC;
            --success: #10B981;
            --error: #EF4444;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
        }

        body {
            background: var(--bg);
            min-height: 100vh;
            padding: 0;
            margin: 0;
        }

        /* Header */
        .header {
            background: white;
            border-bottom: 1px solid var(--border);
            padding: 1rem 2rem;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 1px 3px rgba(0,0,0,0.04);
        }

        .header-content {
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--text);
        }

        .logo i {
            font-size: 1.75rem;
            color: var(--primary);
        }

        .nav-links {
            display: flex;
            gap: 0.5rem;
            align-items: center;
        }

        .nav-links a {
            padding: 0.5rem 1rem;
            border-radius: 8px;
            text-decoration: none;
            color: var(--text-secondary);
            font-size: 0.875rem;
            font-weight: 500;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .nav-links a:hover {
            background: #F3F4F6;
            color: var(--text);
        }

        .nav-links a.active {
            background: #EEF2FF;
            color: var(--primary);
        }

        /* Main Container */
        .main-container {
            max-width: 1400px;
            margin: 3rem auto;
            padding: 0 2rem;
        }

        .profile-wrapper {
            display: grid;
            grid-template-columns: 40% 60%;
            gap: 3rem;
            background: white;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
        }

        /* Left Side - Illustration */
        .illustration-side {
            background: linear-gradient(135deg, #667EEA 0%, #764BA2 100%);
            padding: 3rem;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            position: relative;
            overflow: hidden;
        }

        .illustration-side::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -50%;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            border-radius: 50%;
        }

        .illustration-content {
            position: relative;
            z-index: 1;
            text-align: center;
        }

        .illustration-image {
            width: 100%;
            max-width: 420px;
            height: auto;
            border-radius: 28px;
            box-shadow: 0 12px 30px rgba(0,0,0,0.15);
            opacity: 0.95;
            margin-bottom: 2rem;
        }

        .illustration-text {
            color: white;
        }

        .illustration-text h2 {
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 0.75rem;
            line-height: 1.3;
        }

        .illustration-text p {
            font-size: 1rem;
            opacity: 0.9;
            line-height: 1.6;
        }

        /* Right Side - Form */
        .form-side {
            padding: 3rem 3rem 3rem 0;
        }

        .form-header {
            margin-bottom: 2.5rem;
        }

        .form-header h1 {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text);
            margin-bottom: 0.5rem;
        }

        .form-header p {
            color: var(--text-secondary);
            font-size: 0.95rem;
        }

        /* Avatar Section */
        .avatar-section {
            display: flex;
            align-items: center;
            gap: 1.5rem;
            padding: 1.5rem;
            background: #F9FAFB;
            border-radius: 16px;
            margin-bottom: 2rem;
        }

        .avatar {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), #A66EFE);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            color: white;
            font-weight: 700;
            box-shadow: 0 4px 12px rgba(108, 99, 255, 0.25);
        }

        .avatar-info h3 {
            font-size: 1.125rem;
            font-weight: 600;
            color: var(--text);
            margin-bottom: 0.25rem;
        }

        .avatar-info p {
            font-size: 0.875rem;
            color: var(--text-secondary);
        }

        /* Form */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group.full-width {
            grid-column: span 2;
        }

        .form-label {
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--text);
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-label i {
            color: var(--primary);
            font-size: 1rem;
        }

        .form-control {
            padding: 0.875rem 1rem;
            border: 1.5px solid var(--border);
            border-radius: 10px;
            font-size: 0.9375rem;
            color: var(--text);
            transition: all 0.2s;
            background: white;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(108, 99, 255, 0.1);
        }

        .form-control:disabled {
            background: #F3F4F6;
            color: var(--text-secondary);
            cursor: not-allowed;
        }

        .form-control::placeholder {
            color: #9CA3AF;
        }

        /* Gender Radio */
        .gender-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .radio-option {
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
            gap: 0.5rem;
            padding: 0.875rem;
            border: 2px solid var(--border);
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 0.9375rem;
            font-weight: 500;
            color: var(--text-secondary);
        }

        .radio-option label:hover {
            border-color: var(--primary);
            background: #F9FAFB;
        }

        .radio-option input[type="radio"]:checked + label {
            border-color: var(--primary);
            background: #EEF2FF;
            color: var(--primary);
            font-weight: 600;
        }

        /* Buttons */
        .button-group {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .btn {
            padding: 0.875rem 1.75rem;
            border-radius: 10px;
            font-size: 0.9375rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            border: none;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
            flex: 1;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(108, 99, 255, 0.3);
        }

        .btn-secondary {
            background: white;
            color: var(--text-secondary);
            border: 1.5px solid var(--border);
        }

        .btn-secondary:hover {
            background: #F9FAFB;
            border-color: var(--text-secondary);
        }

        /* Alert */
        .alert {
            padding: 1rem 1.25rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 0.875rem;
            font-weight: 500;
            animation: slideDown 0.3s ease-out;
            transition: opacity 0.3s, transform 0.3s;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert.fade-out {
            opacity: 0;
            transform: translateY(-10px);
        }

        .alert-success {
            background: #ECFDF5;
            color: #065F46;
            border: 1px solid #A7F3D0;
        }

        .alert-success i {
            color: #10B981;
            font-size: 1.25rem;
        }

        .alert-danger {
            background: #FEF2F2;
            color: #991B1B;
            border: 1px solid #FECACA;
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .profile-wrapper {
                grid-template-columns: 1fr;
            }

            .illustration-side {
                padding: 2rem;
            }

            .form-side {
                padding: 2rem;
            }
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .gender-group {
                grid-template-columns: 1fr;
            }

            .button-group {
                flex-direction: column;
            }

            .nav-links {
                display: none;
            }
        }
    </style>
</head>
<body>
    <%
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
            return;
        }

        Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
        String successMessage = (String) request.getAttribute("successMessage");
    %>

    <!-- Header -->
    <div class="header">
        <div class="header-content">
            <div class="logo">
                <i class="ri-movie-2-fill"></i>
                Hola Cinema
            </div>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/home">
                    <i class="ri-home-line"></i> Home
                </a>
                <a href="${pageContext.request.contextPath}/Views/updateProfile.jsp" class="active">
                    <i class="ri-user-settings-line"></i> Profile
                </a>
                <a href="${pageContext.request.contextPath}/logout">
                    <i class="ri-logout-box-line"></i> Logout
                </a>
            </div>
        </div>
    </div>

    <!-- Main Container -->
    <div class="main-container">
        <div class="profile-wrapper">
            <!-- Left Side - Illustration -->
            <div class="illustration-side">
                <div class="illustration-content">
                    <img src="https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?q=80&w=800" 
                         alt="Cinema" class="illustration-image">
                    <div class="illustration-text">
                        <h2>Manage Your Profile</h2>
                        <p>Keep your information up to date for the best cinema experience</p>
                    </div>
                </div>
            </div>

            <!-- Right Side - Form -->
            <div class="form-side">
                <div class="form-header">
                    <h1>Profile Settings</h1>
                    <p>Update your personal information and preferences</p>
                </div>

                <!-- Avatar Section -->
                <div class="avatar-section">
                    <div class="avatar">
                        <%= user.getName() != null && !user.getName().isEmpty() ? 
                            user.getName().substring(0, 1).toUpperCase() : "U" %>
                    </div>
                    <div class="avatar-info">
                        <h3><%= user.getName() != null ? user.getName() : "User" %></h3>
                        <p><%= user.getEmail() %></p>
                    </div>
                </div>

                <!-- Alerts -->
                <% if (successMessage != null) { %>
                <div class="alert alert-success">
                    <i class="ri-checkbox-circle-line"></i>
                    <%= successMessage %>
                </div>
                <% } %>

                <% if (errors != null && !errors.isEmpty()) { %>
                <div class="alert alert-danger">
                    <i class="ri-error-warning-line"></i>
                    <% for (String error : errors.values()) { %>
                        <%= error %><br>
                    <% } %>
                </div>
                <% } %>

                <!-- Form -->
                <form action="${pageContext.request.contextPath}/updateProfile" method="post">
                    <div class="form-grid">
                        <div class="form-group full-width">
                            <label class="form-label">
                                <i class="ri-mail-line"></i>
                                Email Address
                            </label>
                            <input type="email" class="form-control" value="<%= user.getEmail() %>" disabled>
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <i class="ri-user-line"></i>
                                Full Name
                            </label>
                            <input type="text" name="name" class="form-control" 
                                   value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : (user.getName() != null ? user.getName() : "") %>" 
                                   placeholder="Enter your full name" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <i class="ri-phone-line"></i>
                                Phone Number
                            </label>
                            <input type="tel" name="phone" class="form-control" 
                                   value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : (user.getPhone() != null ? user.getPhone() : "") %>" 
                                   placeholder="0123456789" required>
                        </div>

                        <div class="form-group">
                            <label class="form-label">
                                <i class="ri-calendar-line"></i>
                                Date of Birth
                            </label>
                            <input type="date" name="dob" class="form-control" 
                                   value="<%= request.getAttribute("dob") != null ? request.getAttribute("dob") : (user.getDob() != null ? user.getDob().toString() : "") %>" 
                                   required>
                        </div>

                        <div class="form-group full-width">
                            <label class="form-label">
                                <i class="ri-genderless-line"></i>
                                Gender
                            </label>
                            <div class="gender-group">
                                <%
                                    String selectedGender = (String) request.getAttribute("gender");
                                    boolean isMale = selectedGender != null ? "1".equals(selectedGender) : user.isGender();
                                %>
                                <div class="radio-option">
                                    <input type="radio" id="male" name="gender" value="1"
                                           <%= isMale ? "checked" : "" %> required>
                                    <label for="male">
                                        <i class="ri-men-line"></i> Male
                                    </label>
                                </div>
                                <div class="radio-option">
                                    <input type="radio" id="female" name="gender" value="0"
                                           <%= !isMale ? "checked" : "" %> required>
                                    <label for="female">
                                        <i class="ri-women-line"></i> Female
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Change Password Section -->
                    <div style="margin: 2rem 0; padding-top: 2rem; border-top: 2px solid var(--border);">
                        <h3 style="font-size: 1.125rem; font-weight: 600; color: var(--text); margin-bottom: 1rem; display: flex; align-items: center; gap: 0.5rem;">
                            <i class="ri-lock-password-line" style="color: var(--primary);"></i>
                            Change Password
                        </h3>
                        <p style="font-size: 0.875rem; color: var(--text-secondary); margin-bottom: 1.5rem;">
                            Leave blank if you don't want to change your password
                        </p>

                        <div class="form-grid">
                            <div class="form-group">
                                <label class="form-label">
                                    <i class="ri-lock-line"></i>
                                    Current Password
                                </label>
                                <input type="password" name="currentPassword" class="form-control"
                                       placeholder="Enter current password">
                            </div>

                            <div class="form-group">
                                <label class="form-label">
                                    <i class="ri-lock-line"></i>
                                    New Password
                                </label>
                                <input type="password" name="newPassword" class="form-control"
                                       placeholder="Enter new password">
                                <small style="display: block; margin-top: 0.25rem; font-size: 0.75rem; color: var(--text-secondary);">
                                    Min 6 characters, 1 uppercase, 1 special character (!@#$%^&*...)
                                </small>
                            </div>

                            <div class="form-group full-width">
                                <label class="form-label">
                                    <i class="ri-lock-line"></i>
                                    Confirm New Password
                                </label>
                                <input type="password" name="confirmNewPassword" class="form-control"
                                       placeholder="Confirm new password">
                            </div>
                        </div>
                    </div>

                    <div class="button-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="ri-save-line"></i>
                            Save Changes
                        </button>
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">
                            <i class="ri-arrow-left-line"></i>
                            Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        // Auto-hide success message after 5 seconds
        window.addEventListener('DOMContentLoaded', function() {
            const successAlert = document.querySelector('.alert-success');
            if (successAlert) {
                setTimeout(function() {
                    successAlert.classList.add('fade-out');
                    setTimeout(function() {
                        successAlert.style.display = 'none';
                    }, 300);
                }, 5000);
            }
        });
    </script>
</body>
</html>

