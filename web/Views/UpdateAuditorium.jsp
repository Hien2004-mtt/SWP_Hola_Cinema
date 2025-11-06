<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="Models.Auditorium" %>
<%
    Auditorium a = (Auditorium) request.getAttribute("auditorium");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Sửa thông tin phòng chiếu</title>
        <link rel="stylesheet" href="css/Auditorium.css">
    </head>
    <body>
        <h2>Sửa thông tin phòng chiếu</h2>

        <!-- Form gửi đến UpdateAuditoriumServlet -->
        <form method="post" action="updateAuditorium">
            <input type="hidden" name="id" value="<%= a.getAuditoriumId() %>">

            <label for="name">Tên phòng:</label><br>
            <input type="text" id="name" name="name" value="<%= a.getName() %>" required><br><br>

            <label for="totalSeat">Tổng số ghế:</label><br>
            <input type="number" id="totalSeat" name="totalSeat" 
                   value="<%= a.getTotalSeat() %>" min="10" max="80" required><br><br>
            <label for="description">Mô tả:</label><br>
            <input type="text" id="description" name="description" value="<%= a.getDescription() %>"
                   maxlength="250" required> <br><br>
            <button type="submit">Lưu thay đổi</button>
            <a href="listAuditorium">Hủy</a>
        </form>
    </body>
</html>
