<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kết quả tìm kiếm - Hola Cinema</title>
    <link rel="stylesheet" href="styles/main.css"> <!-- nếu bạn có file css -->
</head>
<body>
<header>
    <a href="home" class="logo">🎬 Hola Cinema Center</a>
</header>

<h2>Kết quả tìm kiếm cho: "<c:out value='${searchKeyword}'/>"</h2>

<c:if test="${empty searchResults}">
    <p>Không tìm thấy phim nào phù hợp.</p>
</c:if>

<div class="movie-grid">
    <c:forEach var="m" items="${searchResults}">
        <div class="movie-card">
            <img src="${m.posterUrl}" alt="${m.title}" 
                 onerror="this.src='https://via.placeholder.com/220x300?text=No+Image'">
            <div class="movie-info">
                <div class="movie-title">${m.title}</div>
                <div class="movie-meta">⏱ ${m.durationMinutes} phút | ⭐ ${m.rating}</div>
                <a href="movieDetail?id=${m.movieId}" class="btn btn-details">Chi tiết</a>
            </div>
        </div>
    </c:forEach>
</div>

<footer>© 2025 Hola Cinema Center</footer>
</body>
</html>
