<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Models.User, java.util.Map" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập nhật hồ sơ</title>

    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <style>
        :root {
            --primary: #4361ee;
            --primary-light: #e0e7ff;
            --success: #10b981;
            --danger: #ef4444;
            --gray-100: #f8fafc;
            --gray-200: #e2e8f0;
            --gray-700: #334155;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.1);
            --shadow-md: 0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -1px rgba(0,0,0,0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -2px rgba(0,0,0,0.05);
            --radius: 12px;
            --transition: all 0.3s ease;
        }

        * {
            font-family: 'Inter', sans-serif;
        }

        body {
            background: linear-gradient(135deg, #f0f4ff 0%, #e0e7ff 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            margin: 0;
        }

        .profile-card {
            background: white;
            border-radius: var(--radius);
            box-shadow: var(--shadow-lg);
            overflow: hidden;
            max-width: 520px;
            width: 100%;
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .card-header {
            background: linear-gradient(135deg, var(--primary), #3b5bdb);
            color: white;
            padding: 1.75rem;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .card-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: rgba(255,255,255,0.1);
            transform: rotate(30deg);
            pointer-events: none;
        }

        .card-header h2 {
            margin: 0;
            font-weight: 700;
            font-size: 1.5rem;
            position: relative;
            z-index: 1;
        }

        .card-header i {
            font-size: 2.2rem;
            margin-bottom: 0.5rem;
            display: block;
            opacity: 0.9;
        }

        .card-body {
            padding: 2rem;
        }

        .form-label {
            font-weight: 600;
            color: var(--gray-700);
            font-size: 0.95rem;
            margin-bottom: 0.5rem;
        }

        .form-control, .form-check-input {
            border: 1.5px solid var(--gray-200);
            border-radius: 8px;
            padding: 0.65rem 1rem;
            font-size: 0.95rem;
            transition: var(--transition);
        }

        .form-control:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3.5px rgba(67, 97, 238, 0.15);
            outline: none;
        }

        .form-control:disabled {
            background-color: #f8fafc;
            color: #64748b;
            opacity: 1;
        }

        .input-group-text {
            background-color: var(--primary-light);
            border: 1.5px solid var(--primary);
            color: var(--primary);
            font-weight: 600;
        }

        .form-check {
            padding-left: 0;
            margin-bottom: 0.75rem;
        }

        .form-check-input {
            width: 1.25em;
            height: 1.25em;
            margin-top: 0.15em;
        }

        .form-check-label {
            margin-left: 0.5rem;
            font-weight: 500;
            color: var(--gray-700);
        }

        .error {
            color: var(--danger);
            font-size: 0.875rem;
            margin-top: 0.35rem;
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .error::before {
            content: '⚠';
            font-size: 0.9em;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), #3b5bdb);
            border: none;
            border-radius: 10px;
            padding: 0.75rem 1rem;
            font-weight: 600;
            font-size: 1rem;
            transition: var(--transition);
            box-shadow: 0 4px 10px rgba(67, 97, 238, 0.3);
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(67, 97, 238, 0.4);
        }

        .btn-secondary {
            background-color: #64748b;
            border: none;
            border-radius: 10px;
            padding: 0.6rem 1.2rem;
            font-size: 0.9rem;
            font-weight: 500;
            transition: var(--transition);
        }

        .btn-secondary:hover {
            background-color: #475569;
            transform: translateY(-1px);
        }

        .alert {
            border-radius: 10px;
            padding: 0.9rem 1.2rem;
            font-size: 0.95rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 500;
        }

        .alert-danger {
            background-color: #fee2e2;
            color: #b91c1c;
            border: 1px solid #fecaca;
        }

        .alert-success {
            background-color: #d1fae5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }

        .text-center a {
            text-decoration: none;
        }

        @media (max-width: 576px) {
            .card-body {
                padding: 1.5rem;
            }
            .card-header {
                padding: 1.5rem;
            }
            .card-header h2 {
                font-size: 1.3rem;
            }
        }
    </style>
</head>
<body>
    <div class="profile-card">
        <!-- Header -->
        <div class="card-header">
            <i class="fas fa-user-edit"></i>
            <h2>Cập nhật hồ sơ</h2>
        </div>

        <!-- Body -->
        <div class="card-body">
            <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("error") %>
            </div>
            <% } %>
            <% if (request.getAttribute("message") != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <%= request.getAttribute("message") %>
            </div>
            <% } %>

            <% User user = (User) request.getAttribute("user"); %>
            <form action="${pageContext.request.contextPath}/updateProfile" method="post">
                <!-- Email (disabled) -->
                <div class="mb-3">
                    <label for="email" class="form-label">
                        <i class="fas fa-envelope"></i> Email (không thể thay đổi)
                    </label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-lock"></i></span>
                        <input type="email" class="form-control" id="email" value="<%= user.getEmail() %>" disabled>
                    </div>
                </div>

                <!-- Password -->
                <div class="mb-3">
                    <label for="password" class="form-label">
                        <i class="fas fa-key"></i> Mật khẩu mới
                    </label>
                    <input type="password" class="form-control" id="password" name="password" placeholder="Để trống nếu không đổi">
                    <% Map<String, String> errors = (Map<String, String>) request.getAttribute("errors");
                       if (errors != null && errors.containsKey("password")) { %>
                    <div class="error"><%= errors.get("password") %></div>
                    <% } %>
                </div>

                <!-- Confirm Password -->
                <div class="mb-3">
                    <label for="confirmPassword" class="form-label">
                        <i class="fas fa-redo"></i> Xác nhận mật khẩu
                    </label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Nhập lại mật khẩu mới">
                    <% if (errors != null && errors.containsKey("confirmPassword")) { %>
                    <div class="error"><%= errors.get("confirmPassword") %></div>
                    <% } %>
                </div>

                <!-- Name -->
                <div class="mb-3">
                    <label for="name" class="form-label">
                        <i class="fas fa-user"></i> Họ và tên
                    </label>
                    <input type="text" class="form-control" id="name" name="name" 
                           value="<%= request.getAttribute("name") != null ? request.getAttribute("name") : (user.getName() != null ? user.getName() : "") %>" 
                           required placeholder="Nguyễn Văn A">
                    <% if (errors != null && errors.containsKey("name")) { %>
                    <div class="error"><%= errors.get("name") %></div>
                    <% } %>
                </div>

                <!-- Phone -->
                <div class="mb-3">
                    <label for="phone" class="form-label">
                        <i class="fas fa-phone"></i> Số điện thoại
                    </label>
                    <input type="text" class="form-control" id="phone" name="phone" 
                           value="<%= request.getAttribute("phone") != null ? request.getAttribute("phone") : (user.getPhone() != null ? user.getPhone() : "") %>"
                           placeholder="0901234567">
                    <% if (errors != null && errors.containsKey("phone")) { %>
                    <div class="error"><%= errors.get("phone") %></div>
                    <% } %>
                </div>

                <!-- DOB -->
                <div class="mb-3">
                    <label for="dob" class="form-label">
                        <i class="fas fa-calendar-alt"></i> Ngày sinh
                    </label>
                    <input type="date" class="form-control" id="dob" name="dob" 
                           value="<%= request.getAttribute("dob") != null ? request.getAttribute("dob") : (user.getDob() != null ? user.getDob().toString() : "") %>">
                    <% if (errors != null && errors.containsKey("dob")) { %>
                    <div class="error"><%= errors.get("dob") %></div>
                    <% } %>
                </div>

                <!-- Gender -->
                <div class="mb-4">
                    <label class="form-label">
                        <i class="fas fa-venus-mars"></i> Giới tính
                    </label>
                    <div class="d-flex gap-4">
                        <div class="form-check">
                            <input type="radio" class="form-check-input" id="male" name="gender" value="1" 
                                   <%= (request.getAttribute("gender") != null ? request.getAttribute("gender") : (user.isGender() ? "1" : "0")).equals("1") ? "checked" : "" %> required>
                            <label class="form-check-label" for="male">Nam</label>
                        </div>
                        <div class="form-check">
                            <input type="radio" class="form-check-input" id="female" name="gender" value="0" 
                                   <%= (request.getAttribute("gender") != null ? request.getAttribute("gender") : (user.isGender() ? "1" : "0")).equals("0") ? "checked" : "" %>>
                            <label class="form-check-label" for="female">Nữ</label>
                        </div>
                    </div>
                    <% if (errors != null && errors.containsKey("gender")) { %>
                    <div class="error"><%= errors.get("gender") %></div>
                    <% } %>
                </div>

                <!-- Submit Button -->
                <button type="submit" class="btn btn-primary w-100">
                    <i class="fas fa-save"></i> Cập nhật hồ sơ
                </button>
            </form>

            <div class="text-center mt-3">
                <a href="home" class="btn btn-secondary">
                    <i class="fas fa-home"></i> Quay về trang chủ
                </a>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>