<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách phòng chiếu</title>
        <style>
            body {
                font-family: 'Poppins', sans-serif;
                background: #f8f9fb;
                margin: 0;
                padding: 0;
            }
            .container {
                width: 80%;
                margin: 50px auto;
                background: white;
                border-radius: 12px;
                box-shadow: 0 0 15px rgba(0,0,0,0.1);
                padding: 30px;
            }
            h2 {
                text-align: center;
                color: #333;
                margin-bottom: 30px;
            }
            .search-bar {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
            }
            .search-input {
                display: flex;
                align-items: center;
                background: #f0f2f5;
                border-radius: 25px;
                padding: 5px 15px;
                width: 250px;
            }
            .search-input input {
                border: none;
                background: none;
                outline: none;
                padding: 8px;
                width: 100%;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }
            th, td {
                text-align: center;
                padding: 12px;
                border-bottom: 1px solid #eee;
            }
            th {
                background: #f1f3f6;
                color: #333;
            }
            tr:hover {
                background-color: #f8f9fb;
            }
            .btn {
                border: none;
                padding: 8px 14px;
                border-radius: 6px;
                font-size: 14px;
                cursor: pointer;
                margin: 0 3px;
                transition: 0.2s;
            }
            .btn-update {
                background: #007bff;
                color: white;
            }
            .btn-update:hover {
                background: #0056b3;
            }
            .btn-add {
                background: #28a745;
                color: white;
            }
            .btn-add:hover {
                background: #1e7e34;
            }
            .btn-delete {
                background: red;
                color: white;
            }
            .btn-delete:hover {
                background: #b80000;
            }
            .btn-detail {
                background: #6c757d;
                color: white;
            }
            .btn-detail:hover {
                background: #495057;
            }
            .pagination {
                display: flex;
                justify-content: center;
                margin-top: 25px;
                gap: 8px;
            }
            .page-btn {
                border: none;
                background: #e9ecef;
                padding: 6px 12px;
                border-radius: 5px;
                cursor: pointer;
                transition: 0.2s;
            }
            .page-btn.active {
                background: #007bff;
                color: white;
            }
            .page-btn:hover {
                background: #d6d8db;
            }
        </style>
    </head>
    <body>

        <div class="container">
            <h2>Danh sách phòng chiếu</h2>

            <!-- ✅ Form tìm kiếm -->
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

            <!-- ✅ Phân trang (fix lỗi NumberFormatException) -->
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
