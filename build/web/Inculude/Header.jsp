<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Models.User" %>
<%
    User user = (User) session.getAttribute("user");
%>

<!-- ✅ Bootstrap & CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    /* === HEADER CHUNG === */
    .navbar {
        background-color: #ffffff !important;
        box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    }

    .navbar-brand {
        font-weight: 700;
        color: #e60000 !important;
        transition: 0.3s;
    }

    .navbar-brand:hover {
        color: #ff6f61 !important;
    }

    .navbar-nav .nav-link {
        color: #333 !important;
        font-weight: 500;
        transition: color 0.25s ease;
    }

    .navbar-nav .nav-link:hover,
    .navbar-nav .nav-link.active {
        color: #ff6f61 !important;
    }

    /* ✅ Nút Profile & Logout cùng màu cam đỏ */
    .btn-header {
        border: none;
        border-radius: 20px;
        padding: 6px 14px;
        font-weight: 500;
        color: #fff;
        background: linear-gradient(135deg, #ff4b2b, #ff416c); /* CAM → ĐỎ */
        cursor: pointer;
        transition: none; /* Không đổi màu khi hover */
    }

    .btn-header:hover,
    .btn-header:focus,
    .btn-header:active {
        background: linear-gradient(135deg, #ff4b2b, #ff416c);
        color: #fff;
        box-shadow: none;
        transform: none;
    }

    /* ✅ Dropdown đẹp hơn */
    .dropdown-menu {
        border-radius: 8px;
        border: 1px solid #eee;
        box-shadow: 0 4px 10px rgba(0,0,0,0.08);
    }

    .dropdown-item:hover {
        background-color: #fff4f0; /* Nền nhạt cam */
        color: #ff4b2b;
    }

</style>

<!-- ✅ HEADER -->
<nav class="navbar navbar-expand-lg navbar-light bg-light fixed-top shadow-sm">
    <div class="container">

        <!-- 🎬 LOGO -->
        <% if (user != null && user.getRole() == 1) { %>
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/manager/dashboard.jsp">
            🎬 Hola Cinema Center
        </a>
        <% } else { %>
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">
            🎬 Hola Cinema Center
        </a>
        <% } %>

        <!-- Toggle Menu -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- ✅ MENU -->
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <% if (user != null && user.getRole() == 1) { %>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/manager/dashboard.jsp">Dashboard</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/contact">Contact</a></li>
                    <% } else { %>
                <li class="nav-item">
                    <a class="nav-link <%= request.getRequestURI().contains("home") ? "active" : "" %>"
                       href="${pageContext.request.contextPath}/home">Home</a>
                </li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/movies">Movies</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/booking">Booking</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/manageNewsAndPromotion">Promotions</a></li>
                <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/contact">Contact</a></li>
                    <% } %>
            </ul>

            <!-- ✅ PHẦN PHẢI -->
            <div class="d-flex align-items-center gap-2">
                <% if (user != null) { %>
                <span class="me-2 text-muted">👋 Welcome, <b><%= user.getName() %></b></span>

                <!-- ✅ Dropdown Profile -->
                <div class="dropdown">
                    <button class="btn btn-header btn-sm dropdown-toggle"
                            type="button" id="profileMenu" data-bs-toggle="dropdown" aria-expanded="false">
                        Profile
                    </button>

                    <ul class="dropdown-menu dropdown-menu-end shadow-sm" aria-labelledby="profileMenu">
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/updateProfile">
                                ️ Update Profile
                            </a>
                        </li>

                        <% if (user.getRole() == 2) { %>
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/transactionHistory">
                                Lịch sử giao dịch
                            </a>
                        </li>
                        <% } %>

                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/voucher?action=list">
                                ️ Voucher
                            </a>
                        </li>
                    </ul>
                </div>

                <!-- ✅ Logout cùng màu -->
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-header btn-sm">Logout</a>
                <% } else { %>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-success btn-sm">Login</a>
                <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-secondary btn-sm">Sign Up</a>
                <% } %>
            </div>
        </div>
    </div>
</nav>

<!-- ✅ Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
