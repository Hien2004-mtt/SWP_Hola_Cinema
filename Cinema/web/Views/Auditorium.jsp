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
    <script src="js/Auditorium.js"></script>
</head>
<body>
    <h2>Danh sách phòng chiếu</h2>
    <div>
        <input type="text" id="auditoriumSearch" placeholder="Tìm kiếm theo ID hoặc Tên phòng..." onkeyup="filterAuditoriums()" />
    </div>
    <p>
        <a href="Views/AddAuditorium.jsp"><button type="button">Thêm</button></a>
    </p>
    <table>
        <tr>
            <th>
                <a href="auditorium?sort=id&dir=<%= ("id".equals(request.getAttribute("sort")) && "asc".equals(request.getAttribute("dir"))) ? "desc" : "asc" %>">
                    ID
                </a>
            </th>
            <th>
                <a href="auditorium?sort=name&dir=<%= ("name".equals(request.getAttribute("sort")) && "asc".equals(request.getAttribute("dir"))) ? "desc" : "asc" %>">
                    Tên phòng
                </a>
            </th>
            <th>
                <a href="auditorium?sort=layout&dir=<%= ("layout".equals(request.getAttribute("sort")) && "asc".equals(request.getAttribute("dir"))) ? "desc" : "asc" %>">
                    Sơ đồ ghế
                </a>
            </th>
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

    
    
</body>
</html>
