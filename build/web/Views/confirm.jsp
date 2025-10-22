<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Arrays" %>
<%
    String movieTitle = (String) request.getAttribute("movieTitle");
    String startTime = (String) request.getAttribute("startTime");
    Double basePrice = (Double) request.getAttribute("basePrice");
    String[] selectedSeats = (String[]) request.getAttribute("selectedSeats");
    Double totalPrice = (Double) request.getAttribute("totalPrice");
    Integer showtimeId = (Integer) request.getAttribute("showtimeId");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Xác nhận đặt vé</title>
    <link rel="stylesheet" href="../css/Layout.css">
    <link rel="stylesheet" href="../css/confirm.css">
</head>
<body>

    <div class="confirm-box">
        <h2>Xác nhận đặt vé</h2>

        <div class="details">
            <p><strong>Phim:</strong> <%= movieTitle %></p>
            <p><strong>Suất chiếu:</strong> <%= startTime %></p>
            <p><strong>Ghế đã chọn:</strong> <%= String.join(", ", selectedSeats) %></p>
            <p><strong>Giá cơ bản:</strong> <%= String.format("%,.0f", basePrice) %> VND</p>
            <p><strong>Tổng tiền:</strong> <%= String.format("%,.0f", totalPrice) %> VND</p>
        </div>

        <!-- Gửi form sang BookingServlet -->
        <form action="booking" method="post">
            <input type="hidden" name="showtimeId" value="<%= showtimeId %>">
            <input type="hidden" name="basePrice" value="<%= basePrice %>">
            <input type="hidden" name="totalPrice" value="<%= totalPrice %>">
            <% for (String seat : selectedSeats) { %>
                <input type="hidden" name="selectedSeats" value="<%= seat %>">
            <% } %>

            <div class="buttons">
                <button type="submit">Đặt vé ngay</button>
            </div>
        </form>
    </div>

</body>
</html>
