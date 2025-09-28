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
    <style>
        body {
            font-family: sans-serif;
            background-color: #fdf6e3;
            padding: 40px;
        }
        h2 {
            text-align: center;
            margin-bottom: 30px;
        }
        .showtime-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 20px;
        }
        .showtime-box {
            border: 1px solid #ccc;
            padding: 16px 24px;
            border-radius: 8px;
            background-color: white;
            cursor: pointer;
            transition: 0.2s;
            text-align: center;
        }
        .showtime-box:hover {
            background-color: #ffeaa7;
        }
        .showtime-radio {
            display: none;
        }
        .showtime-label {
            display: block;
        }
        .showtime-radio:checked + .showtime-label {
            border: 2px solid #f39c12;
            background-color: #fff8e1;
        }
        .submit-btn {
            margin-top: 40px;
            text-align: center;
        }
    </style>
</head>
<body>
    <h2>Chọn suất chiếu cho phim: <%= movieTitle %></h2>

    <% if (showtimes != null && !showtimes.isEmpty()) { %>
        <form action="Showtime" method="post">
            <div class="showtime-container">
                <% for (Showtime s : showtimes) { 
                    String timeStr = timeFormat.format(s.getStartTime());
                    String dateStr = dateFormat.format(s.getStartTime());
                %>
                    <input type="radio" name="showtimeId" value="<%= s.getShowtimeId() %>" id="show_<%= s.getShowtimeId() %>" class="showtime-radio" required />
                    <label for="show_<%= s.getShowtimeId() %>" class="showtime-box showtime-label">
                        <strong><%= timeStr %></strong><br>
                        Ngày: <%= dateStr %><br>
                        Phòng: <%= s.getAuditoriumId() %><br>
                        Giá: <%= String.format("%,.0f", s.getBasePrice()) %> VND
                    </label>
                <% } %>
            </div>
            <div class="submit-btn">
                <button type="submit">Tiếp tục chọn ghế</button>
            </div>
        </form>
    <% } else { %>
        <p style="text-align:center; color:red;">Không có suất chiếu nào cho phim này.</p>
    <% } %>
</body>
</html>
