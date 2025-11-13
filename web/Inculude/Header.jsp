<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Models.User" %>
<%
    User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Hola Cinema Center</title>
    <!-- ✅ Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .navbar {
            background-color: #fff !important;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }

        .navbar-brand {
            font-weight: 700;
            color: #e60000 !important;
        }

        .navbar-nav .nav-link {
            color: #333 !important;
            font-weight: 500;
            transition: color 0.25s;
        }

        .navbar-nav .nav-link:hover,
        .navbar-nav .nav-link.active {
            color: #ff6f61 !important;
        }

        /* ✅ Nút Profile */
        .btn-profile {
            border-radius: 20px;
            padding: 6px 14px;
            font-weight: 500;
            
            color:  #fff;
            background: #ff6f61;
            transition: all 0.3s ease;
            
        }

        .btn-profile:hover {
            background: #007bff;
            color: #fff;
            
        }

        /* ✅ Menu dropdown */
        .dropdown-menu {
            border-radius: 8px;
            border: 1px solid #eee;
            box-shadow: 0 4px 10px rgba(0,0,0,0.08);
        }
        .btn-outline-danger{
            border-radius: 20px;
            padding: 6px 14px;
            font-weight: 500;
            
            color:  #fff;
            background: #ff6f61;
            transition: all 0.3s ease;
        }
                /* Khi header cố định, thêm padding trên body để nội dung không bị che */
        body {
            padding-top: 70px; /* tương ứng chiều cao navbar */
        }
        
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container">
        <!-- LOGO -->
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">
            Hola Cinema Center
        </a>

        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- MENU CHÍNH -->
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/home">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/movies">Movies</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/booking">Booking</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/promotions">Promotions</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/contact">Contact</a></li>
            </ul>

            <!-- PHẦN PHẢI -->
            <div class="d-flex align-items-center gap-2">
                <% if (user != null) { %>
                    <span class="me-2 text-muted">Welcome, <b><%= user.getName() %></b></span>

                    <!-- ✅ Dropdown chỉ mở khi CLICK -->
                    <div class="dropdown">
                        <button class="btn btn-profile btn-sm dropdown-toggle"
                                type="button"
                                id="profileMenu"
                                data-bs-toggle="dropdown"
                                aria-expanded="false">
                            Profile
                        </button>
                        <ul class="dropdown-menu dropdown-menu-end shadow-sm" aria-labelledby="profileMenu">
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/updateProfile">
                                    Update Profile
                                </a>
                            </li>

                            <%-- ✅ Chỉ hiển thị Lịch sử giao dịch nếu role ≠ 2 --%>
                            <% if (user.getRole() == 2) { %>
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/transactionHistory">
                                    Lịch sử giao dịch
                                </a>
                            </li>
                            <% } %>

                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/voucher?action=list">
                                    Voucher
                                </a>
                            </li>
                        </ul>
                    </div>

                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">Đăng xuất</a>
                <% } else { %>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-success btn-sm">Login</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-secondary btn-sm">Sign Up</a>
                <% } %>
            </div>
        </div>
    </div>
</nav>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
