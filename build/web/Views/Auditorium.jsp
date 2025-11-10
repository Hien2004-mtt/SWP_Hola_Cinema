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

    </head>
    <body>
        <%@include file="../manager/sidebar.jsp" %>
        <div class ="main-content"> 
        <h2>Danh sách phòng chiếu</h2>

        <!-- Thông báo sau thao tác thêm/sửa/xóa -->
        <c:if test="${not empty sessionScope.messageAuditorium}">
            <div style="background:#e6ffed; color:#0a602a; border:1px solid #37b34a;
                 padding:10px; border-radius:6px; text-align:center; margin-bottom:15px;">
                ${sessionScope.messageAuditorium}
            </div>
            <c:remove var="messageAuditorium" scope="session"/>
        </c:if>

        <div class="search-bar">
            <form method="get" action="listAuditorium">
                <input type="text" name="q" id="auditoriumSearch"
                       placeholder="Tìm kiếm theo ID hoặc Tên phòng..."
                       value="<%= request.getAttribute("q") == null ? "" : request.getAttribute("q") %>" />
                <button type="submit">Tìm</button>
            </form>

           
                <a href="Views/AddAuditorium.jsp"><button type="button" class="btn-add">Thêm</button></a>
            
        </div>



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
                <th>
                    <a href="listAuditorium?sort=description&dir=<%= ("description".equals(request.getAttribute("sort")) && "asc".equals(request.getAttribute("dir"))) ? "desc" : "asc" %><%= (request.getAttribute("q") != null && !"".equals(request.getAttribute("q"))) ? "&q=" + request.getAttribute("q") : "" %>">
                        Mô tả
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
                <td><%= a.getDescription() %></td>
                <!-- Hiển thị trạng thái -->
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
                        <button type="submit" class="btn-recove" onclick="return confirm('Khôi phục phòng chiếu #<%= a.getAuditoriumId() %>?')">
                            Khôi phục
                        </button>
                    </form>
                    <% } else { %>
                    <!-- Bình thường: có Sửa & Xóa -->
                    <form method="get" action="updateAuditorium" style="display:inline;">
                        <input type="hidden" name="id" value="<%= a.getAuditoriumId() %>">
                        <button type="submit" class="btn-update">Sửa</button>
                    </form>

                    <form method="post" action="deleteAuditorium" style="display:inline;">
                        <input type="hidden" name="id" value="<%= a.getAuditoriumId() %>">
                        <button type="submit " class="btn-delete" onclick="return confirm('Xác nhận xóa phòng chiếu #<%= a.getAuditoriumId() %>?')">
                            Xóa
                        </button>
                    </form>
                    <form method="get" action="seatDetail" style="display: inline;"> 
                        <input type="hidden" name="auditoriumId" value="<%= a.getAuditoriumId() %>">
                        <button type="submit" class="btn-detail">Sơ đồ ghế</button>
                    </form>
                    <% } %>
                </td>

            </tr>
            <% } } else { %>
            <tr><td colspan="5">Chưa có phòng chiếu nào.</td></tr>
            <% } %>
        </table>
        <div style="text-align:center; margin-top:20px;">
            <c:if test="${totalPages > 1}">
                <c:if test="${currentPage > 1}">
                    <a href="listAuditorium?page=${currentPage - 1}&q=${q}&sort=${sort}&dir=${dir}" 
                       style="margin-right:10px;"> Trước</a>
                </c:if>

                <c:forEach var="i" begin="1" end="${totalPages}">
                    <c:choose>
                        <c:when test="${i == currentPage}">
                            <span style="padding:8px 12px; background:#007bff; color:white; border-radius:4px; margin:3px;">
                                ${i}
                            </span>
                        </c:when>
                        <c:otherwise>
                            <a href="listAuditorium?page=${i}&q=${q}&sort=${sort}&dir=${dir}"
                               style="padding:8px 12px; background:#f0f0f0; border-radius:4px; margin:3px; text-decoration:none; color:#333;">
                                ${i}
                            </a>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>

                <c:if test="${currentPage < totalPages}">
                    <a href="listAuditorium?page=${currentPage + 1}&q=${q}&sort=${sort}&dir=${dir}" 
                       style="margin-left:10px;">Sau </a>
                </c:if>
            </c:if>
        </div>
        </div>
    </body>
</html>
