<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Models.Showtime" %>
<%
    List<Showtime> showtimes = (List<Showtime>) request.getAttribute("showtimes");
    Integer movieId = (Integer) request.getAttribute("movieId");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chọn suất chiếu</title>
</head>
<body>
    <h2 style="text-align:center;">Chọn suất chiếu cho phim:  <%= request.getAttribute("movieTitle") %></h2>

    <% if (showtimes != null && !showtimes.isEmpty()) { %>
        <form action="Showtime" method="post" style="text-align:center;">
            <select name="showtimeId" required>
                <% for (Showtime s : showtimes) { %>
                    <option value="<%= s.getShowtimeId() %>">
                        Giờ chiếu: <%= s.getStartTime() %> | Phòng: <%= s.getAuditoriumId() %> | Giá: <%= s.getBasePrice() %> VND
                    </option>
                <% } %>
            </select>
            <br><br>
            <button type="submit">Tiếp tục chọn ghế</button>
        </form>
    <% } else { %>
        <p style="text-align:center; color:red;">Không có suất chiếu nào cho phim này.</p>
    <% } %>
</body>
</html>
