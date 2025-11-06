<%@ page import="java.util.*, Models.Seat" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết ghế phòng ${auditoriumId}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SeatDetail.css">
</head>
<body>
    <div class="container">
        <a href="seatList" class="btn-back">⬅ Quay lại danh sách phòng</a>
        <h2> Sơ đồ ghế của phòng ${auditoriumId}</h2>

        <c:if test="${not empty sessionScope.messageSeat}">
            <div class="message">${sessionScope.messageSeat}</div>
            <c:remove var="messageSeat" scope="session"/>
        </c:if>

        <div class="screen">MÀN HÌNH</div>

        <div class="seat-area">
            <%
                List<Seat> seats = (List<Seat>) request.getAttribute("seats");
                if (seats != null && !seats.isEmpty()) {
                    Set<String> rowSet = new LinkedHashSet<>();
                    for (Seat s : seats) {
                        if (s.getRow() != null) rowSet.add(s.getRow().toUpperCase());
                    }

                    List<String> rows = new ArrayList<>(rowSet);
                    Collections.sort(rows);

                    for (String r : rows) {
                        out.println("<div class='row-block'>");
                        out.println("<div class='row-label'>Hàng " + r + "</div>");
                        out.println("<div class='row-seats'>");

                        List<Seat> rowSeats = new ArrayList<>();
                        for (Seat s : seats) {
                            if (s.getRow().equalsIgnoreCase(r)) rowSeats.add(s);
                        }

                        rowSeats.sort(Comparator.comparingInt(Seat::getNumber));

                        for (Seat s : rowSeats) {
                            String cssClass = s.getSeatType().equalsIgnoreCase("VIP") ? "vip"
                                    : s.getSeatType().equalsIgnoreCase("SweetBox") ? "sweetbox" : "regular";

                            if (!s.isIsShowing()) cssClass = "hidden-seat";

                            out.println("<div class='seat " + cssClass + "'>" + s.getRow() + s.getNumber() + "</div>");
                        }

                        out.println("</div></div>");
                    }
                } else {
                    out.println("<p class='message'> Phòng này hiện chưa có ghế nào.</p>");
                }
            %>
        </div>

       

        <div class="legend">
            <p><b>Chú thích:</b></p>
            <p>
                <span style="background:#28a745;"></span> Regular &nbsp;&nbsp;
                <span style="background:gold;"></span> VIP &nbsp;&nbsp;
                <span style="background:hotpink;"></span> SweetBox &nbsp;&nbsp;
                <span style="background:gray;"></span> Bị ẩn (is_showing = 0)
            </p>
        </div>
    </div>
</body>
</html>
