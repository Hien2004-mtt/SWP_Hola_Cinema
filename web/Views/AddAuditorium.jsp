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

        <label for="layout">Mô tả phòng chiếu:</label><br>
        <input type="text" id="layout" name="layout" placeholder="Mô tả sơ đồ ghế (VD: 10x12)" required><br><br>

        <button type="submit">Thêm</button>
        <a href="${pageContext.request.contextPath}/listAuditorium">Hủy</a>
    </form>
</body>
</html>
