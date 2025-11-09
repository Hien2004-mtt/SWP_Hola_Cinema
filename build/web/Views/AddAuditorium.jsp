<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm phòng chiếu</title>
    <link rel="stylesheet" href="../css/Auditorium.css">
</head>
<body>
    <h2>Thêm phòng chiếu mới</h2>

    <!-- Form gửi đến AddAuditoriumServlet -->
    <form method="post" action="${pageContext.request.contextPath}/addAuditorium">
        <label for="name">Tên phòng:</label><br>
        <input type="text" id="name" name="name" placeholder="Nhập tên phòng chiếu" required><br><br>

        <label for="totalSeat">Tổng số ghế:</label><br>
        <input type="number" id="totalSeat" name="totalSeat" min="10" max="80" placeholder="10-80" required><br><br>
        <label for="description"> Mô tả</label><br>
        <input type="text" id="description" name="description" maxlength="250" placeholder="Nhập mô tả ghế" required><br><br>
        <button type="submit">Thêm</button>
        <a href="${pageContext.request.contextPath}/listAuditorium">Hủy</a>
    </form>
</body>
</html>
