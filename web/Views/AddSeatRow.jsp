<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Thêm hàng ghế mới</title>
        <style>
            .error {
                background: #ffe6e6;
                color: #cc0000;
                padding: 10px;
                border-radius: 6px;
                margin-bottom: 10px;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>➕ Thêm hàng ghế</h2>

            <!-- Hiển thị lỗi -->
            <c:if test="${not empty error}">
                <div class="error">${error}</div>
            </c:if>

            <form action="seatAddRow" method="post">
                <input type="hidden" name="auditoriumId" value="${auditoriumId}">
                <label>Hàng (A–Z):</label>
                <input type="text" name="row" maxlength="1" required>

                <label>Số lượng ghế trong hàng:</label>
                <input type="number" name="seatCount" min="1" required>

                <label>Loại ghế:</label>
                <select name="seatType">
                    <option value="Regular">Regular</option>
                    <option value="VIP">VIP</option>
                    <option value="SweetBox">Sweet Box</option>
                </select>

                <button type="submit">Thêm hàng ghế</button>
            </form>
        </div>
    </body>
</html>
