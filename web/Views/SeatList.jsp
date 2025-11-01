<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách phòng chiếu</title>
         <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SeatList.css">
    </head>
    <body>

        <div class="container">
            <h2>Danh sách phòng chiếu</h2>

            <!-- Form tìm kiếm -->
            <form method="get" action="seatList">
                <div class="search-bar">
                    <div class="search-input">
                        <input type="text" name="q" placeholder="Tìm kiếm phòng..." value="${q}">
                    </div>
                    <button type="submit" class="btn btn-add">Tìm kiếm</button>
                </div>
            </form>

            <!-- ✅ Bảng danh sách -->
            <table>
                <thead>
                    <tr>
                        <th>Auditorium ID</th>
                        <th>Total Seat</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="a" items="${auditoriums}">
                        <tr>
                            <td>${a.auditoriumId}</td>
                            <td>${a.totalSeat}</td>
                            <td>
                                <a href="seatEdit?auditoriumId=${a.auditoriumId}">
                                    <button class="btn btn-update">Update</button>
                                </a>
                                <a href="seatDelete?auditoriumId=${a.auditoriumId}">
                                    <button class="btn btn-delete">Delete</button>
                                </a>
                                <a href="seatDetail?auditoriumId=${a.auditoriumId}">
                                    <button class="btn btn-detail">Detail</button>
                                </a>
                                <a href="seatAddRowForm?auditoriumId=${a.auditoriumId}">
                                    <button class="btn btn-add">Add Row</button>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <!-- Phân trang (fix lỗi NumberFormatException) -->
            <div class="pagination">
                <c:if test="${currentPage > 1}">
                    <a href="seatList?page=${currentPage - 1}&q=${q}">
                        <button class="page-btn">&larr; Previous</button>
                    </a>
                </c:if>

                <c:forEach begin="1" end="${totalPages}" var="p">
                    <a href="seatList?page=${p}&q=${q}">
                        <button class="page-btn ${p == currentPage ? 'active' : ''}">${p}</button>
                    </a>
                </c:forEach>

                <c:if test="${currentPage < totalPages}">
                    <a href="seatList?page=${currentPage + 1}&q=${q}">
                        <button class="page-btn">Next &rarr;</button>
                    </a>
                </c:if>
            </div>
        </div>
    </body>
</html>
