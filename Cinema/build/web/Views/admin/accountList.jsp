<%-- 
    Document   : accountList
    Created on : Sep 26, 2025, 8:32:13 AM
    Author     : ASUS
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh Sách Tài Khoản</title>
    <link rel="stylesheet" href="css/admin.css">
</head>
<body>
    <header>
        <h1>Quản Trị Hệ Thống - Danh Sách Tài Khoản</h1>
        <nav>
            <a href="dashboard.jsp">Dashboard</a> |
            <a href="manageShowtimes.jsp">Quản Lý Lịch Chiếu</a> |
            <a href="viewRevenue.jsp">Xem Doanh Thu</a> |
            <a href="logout">Đăng Xuất</a>
        </nav>
    </header>
    
    <main>
        <h2>Danh Sách Người Dùng</h2>
        <table border="1">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Email</th>
                    <th>Tên</th>
                    <th>Số Điện Thoại</th>
                    <th>Ngày Sinh</th>
                    <th>Giới Tính</th>
                    <th>Vai Trò</th>
                    <th>Hành Động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="user" items="${userList}">
                    <tr>
                        <td>${user.user_id}</td>
                        <td>${user.email}</td>
                        <td>${user.name}</td>
                        <td>${user.phone}</td>
                        <td>${user.dob}</td>
                        <td>${user.gender == 1 ? 'Nam' : 'Nữ'}</td>
                        <td>
                            <c:choose>
                                <c:when test="${user.role == 0}">Admin</c:when>
                                <c:when test="${user.role == 1}">Manager</c:when>
                                <c:when test="${user.role == 2}">Customer</c:when>
                            </c:choose>
                        </td>
                        <td>
                            <a href="editRole.jsp?user_id=${user.user_id}">Chỉnh Sửa Vai Trò</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <form action="searchUser" method="get">
            <input type="text" name="search" placeholder="Tìm kiếm theo email hoặc tên">
            <button type="submit">Tìm Kiếm</button>
        </form>
    </main>
    
    <footer>
        <p>&copy; 2025 Cinema Booking System</p>
    </footer>
</body>
</html>
