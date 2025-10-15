<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Lịch Chiếu</title>
    <link rel="stylesheet" href="css/admin.css">
</head>
<body>
    <div class="container">
        <div class="main-content">
            <h1>Quản Lý Lịch Chiếu</h1>
            <c:if test="${not empty success}">
                <p style="color: green;">${success}</p>
            </c:if>
            <c:if test="${not empty error}">
                <p style="color: red;">${error}</p>
            </c:if>
            <form action="manageSchedule" method="post">
                <label for="movieId">Chọn Phim:</label>
                <select name="movieId" required>
                    <c:forEach var="movie" items="${upcomingMovies}">
                        <option value="${movie.movieId}">${movie.movieName}</option>
                    </c:forEach>
                </select><br>
                <label for="auditoriumId">Chọn Phòng:</label>
                <select name="auditoriumId" required>
                    <c:forEach var="auditorium" items="${activeAuditoriums}">
                        <option value="${auditorium.auditoriumId}">${auditorium.auditoriumName}</option>
                    </c:forEach>
                </select><br>
                <label for="startTime">Thời gian bắt đầu:</label>
                <input type="datetime-local" name="startTime" required><br>
                <label for="endTime">Thời gian kết thúc:</label>
                <input type="datetime-local" name="endTime" required><br>
                <label for="price">Giá vé (VND):</label>
                <input type="number" name="price" step="1000" required><br>
                <button type="submit">Thêm Lịch Chiếu</button>
            </form>
            <h2>Danh Sách Lịch Chiếu</h2>
            <table border="1">
                <thead>
                    <tr>
                        <th>ID Lịch</th>
                        <th>Tên Phim</th>
                        <th>Phòng</th>
                        <th>Thời gian bắt đầu</th>
                        <th>Thời gian kết thúc</th>
                        <th>Giá vé (VND)</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Dữ liệu lịch chiếu có thể được thêm từ cơ sở dữ liệu sau -->
                    <c:forEach var="schedule" items="${scheduleList}">
                        <tr>
                            <td>${schedule.showtimeId}</td>
                            <td>${schedule.movieName}</td>
                            <td>${schedule.auditoriumName}</td>
                            <td>${schedule.startTime}</td>
                            <td>${schedule.endTime}</td>
                            <td>${schedule.price}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    <footer>
        <p>&copy; 2025 Cinema Booking System - <%= new java.util.Date() %></p>
    </footer>
</body>
</html>

