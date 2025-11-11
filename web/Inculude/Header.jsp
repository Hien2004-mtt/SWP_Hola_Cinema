<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Models.User" %>
<%
    User user = (User) session.getAttribute("user");
%>
<head>
    <meta charset="UTF-8">
    <title>Hola Cinema</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<style>
    .dropdown:hover .dropdown-menu {
    display: block;
    margin-top: 0.3rem;
}
</style>

<!-- 🌟 HEADER / NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-light bg-light shadow-sm">
    <div class="container">
        <% if (user != null && user.getRole() == 1) { %>
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/manager/dashboard.jsp">
            Hola Cinema Center
        </a>
        <% } else { %>
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">
            Hola Cinema Center
        </a>
        <% } %>


        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <% if (user != null && user.getRole() == 1) { %>
                <!-- 🔹 MENU CHO ADMIN / MANAGER -->
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/manager/dashboard.jsp">Dashboard</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/contact">Contact</a>
                </li>
                <% } else { %>
                <!-- 🔹 MENU CHO KHÁCH HÀNG -->
                <li class="nav-item">
                    <a class="nav-link <%= request.getRequestURI().contains("home") ? "active" : "" %>"
                       href="${pageContext.request.contextPath}/home">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/movies">Movies</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/booking">Booking</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/promotions">Promotions</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/contact">Contact</a>
                </li>
                <% } %>
            </ul>


            <div class="d-flex align-items-center gap-2">
    <% if (user != null) { %>
        <span class="me-2 text-muted"> Welcome, <b><%= user.getName() %></b></span>
        <div class="dropdown">
            <button class="btn btn-outline-primary btn-sm dropdown-toggle" type="button" id="profileMenu" data-bs-toggle="dropdown" aria-expanded="false">
                Profile
            </button>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="profileMenu">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/updateProfile"> Update Profile</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/transactionHistory"> Lịch sử giao dịch</a></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/voucher?action=list">️ Voucher</a></li>
            </ul>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">Logout</a>
    <% } else { %>
        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-success btn-sm">Login</a>
        <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-secondary btn-sm">Sign Up</a>
    <% } %>
</div>
        </div>
    </div>
<!--  Bootstrap JS Bundle (bắt buộc cho dropdown hoạt động) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
</nav>
