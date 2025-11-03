<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hola Cinema Center</title>
    <style>
        :root {
            --primary-color: #5a2fc2;
            --accent-color: #ff6f61;
            --bg-light: #fafafa;
            --text-dark: #222;
            --card-bg: #fff;
        }
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: var(--bg-light);
            color: var(--text-dark);
        }
        header {
            background: var(--card-bg);
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            padding: 10px 60px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        .logo {
            font-size: 24px;
            font-weight: 700;
            color: var(--primary-color);
        }
        nav ul {
            list-style: none;
            display: flex;
            gap: 30px;
            margin: 0;
            padding: 0;
        }
        nav ul li a {
            text-decoration: none;
            color: #444;
            font-weight: 500;
        }
        nav ul li a:hover, nav ul li a.active {
            color: var(--accent-color);
        }
        .nav-right {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .search-box input {
            padding: 6px 12px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .btn {
            background: var(--accent-color);
            color: #fff;
            border: none;
            padding: 8px 16px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
        }
        .btn:hover {
            background: #e55b50;
        }
        .banner {
            width: 100%;
            height: 350px;
            background: linear-gradient(135deg, var(--primary-color), var(--accent-color));
            display: flex;
            align-items: center;
            justify-content: center;
            color: #fff;
            font-size: 36px;
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 1.5px;
        }
        .movies-section {
            padding: 50px 60px;
        }
        .section-header {
            display: flex;
            align-items: center;
            gap: 15px;
            border-left: 5px solid var(--primary-color);
            padding-left: 10px;
            margin-bottom: 30px;
        }
        .section-header h2 {
            font-size: 24px;
            margin: 0;
            color: var(--text-dark);
        }
        .movie-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 30px;
            margin-top: 20px;
        }
        .movie-card {
            background: var(--card-bg);
            border-radius: 12px;
            overflow: hidden;
            text-align: center;
            box-shadow: 0 4px 10px rgba(0,0,0,0.08);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .movie-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 6px 14px rgba(0,0,0,0.12);
        }
        .movie-card img {
            width: 100%;
            height: 300px;
            object-fit: cover;
            transition: filter 0.3s;
        }
        .movie-card:hover img {
            filter: brightness(1.1);
        }
        .movie-info {
            padding: 12px 16px;
        }
        .movie-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--text-dark);
            margin-bottom: 8px;
        }
        .movie-meta {
            font-size: 14px;
            color: #666;
            margin-bottom: 12px;
        }
        .movie-card .btn-details {
            margin-bottom: 16px;
            display: inline-block;
        }
        footer {
            text-align: center;
            background: var(--text-dark);
            color: #aaa;
            padding: 20px;
            font-size: 14px;
            margin-top: 60px;
        }
        @media (max-width: 768px) {
            header {
                padding: 10px 30px;
                flex-wrap: wrap;
            }
            .movies-section {
                padding: 30px 20px;
            }
            .banner {
                height: 250px;
                font-size: 28px;
            }
        }
    </style>
</head>
<body>

<header>
    <div class="logo">🎬 Hola Cinema Center</div>

    <nav>
        <ul>
            <li><a href="home" class="active">Home</a></li>
            <li><a href="#">Movies</a></li>
            <li><a href="#">Booking</a></li>
            <li><a href="#">News & Promotion</a></li>
            <li><a href="#">Contact</a></li>
        </ul>
    </nav>

    <div class="nav-right">
<form action="home" method="get" class="search-box">
    <input type="text" name="q" placeholder="Search..." 
           value="${param.q}" style="padding:6px 12px;border:1px solid #ccc;border-radius:5px;">
</form>


              <c:choose>
            <c:when test="${not empty loggedUser}">
                <span>Xin chào, <strong>${loggedUser.name}</strong></span>
                <!-- 🔹 Nút đi đến trang hồ sơ người dùng -->
                <a href="updateProfile" class="btn">Profile</a>
                <a href="logout" class="btn">Đăng xuất</a>
            </c:when>
            <c:otherwise>
                <a href="login.jsp" class="btn">Sign in</a>
                <a href="register.jsp" class="btn">Register</a>
            </c:otherwise>
        </c:choose>
    </div>
</header>

<div class="banner">
    Welcome to Hola Cinema — Experience Now
</div>

<div class="movies-section">
    <div class="section-header">
        <h2>Phim đang chiếu</h2>
    </div>
    <c:if test="${empty moviesNow}">
        <p>Hiện chưa có phim đang chiếu.</p>
    </c:if>
    <div class="movie-grid">
        <c:forEach var="m" items="${moviesNow}">
            <div class="movie-card">
                <img src="${m.posterUrl}" alt="${m.title}" onerror="this.src='https://via.placeholder.com/220x300?text=No+Image'">
                <div class="movie-info">
                    <div class="movie-title">${m.title}</div>
                    <div class="movie-meta">⏱ ${m.durationMinutes} phút | ⭐ ${m.rating}</div>
                    <a href="movieDetail?id=${m.movieId}" class="btn btn-details">Chi tiết</a>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<div class="movies-section" style="background-color: #fff; margin-top: 40px;">
    <div class="section-header">
        <h2>Phim sắp chiếu</h2>
    </div>
    <c:if test="${empty moviesComing}">
        <p>Hiện chưa có phim sắp chiếu.</p>
    </c:if>
    <div class="movie-grid">
        <c:forEach var="m" items="${moviesComing}">
            <div class="movie-card">
                <img src="${m.posterUrl}" alt="${m.title}" onerror="this.src='https://via.placeholder.com/220x300?text=No+Image'">
                <div class="movie-info">
                    <div class="movie-title">${m.title}</div>
                    <div class="movie-meta">⏱ ${m.durationMinutes} phút | ⭐ ${m.rating}</div>
                    <a href="movieDetail?id=${m.movieId}" class="btn btn-details">Chi tiết</a>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<footer>
    © 2025 Hola Cinema Center — Thiết kế bởi nhóm của bạn.
</footer>

</body>
</html>
