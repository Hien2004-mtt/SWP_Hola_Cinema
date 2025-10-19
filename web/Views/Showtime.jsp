<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Models.Showtime" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    List<Showtime> showtimes = (List<Showtime>) request.getAttribute("showtimes");
    Integer movieId = (Integer) request.getAttribute("movieId");
    String movieTitle = (String) request.getAttribute("movieTitle");
    SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chọn suất chiếu</title>
        <link rel="stylesheet" href="../css/Showtime.css">
        <link rel="stylesheet" href="../css/Layout.css">
    </head>
    <body>
        <div class="page-container">
            <jsp:include page="/Inculude/Header.jsp" />

            <div class="main-content">
                <h2 style="text-align:center;">Chọn suất chiếu cho phim: <%= movieTitle %></h2>

                <% String error = (String) request.getAttribute("error"); %>
                <% if (error != null) { %>
                <p style="color:red; text-align:center;"><%= error %></p>
                <% } %>

                <% if (showtimes != null && !showtimes.isEmpty()) { %>

                <!-- Form chọn suất chiếu -->
                <form action="confirmShowtime" method="post" style="text-align:center;">
                    <div class="showtime-container">
                        <% for (Showtime s : showtimes) {
                            String timeStr = timeFormat.format(s.getStartTime());
                            String dateStr = dateFormat.format(s.getStartTime());
                        %>
                        <input type="radio" name="showtimeId" value="<%= s.getShowtimeId() %>" 
                               id="show_<%= s.getShowtimeId() %>" class="showtime-radio" />
                        <label for="show_<%= s.getShowtimeId() %>" class="showtime-box showtime-label">
                            <strong><%= timeStr %></strong><br>
                            Ngày: <%= dateStr %><br>
                            Phòng: <%= s.getAuditoriumId() %><br>
                            Giá: <%= String.format("%,.0f", s.getBasePrice()) %> VND
                        </label>
                        <% } %>
                    </div>

                    <div class="button-group">
                        <button type="submit" class="continue-button">Tiếp tục chọn ghế</button>
                    </div>
                </form>

                <!-- Form riêng cho nút Hủy -->
                <div class="button-group">
                    <form action="home" method="get">
                        <button type="submit" class="cancel-button">Hủy chọn suất chiếu</button>
                    </form>
                </div>

                <% } else { %>
                <p style="text-align:center; color:red;">Không có suất chiếu nào cho phim này.</p>
                <% } %>
            </div>

            <jsp:include page="/Inculude/Footer.jsp" />
        </div>
    </body>
</html>
