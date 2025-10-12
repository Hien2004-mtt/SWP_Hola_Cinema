<%@ page import="Models.Auditorium" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Auditorium a = (Auditorium) request.getAttribute("auditorium");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Sửa phòng chiếu</title>
    </head>
    <body>
        <h2>Sửa thông tin phòng chiếu</h2>
        <form method="post" action="auditorium">
            <input type="hidden" name="id" value="<%= a.getAuditoriumId() %>">

            <label>Tên phòng:</label><br>
            <input type="text" name="name" value="<%= a.getName() %>" required><br><br>

            <label>Sơ đồ ghế:</label><br>
            <input type="text" name="layout" value="<%= a.getSeatLayoutMeta() %>"><br><br>

            <button type="submit" name="action" value="update">Lưu thay đổi</button>
            <a href="auditorium">Hủy</a>
        </form>
    </body>
</html>
