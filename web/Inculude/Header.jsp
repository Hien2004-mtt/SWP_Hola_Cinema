<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Models.User" %>
<%
    User user = (User) session.getAttribute("user");
%>
<head>
    <meta charset="UTF-8">
    <title>Hola Cinema</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/header.css">
</head>

<!-- 🌟 HEADER / NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-light bg-light shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">Hola Cinema Center</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link <%= request.getRequestURI().contains("home") ? "active" : "" %>" href="${pageContext.request.contextPath}/home">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Movies</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Booking</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Promotions</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Contact</a></li>
            </ul>

            <div class="d-flex align-items-center gap-2">
                <% if (user != null) { %>
                <span class="me-2 text-muted">👋 Welcome, <b><%= user.getName() %></b></span>
                <a href="${pageContext.request.contextPath}/updateProfile" class="btn btn-outline-primary btn-sm">Profile</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">Logout</a>
                <% } else { %>
                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-success btn-sm">Login</a>
                <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-secondary btn-sm">Sign Up</a>
                <% } %>
            </div>
        </div>
    </div>
</nav>
