<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Models.Auditorium" %>
<%
    List<Auditorium> list = (List<Auditorium>) request.getAttribute("list");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý phòng chiếu</title>
    <link rel="stylesheet" href="css/Auditorium.css" />
</head>
<body>
    <h2>Danh sách phòng chiếu</h2>
    <table>
        <tr>
            <th>ID</th>
            <th>Tên phòng</th>
            <th>Sơ đồ ghế</th>
            <th>Hành động</th>
        </tr>
        <% if (list != null && !list.isEmpty()) {
               for (Auditorium a : list) { %>
            <tr>
                <td><%= a.getAuditoriumId() %></td>
                <td><%= a.getName() %></td>
                <td><%= a.getSeatLayoutMeta() %></td>
                <td>
                    <!-- form sửa -->
                    <form method="get" action="auditorium">
                        <input type="hidden" name="action" value="editForm">
                        <input type="hidden" name="id" value="<%= a.getAuditoriumId() %>">
                        <button type="submit">Sửa</button>
                    </form>

                    <!-- form xoá -->
                    <form method="post" action="auditorium" style="display:inline;">
                        <input type="hidden" name="id" value="<%= a.getAuditoriumId() %>">
                        <input type="hidden" name="action" value="delete">
                        <button type="submit" onclick="return confirm('Xác nhận xoá phòng chiếu?')">Xoá</button>
                    </form>
                </td>
            </tr>
        <%   }
           } else { %>
           <tr><td colspan="4">Chưa có phòng chiếu nào.</td></tr>
        <% } %>
    </table>

    <h3>Thêm phòng chiếu mới</h3>
    <form method="post" action="auditorium">
        <input type="text" name="name" placeholder="Tên phòng" required />
        <input type="text" name="layout" placeholder="Sơ đồ ghế" />
        <button type="submit" name="action" value="add">Thêm</button>
    </form>
</body>
</html>
