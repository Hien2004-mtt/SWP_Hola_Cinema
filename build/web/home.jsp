<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hola Cinema Center</title>
    <style>
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #fafafa;
            color: #333;
        }

        /* HEADER */
        header {
            background: #fff;
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
            font-size: 22px;
            font-weight: 700;
            color: #111;
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
            color: #007bff;
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .search-box input {
            padding: 5px 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .btn {
            background: #007bff;
            color: #fff;
            border: none;
            padding: 6px 12px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
        }

        .btn:hover {
            background: #0056b3;
        }

        /* BANNER */
        .banner {
            width: 100%;
            height: 300px;
            background: #ddd url('https://via.placeholder.com/1200x300?text=Cinema+Banner') center/cover no-repeat;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 32px;
            font-weight: bold;
        }

        /* MOVIE SECTION */
        .movies-section {
            padding: 40px 60px;
            background: #fff;
        }

        .section-header {
            display: flex;
            align-items: center;
            gap: 15px;
            border-left: 5px solid #007bff;
            padding-left: 10px;
            margin-bottom: 25px;
        }

        .section-header h2 {
            font-size: 22px;
            margin: 0;
            color: #111;
        }

        .movie-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }

        .movie-card {
            background: #f9f9f9;
            border-radius: 10px;
            overflow: hidden;
            text-align: center;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s;
        }

        .movie-card:hover {
            transform: translateY(-5px);
        }

        .movie-card img {
            width: 100%;
            height: 280px;
            object-fit: cover;
        }

        .movie-card h3 {
            font-size: 16px;
            margin: 10px 0 5px;
        }

        .movie-card p {
            font-size: 13px;
            color: #777;
        }

        footer {
            text-align: center;
            background: #222;
            color: #aaa;
            padding: 15px;
            font-size: 13px;
            margin-top: 40px;
        }
    </style>
</head>
<body>

<!-- HEADER -->
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
        <div class="search-box">
            <input type="text" placeholder="Search...">
        </div>
        <c:choose>
            <c:when test="${not empty loggedUser}">
                <span>Xin chào, <strong>${loggedUser.name}</strong></span>
                <a href="logout" class="btn">Đăng xuất</a>
            </c:when>
            <c:otherwise>
                <a href="login.jsp" class="btn">Sign in</a>
                <a href="register.jsp" class="btn">Register</a>
            </c:otherwise>
        </c:choose>
    </div>
</header>

<!-- BANNER -->
<div class="banner">
    Welcome to Hola Cinema 🎥
</div>

<!-- PHIM ĐANG CHIẾU -->
<div class="movies-section">
    <div class="section-header">
        <h2>🎞 Phim đang chiếu</h2>
    </div>

    <c:if test="${empty moviesNow}">
        <p>Hiện chưa có phim đang chiếu.</p>
    </c:if>

    <div class="movie-grid">
        <c:forEach var="m" items="${moviesNow}">
            <div class="movie-card">
                <img src="${m.posterUrl}" alt="${m.title}">
                <h3>${m.title}</h3>
                <p>⏱ ${m.durationMinutes} phút | ⭐ ${m.rating}</p>
                <a href="movieDetail?id=${m.movieId}" class="btn">Chi tiết</a>
            </div>
        </c:forEach>
    </div>
</div>

<!-- PHIM SẮP CHIẾU -->
<div class="movies-section">
    <div class="section-header">
        <h2>🎬 Phim sắp chiếu</h2>
    </div>

    <c:if test="${empty moviesComing}">
        <p>Hiện chưa có phim sắp chiếu.</p>
    </c:if>

    <div class="movie-grid">
        <c:forEach var="m" items="${moviesComing}">
            <div class="movie-card">
                <img src="${m.posterUrl}" alt="${m.title}">
                <h3>${m.title}</h3>
                <p>⏱ ${m.durationMinutes} phút | ⭐ ${m.rating}</p>
                <a href="movieDetail?id=${m.movieId}" class="btn">Chi tiết</a>
            </div>
        </c:forEach>
    </div>
</div>

<footer>
    © 2025 Hola Cinema Center — Thiết kế bởi nhóm của bạn.
</footer>

</body>
</html>
