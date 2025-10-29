<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <title>Thêm hàng ghế mới</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/AddSeatRow.css">

    </head>
    <body>
        <div class="container">
            <h2> Thêm hàng ghế</h2>
            <a href="seatList" class="btn-back">⬅ Quay lại danh sách phòng</a>


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
