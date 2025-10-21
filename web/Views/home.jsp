<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hola Cinema Center</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f5f5f5;
        }
        .navbar-brand {
            font-weight: bold;
            font-size: 1.5rem;
        }
        .carousel-item img {
            width: 100%;
            height: 350px;
            object-fit: cover;
        }
        .movie-card {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 0 6px rgba(0,0,0,0.1);
            text-align: center;
            padding: 10px;
        }
        .movie-card img {
            border-radius: 5px;
            width: 100%;
            height: 250px;
            object-fit: cover;
        }
        footer {
            background-color: #222;
            color: white;
            text-align: center;
            padding: 15px;
            margin-top: 50px;
        }
    </style>
</head>
<body>

<%
    User user = (User) request.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
%>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-light bg-light shadow-sm">
    <div class="container">
        <a class="navbar-brand" href="#">Hola Cinema Center</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item"><a class="nav-link active" href="#">Home</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Movies</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Booking</a></li>
                <li class="nav-item"><a class="nav-link" href="#">News & Promotion</a></li>
                <li class="nav-item"><a class="nav-link" href="#">Contact</a></li>
            </ul>

            <div class="d-flex align-items-center gap-2">
                <span class="me-2 text-muted">Welcome, <%= user.getName() %></span>
                <a href="${pageContext.request.contextPath}/updateProfile" class="btn btn-outline-primary btn-sm">Update Profile</a>
                <a href="logout" class="btn btn-outline-danger btn-sm">Logout</a>
            </div>
        </div>
    </div>
</nav>

<!-- CAROUSEL -->
<div id="movieCarousel" class="carousel slide mt-3" data-bs-ride="carousel">
    <div class="carousel-inner">
        <div class="carousel-item active">
            <img src="https://via.placeholder.com/1200x350?text=Movie+Banner+1" alt="Banner 1">
        </div>
        <div class="carousel-item">
            <img src="https://via.placeholder.com/1200x350?text=Movie+Banner+2" alt="Banner 2">
        </div>
        <div class="carousel-item">
            <img src="https://via.placeholder.com/1200x350?text=Movie+Banner+3" alt="Banner 3">
        </div>
    </div>
    <button class="carousel-control-prev" type="button" data-bs-target="#movieCarousel" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#movieCarousel" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
    </button>
</div>

<!-- MOVIES SECTION -->
<div class="container my-5">
    <div class="d-flex align-items-center mb-3">
        <h4 class="me-4">🎬 Movies</h4>
        <a href="#" class="text-muted me-3 text-decoration-none">Coming Soon</a>
        <a href="#" class="text-primary text-decoration-none fw-bold">Now Showing</a>
    </div>

    <div class="row g-3">
        <% for (int i = 0; i < 6; i++) { %>
        <div class="col-md-4">
            <div class="movie-card">
                <img src="https://via.placeholder.com/300x250?text=Film+Poster" alt="Film Poster">
                <p class="mt-2">Film name</p>
            </div>
        </div>
        <% } %>
    </div>

    <div class="text-center mt-4">
        <a href="#" class="btn btn-dark btn-sm">More ></a>
    </div>
</div>

<footer>
    <p>© 2025 Hola Cinema Center. All rights reserved.</p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
