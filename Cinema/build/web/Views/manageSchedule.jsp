<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
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
                <input type="hidden" name="action" value="add"/>
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
                <label for="basePrice">Giá vé (VND):</label>
                <input type="number" name="basePrice" step="1000" required><br>
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
                    <c:forEach var="schedule" items="${scheduleList}">
                        <tr>
                            <td>${schedule.showtimeId}</td>
                            <td>${schedule.movieName}</td>
                            <td>${schedule.auditoriumName}</td>
                            <td>${schedule.startTime}</td>
                            <td>${schedule.endTime}</td>
                            <td>${schedule.price}</td>
                        </tr>
                        <tr>
                            <td colspan="6">
                                <form action="manageSchedule" method="post" style="display:inline-block;margin-right:12px;">
                                    <input type="hidden" name="action" value="update"/>
                                    <input type="hidden" name="showtimeId" value="${schedule.showtimeId}"/>
                                    <label>Phim:</label>
                                    <select name="movieId" required>
                                        <c:forEach var="movie" items="${upcomingMovies}">
                                            <option value="${movie.movieId}" <c:if test="${movie.movieId == schedule.movieId}">selected</c:if>>${movie.movieName}</option>
                                        </c:forEach>
                                    </select>
                                    <label>Phòng:</label>
                                    <select name="auditoriumId" required>
                                        <c:forEach var="auditorium" items="${activeAuditoriums}">
                                            <option value="${auditorium.auditoriumId}" <c:if test="${auditorium.auditoriumId == schedule.auditoriumId}">selected</c:if>>${auditorium.auditoriumName}</option>
                                        </c:forEach>
                                    </select>
                                    <label>Bắt đầu:</label>
                                    <fmt:formatDate value="${schedule.startTime}" pattern="yyyy-MM-dd'T'HH:mm" var="_startVal"/>
                                    <input type="datetime-local" name="startTime" value="${_startVal}" required/>
                                    <label>Kết thúc:</label>
                                    <fmt:formatDate value="${schedule.endTime}" pattern="yyyy-MM-dd'T'HH:mm" var="_endVal"/>
                                    <input type="datetime-local" name="endTime" value="${_endVal}" required/>
                                    <label>Giá:</label>
                                    <input type="number" name="basePrice" step="1000" value="${schedule.price}" required/>
                                    <button type="submit">Cập nhật</button>
                                </form>
                                <form action="manageSchedule" method="post" style="display:inline-block;">
                                    <input type="hidden" name="action" value="delete"/>
                                    <input type="hidden" name="showtimeId" value="${schedule.showtimeId}"/>
                                    <button type="submit" onclick="return confirm('Xóa lịch chiếu này?')">Xóa</button>
                                </form>
                            </td>
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

