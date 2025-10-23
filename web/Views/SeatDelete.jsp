<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="Models.Seat" %>
<%
    Seat seat = (Seat) request.getAttribute("seat");
    int auditoriumId = (int) request.getAttribute("auditoriumId");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Xóa Ghế</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f8f9fa;
                text-align: center;
                margin-top: 50px;
            }

            .container {
                background: white;
                display: inline-block;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.2);
                text-align: left;
            }

            h2 {
                color: #dc3545;
                text-align: center;
            }

            .info {
                margin: 15px 0;
            }

            button {
                padding: 10px 20px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                margin: 10px;
            }

            .btn-cancel {
                background-color: #6c757d;
                color: white;
            }

            .btn-delete {
                background-color: #dc3545;
                color: white;
            }

            a {
                text-decoration: none;
            }
        </style>
    </head>
    <body>

        <div class="container">
            <h2>️ Xác nhận xóa ghế</h2>
            <div class="info">
                <p><strong>Phòng chiếu:</strong> <%= auditoriumId %></p>
                <p><strong>Hàng:</strong> <%= seat.getRow() %></p>
                <p><strong>Số ghế:</strong> <%= seat.getNumber() %></p>
                <p><strong>Loại ghế:</strong> <%= seat.getSeatType() %></p>
            </div>

            <form method="post" action="seatDelete">
                <input type="hidden" name="seatId" value="<%= seat.getSeatId() %>">
                <input type="hidden" name="auditoriumId" value="<%= auditoriumId %>">
                <p>Bạn có chắc chắn muốn <b>xóa</b> ghế này không?</p>
                <button type="submit" class="btn-delete">Xóa ghế</button>
                <a href="seatList?auditoriumId=<%= auditoriumId %>">
                    <button type="button" class="btn-cancel">Hủy</button>
                </a>
            </form>
        </div>

    </body>
</html>
