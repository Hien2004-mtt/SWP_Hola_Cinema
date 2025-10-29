<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Models.Auditorium" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    List<Auditorium> list = (List<Auditorium>) request.getAttribute("list");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý phòng chiếu</title>
        <link rel="stylesheet" href="css/Auditorium.css" />
        <style>
            .status-active {
                color: green;
                font-weight: bold;
                background: #e6ffee;
                padding: 4px 10px;
                border-radius: 6px;
            }
            .status-deleted {
                color: red;
                font-weight: bold;
                background: #ffe6e6;
                padding: 4px 10px;
                border-radius: 6px;
            }
        </style>
    </head>
    <body>
        <h2>Danh sách phòng chiếu</h2>

        <!-- ✅ Thông báo sau thao tác thêm/sửa/xóa -->
        <c:if test="${not empty sessionScope.messageAuditorium}">
            <div style="background:#e6ffed; color:#0a602a; border:1px solid #37b34a;
                 padding:10px; border-radius:6px; text-align:center; margin-bottom:15px;">
                ${sessionScope.messageAuditorium}
            </div>
            <c:remove var="messageAuditorium" scope="session"/>
        </c:if>

        <div>
            <form method="get" action="listAuditorium">
                <input type="text" name="q" id="auditoriumSearch"
                       placeholder="Tìm kiếm theo ID hoặc Tên phòng..."
                       value="<%= request.getAttribute("q") == null ? "" : request.getAttribute("q") %>" />
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
                    <a href="listAuditorium?sort=total&dir=<%= ("total".equals(request.getAttribute("sort")) && "asc".equals(request.getAttribute("dir"))) ? "desc" : "asc" %><%= (request.getAttribute("q") != null && !"".equals(request.getAttribute("q"))) ? "&q=" + request.getAttribute("q") : "" %>">
                        Tổng số ghế
                    </a>
                </th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>

            <% if (list != null && !list.isEmpty()) {
                   for (Auditorium a : list) { %>
            <tr>
                <td><%= a.getAuditoriumId() %></td>
                <td><%= a.getName() %></td>
                <td><%= a.getTotalSeat() %></td>

                <!-- ✅ Hiển thị trạng thái -->
                <td>
                    <% if (a.isIsDeleted()) { %>
                        <span class="status-deleted">Đã xóa</span>
                    <% } else { %>
                        <span class="status-active">Hoạt động</span>
                    <% } %>
                </td>

                <!-- ✅ Nút hành động -->
                <td>
                    <% if (a.isIsDeleted()) { %>
                        <!-- Nếu đã xóa thì hiện nút khôi phục -->
                        <form method="post" action="restoreAuditorium" style="display:inline;">
                            <input type="hidden" name="id" value="<%= a.getAuditoriumId() %>">
                            <button type="submit" onclick="return confirm('Khôi phục phòng chiếu #<%= a.getAuditoriumId() %>?')">
                                 Khôi phục
                            </button>
                        </form>
                    <% } else { %>
                        <!-- Bình thường: có Sửa & Xóa -->
                        <form method="get" action="updateAuditorium" style="display:inline;">
                            <input type="hidden" name="id" value="<%= a.getAuditoriumId() %>">
                            <button type="submit">Sửa</button>
                        </form>

                        <form method="post" action="deleteAuditorium" style="display:inline;">
                            <input type="hidden" name="id" value="<%= a.getAuditoriumId() %>">
                            <button type="submit" onclick="return confirm('Xác nhận xóa phòng chiếu #<%= a.getAuditoriumId() %>?')">
                                 Xóa
                            </button>
                        </form>
                    <% } %>
                </td>
            </tr>
            <% } } else { %>
            <tr><td colspan="5">Chưa có phòng chiếu nào.</td></tr>
            <% } %>
        </table>
    </body>
</html>
