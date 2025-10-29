<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <title>Thêm hàng ghế mới</title>
        <style>
            body {
                font-family: 'Poppins', sans-serif;
                background-color: #f9fafc;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
            }

            .container {
                background: #fff;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
                width: 420px;
            }

            h2 {
                text-align: center;
                color: #333;
                margin-bottom: 20px;
            }

            label {
                display: block;
                margin-top: 12px;
                font-weight: 600;
                color: #444;
            }

            input, select, button {
                width: 100%;
                padding: 8px;
                margin-top: 6px;
                border-radius: 5px;
                border: 1px solid #ccc;
                font-size: 14px;
            }

            button {
                background-color: #007bff;
                color: #fff;
                font-weight: bold;
                margin-top: 15px;
                cursor: pointer;
                transition: 0.2s;
            }

            button:hover {
                background-color: #0056b3;
            }

            .message {
                padding: 10px;
                border-radius: 6px;
                margin-bottom: 15px;
                text-align: center;
                font-weight: bold;
                animation: fadeIn 0.3s ease;
            }

            .success {
                background: #e7f9ee;
                color: #0b6b2f;
                border: 1px solid #37b34a;
            }

            .error {
                background: #ffe6e6;
                color: #b50000;
                border: 1px solid #ff4d4d;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-5px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>➕ Thêm hàng ghế</h2>


            <!-- ✅ Hiển thị thông báo -->
            <c:if test="${not empty sessionScope.messageSeat}">
                <div style="background:#e6ffed; color:#0a602a; border:1px solid #37b34a;
                     padding:10px; border-radius:6px; text-align:center; margin-bottom:15px;">
                    ${sessionScope.messageSeat}
                </div>
                <c:remove var="messageSeat" scope="session"/>
            </c:if>

            <form action="seatAddRow" method="post">
                <input type="hidden" name="auditoriumId" value="${auditoriumId}">

                <label>Hàng (A–Z):</label>
                <input type="text" name="row" maxlength="1" pattern="[A-Za-z]" title="Chỉ nhập ký tự từ A–Z" required>

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

        <!-- Tự động ẩn thông báo sau 4 giây -->
        <script>
            setTimeout(() => {
                const alertBox = document.getElementById("alertBox");
                if (alertBox)
                    alertBox.style.display = "none";
            }, 4000);
        </script>
    </body>
</html>
