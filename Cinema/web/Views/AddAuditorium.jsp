<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<html>
    <head>
        <meta charset="UTF-8">
        <title>Thêm phòng chiếu</title>
        <link rel="stylesheet" href="css/Auditorium.css" />
    </head>
    <body>
        <h2>Thêm phòng chiếu mới</h2>
        <form method="post" action="auditorium">
            <label>Tên phòng</label><br>
            <input type="text" name="name" placeholder="Tên phòng" required /><br><br>

            <label>Sơ đồ ghế</label><br>
            <input type="text" name="layout" placeholder="Sơ đồ ghế" /><br><br>

            <button type="submit" name="action" value="add">Thêm</button>
            <a href="/auditorium">Hủy</a>
        </form>
    </body>
</html>