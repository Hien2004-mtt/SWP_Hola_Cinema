<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Arrays" %>
<%
    Integer bookingId = (Integer) session.getAttribute("bookingId");
    String[] seats = (String[]) session.getAttribute("bookedSeats");
    Object totalPriceObj = session.getAttribute("totalPrice");
    double totalPrice = 0.0;

    if (totalPriceObj != null) {
        try {
            totalPrice = Double.parseDouble(totalPriceObj.toString());
        } catch (Exception e) {
            totalPrice = 0.0;
        }
    }
%>
 

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Đặt vé thành công</title>
        <link rel="stylesheet" href="../css/Layout.css">
        <link rel="stylesheet" href="../css/confirm.css">
        <style>
            body {
                font-family: Arial, sans-serif;
                text-align: center;
                margin-top: 50px;
            }
            .ticket {
                background: #fff;
                border-radius: 12px;
                padding: 30px;
                width: 450px;
                margin: 0 auto;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            h1 {
                color: #2ecc71;
            }
            .details {
                margin-top: 20px;
                text-align: left;
                padding: 0 30px;
            }
        </style>
    </head>
    <body>
        <div class="ticket">
            <h1>🎟️ Đặt vé thành công!</h1>
            <div class="details">
                <p><strong>Mã đơn:</strong> <%= bookingId %></p>
                <p><strong>Ghế:</strong> <%= String.join(", ", seats) %></p>
                <p><strong>Tổng tiền:</strong> <%= String.format("%,.0f", totalPrice) %> VND</p>
                <p>Cảm ơn bạn đã sử dụng dịch vụ của <b>HOLA CINEMA</b> 🎬</p>
            </div>
            <a href="home" style="display:inline-block; margin-top:20px; text-decoration:none; color:white; background:#27ae60; padding:10px 20px; border-radius:5px;">Về trang chủ</a>
        </div>
    </body>
</html>
