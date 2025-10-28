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

            .search-input i {
                color: #666;
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
                gap: 10px;
            }

            .page-btn {
                border: none;
                background: #e9ecef;
                padding: 6px 12px;
                border-radius: 5px;
                cursor: pointer;
            }

            .page-btn.active {
                background: #007bff;
                color: white;
            }
        </style>
    </head>
    <body>

        <div class="container">
            <h2>Danh sách phòng chiếu</h2>

            <!-- Thanh tìm kiếm -->
            <div class="search-bar">
                <div class="search-input">
                    <i>🔍</i>
                    <input type="text" id="searchInput" placeholder="Tìm kiếm phòng...">
                </div>
            </div>

            <!-- Bảng danh sách phòng -->
            <table id="auditoriumTable">
                <thead>
                    <tr>
                        <th>Auditorium ID</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="a" items="${auditoriums}">
                        <tr>
                            <td>#${a.auditoriumId}</td>
                            <td>
                                <a href="seatEdit?auditoriumId=${a.auditoriumId}">
                                    <button class="btn btn-update">Update</button>
                                </a>
                                <a href="seatAdd?auditoriumId=${a.auditoriumId}">
                                    <button class="btn btn-add">Add</button>
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

            <!-- Phân trang -->
            <div class="pagination">
                <button class="page-btn">&larr; Previous</button>
                <button class="page-btn active">1</button>
                <button class="page-btn">Next &rarr;</button>
            </div>
        </div>

        <script>
            // Tìm kiếm nhanh theo Auditorium ID
            const searchInput = document.getElementById("searchInput");
            const table = document.getElementById("auditoriumTable").getElementsByTagName("tbody")[0];

            searchInput.addEventListener("keyup", function () {
                const filter = this.value.toUpperCase();
                const rows = table.getElementsByTagName("tr");
                for (let i = 0; i < rows.length; i++) {
                    const td = rows[i].getElementsByTagName("td")[0];
                    if (td) {
                        const txtValue = td.textContent || td.innerText;
                        rows[i].style.display = txtValue.toUpperCase().indexOf(filter) > -1 ? "" : "none";
                    }
                }
            });
        </script>

    </body>
</html>
