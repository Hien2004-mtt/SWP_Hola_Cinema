<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>${movie.title} | Hola Cinema</title>
    <style>
        body {
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #fafafa;
            margin: 0;
            color: #333;
        }
        .container {
            max-width: 1100px;
            margin: 40px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .movie-header {
            display: flex;
            gap: 30px;
            padding: 30px;
        }
        .movie-header img {
            width: 300px;
            border-radius: 10px;
            object-fit: cover;
        }
        .info h1 {
            margin: 0;
            color: #5a2fc2;
        }
        .meta {
            color: #666;
            margin: 8px 0;
            font-size: 14px;
        }
        .genres span {
            background: #5a2fc2;
            color: #fff;
            padding: 3px 8px;
            border-radius: 5px;
            margin-right: 5px;
            font-size: 13px;
        }
        .section {
            padding: 20px 30px;
            border-top: 1px solid #eee;
        }
        .actor-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
        .actor-card {
            width: 150px;
            text-align: center;
        }
        .actor-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 10px;
        }
        .review {
            background: #fafafa;
            border-radius: 8px;
            padding: 10px 15px;
            margin-bottom: 10px;
        }
        .review strong {
            color: #222;
        }

        /* ------------------- NÚT HÀNH ĐỘNG ------------------- */
        .action-buttons {
            margin-top: 20px;
            display: flex;
            gap: 15px;
        }
        .btn {
            display: inline-block;
            padding: 10px 18px;
            font-size: 15px;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 600;
            transition: 0.3s;
        }
        .btn-book {
            background-color: #ff6f61;
            color: white;
        }
        .btn-book:hover {
            background-color: #e65b4f;
        }
        .btn-back {
            background-color: #5a2fc2;
            color: white;
        }
        .btn-back:hover {
            background-color: #4627a0;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="movie-header">
        <img src="${movie.posterUrl}" alt="${movie.title}">
        <div class="info">
            <h1>${movie.title}</h1>
            <div class="meta">
                ⏱ ${movie.durationMinutes} phút |
                ⭐ ${movie.rating} |
                Ngôn ngữ: ${movie.language}
            </div>
            <div class="genres">
                <c:forEach var="g" items="${genres}">
                    <span>${g}</span>
                </c:forEach>
            </div>
            <p>${movie.description}</p>
            <p><strong>Ngày phát hành:</strong> ${movie.releaseDate}</p>
            <h3>🎬 Đạo diễn: ${movie.directorName}</h3>

            <!-- ====== NÚT HÀNH ĐỘNG ====== -->
            <div class="action-buttons">
                <a href="selectionShowtime?movieId=${movie.movieId}" class="btn btn-book">🎟️ Đặt vé ngay</a>
                <a href="home" class="btn btn-back">⬅️ Quay lại trang chủ</a>
            </div>
        </div>
    </div>

    <div class="section">
        <h2>👨‍🎤 Diễn viên</h2>
        <div class="actor-grid">
            <c:forEach var="a" items="${actors}">
                <div class="actor-card">
                    <img src="https://via.placeholder.com/150x200?text=Actor" alt="${a.name}">
                    <div><strong>${a.name}</strong></div>
                </div>
            </c:forEach>
        </div>
    </div>

    <div class="section">
        <h2>💬 Đánh giá của khán giả</h2>
        <c:if test="${empty reviews}">
            <p>Chưa có đánh giá nào cho phim này.</p>
        </c:if>
        <c:forEach var="r" items="${reviews}">
            <div class="review">
                <strong>${r.userName}</strong> — ⭐ ${r.rating}/5 <br>
                <em>${r.comment}</em><br>
                <small>${r.createdAt}</small>
            </div>
        </c:forEach>
    </div>
</div>

</body>
</html>
