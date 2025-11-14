<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="Models.User" %>
<%
    User user = (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Hola Cinema Center</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

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

        /* ⭐ SLIDER NEW ⭐ */
        .slider {
            width: 100%;
            height: 350px;
            overflow: hidden;
            position: relative;
            margin: 0 auto;
        }
        .slide-item {
            width: 100%;
            height: 350px;
            position: absolute;
            opacity: 0;
            transition: opacity 1.5s ease;
        }
        .slide-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .slide-item.active {
            opacity: 1;
        }
        .slider-btn {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            font-size: 30px;
            padding: 6px 14px;
            background: rgba(0,0,0,0.3);
            color: white;
            cursor: pointer;
            border-radius: 5px;
            user-select: none;
        }
        .slider-btn:hover {
            background: rgba(0,0,0,0.6);
        }
        .slider-btn.prev { left: 15px; }
        .slider-btn.next { right: 15px; }

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
        }

        /* ⭐ NEW CONTACT FOOTER ⭐ */
        footer {
            text-align: center;
            background: var(--text-dark);
            color: #aaa;
            padding: 25px;
            font-size: 14px;
            margin-top: 60px;
        }
        footer a { color: #ff6f61; text-decoration: none; }
        footer a:hover { text-decoration: underline; }
    </style>
</head>

<body>

<header>
    <div class="logo">🎬 Hola Cinema Center</div>

    <nav>
        <ul>
            <li><a href="home" class="active">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/movies">Movies</a></li>
            <li><a href="#">Booking</a></li>
            <li><a href="${pageContext.request.contextPath}/manageNewsAndPromotion">News & Promotions</a></li>

            <!-- ⭐ Nút Contact nhảy xuống footer ⭐ -->
            <li><a href="#contact-info">Contact</a></li>

        </ul>
    </nav>

    <div class="nav-right">
        <form action="home" method="get" class="search-box">
            <input type="text" name="q" placeholder="Search..." value="${param.q}">
        </form>

        <c:choose>
            <c:when test="${not empty loggedUser}">
                <span>Xin chào, <strong>${loggedUser.name}</strong></span>

                <div class="dropdown">
                    <button class="btn btn-outline-primary btn-sm dropdown-toggle"
                            type="button" id="profileMenu"
                            data-bs-toggle="dropdown" aria-expanded="false">
                        Profile
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm" aria-labelledby="profileMenu">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/updateProfile">Update Profile</a></li>

                        <% if (user != null && user.getRole() == 2) { %>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/transactionHistory">Lịch sử giao dịch</a></li>
                        <% } %>

                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/voucher?action=list">Voucher</a></li>
                    </ul>
                </div>

                <a href="logout" class="btn btn-danger">Đăng xuất</a>

            </c:when>
            <c:otherwise>
                <a href="login.jsp" class="btn btn-success">Sign in</a>
                <a href="register" class="btn btn-secondary">Register</a>
            </c:otherwise>
        </c:choose>
    </div>
</header>

<!-- SLIDER -->
<div class="slider">

    <div class="slide-item active">
        <img src="https://image.tmdb.org/t/p/original/5YZbUmjbMa3ClvSW1Wj3D6XGolb.jpg">
    </div>

    <div class="slide-item">
        <img src="https://image.tmdb.org/t/p/original/6Lw54zxm6BAEKJeGlabyzzR5Juu.jpg">
    </div>

    <div class="slide-item">
        <img src="https://www.cgv.vn/media/catalog/product/cache/3/image/c5f0a1eff4c394a251036189ccddaacd/m/a/main_poster_-_dmmovie2023.jpg">
    </div>

    <div class="slider-btn prev" onclick="moveSlide(-1)">❮</div>
    <div class="slider-btn next" onclick="moveSlide(1)">❯</div>
</div>

<!-- NOW SHOWING -->
<div class="movies-section">
    <div class="section-header"><h2>Now Showing</h2></div>

    <c:if test="${empty moviesNow}">
        <p>No movies are currently showing.</p>
    </c:if>

    <div class="movie-grid">
        <c:forEach var="m" items="${moviesNow}">
            <div class="movie-card">
                <img src="${m.posterUrl}" alt="${m.title}">
                <div class="movie-info">
                    <div class="movie-title">${m.title}</div>
                    <div class="movie-meta">⏱ ${m.durationMinutes} mins | ⭐ ${m.rating}</div>
                    <a href="movieDetail?id=${m.movieId}" class="btn btn-details">Details</a>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<!-- COMING SOON -->
<div class="movies-section">
    <div class="section-header"><h2>Coming Soon</h2></div>

    <c:if test="${empty moviesComing}">
        <p>No upcoming movies at the moment.</p>
    </c:if>

    <div class="movie-grid">
        <c:forEach var="m" items="${moviesComing}">
            <div class="movie-card">
                <img src="${m.posterUrl}" alt="${m.title}">
                <div class="movie-info">
                    <div class="movie-title">${m.title}</div>
                    <div class="movie-meta">⏱ ${m.durationMinutes} mins | ⭐ ${m.rating}</div>
                    <a href="movieDetail?id=${m.movieId}" class="btn btn-details">Details</a>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<!-- ⭐⭐⭐ FOOTER WITH CONTACT ⭐⭐⭐ -->
<footer id="contact-info">
    <h4 style="color: #fff; margin-bottom: 10px;">📞 Contact Us</h4>

    <p style="margin: 0; color: #ccc;"><strong>Nhóm 6 – SWP FPT Hola</strong></p>

    <p style="margin: 0; color: #ccc;">
        Email: <a href="mailto:hienmtthe180121@fpt.edu.vn">hienmtthe180121@fpt.edu.vn</a>
    </p>

    <p style="margin: 0; color: #ccc;">
        Phone: <a href="tel:0366488977">0366488977</a>
    </p>

    <br>

    <p style="color: #777; font-size: 13px;">
        © 2025 Hola Cinema Center — Designed by Team 6.
    </p>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- SLIDER JS -->
<script>
    let index = 0;
    const slides = document.getElementsByClassName("slide-item");

    function showSlide() {
        for (let i = 0; i < slides.length; i++) slides[i].classList.remove("active");

        index++;
        if (index > slides.length) index = 1;

        slides[index - 1].classList.add("active");
        setTimeout(showSlide, 4000);
    }
    showSlide();

    function moveSlide(n) {
        index += n - 1;
        if (index < 1) index = slides.length;
        if (index > slides.length) index = 1;

        for (let i = 0; i < slides.length; i++) slides[i].classList.remove("active");
        slides[index - 1].classList.add("active");
    }
</script>

</body>
</html>
