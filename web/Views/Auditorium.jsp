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
    <div>
        <form method="get" action="listAuditorium">
            <input type="text" name="q" id="auditoriumSearch" placeholder="Tìm kiếm theo ID hoặc Tên phòng..." value="<%= request.getAttribute("q") == null ? "" : request.getAttribute("q") %>" />
            <button type="submit">Tìm</button>
        </form>
    </div>
    <p>
        <a href="Views/AddAuditorium.jsp"><button type="button">Thêm</button></a>
    </p>
    <table>
        <tr>
            <th>
                <a href="listAuditorium?sort=id&dir=<%= ("id".equals(request.getAttribute("sort")) && "asc".equals(request.getAttribute("dir"))) ? "desc" : "asc" %><%= (request.getAttribute("q") != null && !"".equals(request.getAttribute("q"))) ? "&q=" + request.getAttribute("q") : "" %>">
                    ID
                </a>
            </th>
            <th>
                <a href="listAuditorium?sort=name&dir=<%= ("name".equals(request.getAttribute("sort")) && "asc".equals(request.getAttribute("dir"))) ? "desc" : "asc" %><%= (request.getAttribute("q") != null && !"".equals(request.getAttribute("q"))) ? "&q=" + request.getAttribute("q") : "" %>">
                    Tên phòng
                </a>
            </th>
            <th>
                <a href="listAuditorium?sort=layout&dir=<%= ("layout".equals(request.getAttribute("sort")) && "asc".equals(request.getAttribute("dir"))) ? "desc" : "asc" %><%= (request.getAttribute("q") != null && !"".equals(request.getAttribute("q"))) ? "&q=" + request.getAttribute("q") : "" %>">
                    Mô tả phòng chiếu
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
                    <form method="get" action="updateAuditorium">
                        <input type="hidden" name="action" value="editForm">
                        <input type="hidden" name="id" value="<%= a.getAuditoriumId() %>">
                        <button type="submit">Sửa</button>
                    </form>

                    <!-- form xoá -->
                    <form method="post" action="deleteAuditorium" style="display:inline;">
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
