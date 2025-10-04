<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Xác nhận đặt ghế</title>
    <link rel="stylesheet" href="css/Confirm.css">
<body>
    <div class="container">
        <h2>Xác nhận đặt ghế</h2>
        <div class="message">
            <%= message != null ? message : "Không có thông tin đặt ghế." %>
        </div>
        <a href="Seat" class="back-button">Quay lại chọn ghế</a>
    </div>
</body>
</html>
