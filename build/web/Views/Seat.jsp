<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Models.Seat" %>

<%
    List<Seat> seats = (List<Seat>) request.getAttribute("seats");
    String movieTitle = (String) request.getAttribute("movieTitle");
    String startTime = String.valueOf(request.getAttribute("startTime"));
    Double basePrice = (Double) request.getAttribute("basePrice");
    int showtimeId = (Integer) request.getAttribute("showtimeId");
    int movieId = (Integer) request.getAttribute("movieId");
    String auditoriumName = (String) request.getAttribute("auditoriumName");
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chọn ghế - <%= movieTitle %></title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Seat.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Layout.css">

    </head>

    <body>
        <jsp:include page="/Inculude/Header.jsp" />
        
    <c:if test="${not empty message}">
        <div class="alert alert-danger">${message}</div>
    </c:if>

    <div class="container">
        <h2 style="text-align:center;">🎬 Chọn ghế cho phim: "<%= movieTitle %>"</h2>
        <p style="text-align:center;">⏰ Suất chiếu: <%= startTime %></p>

        <form action="booking" method="post" onsubmit="return validateSelection();">
            <input type="hidden" id="basePriceJS" value="<%= basePrice %>">
            <input type="hidden" name="showtimeId" value="<%= showtimeId %>">
            <input type="hidden" name="basePrice" value="<%= basePrice %>">
            <input type="hidden" id="totalPriceInput" name="totalPrice" value="0">
            <input type="hidden" name="movieId" value="<%= movieId %>">
            <div class="layout">
                <!-- Sơ đồ ghế -->
                <div class="seat-layout">
                    <div class="screen-label">
                        <div class="screen">MÀN HÌNH</div>
                    </div>

                    <div class="seat-map">
                        <%
                            if (seats != null) {
                                for (Seat s : seats) {
                                    String code = s.getRow() + s.getNumber();
                                    String cssClass = "";

                                    if (!s.isIsActivate()) {
                                        cssClass = "inactive";
                                    } else if ("VIP".equalsIgnoreCase(s.getSeatType())) {
                                        cssClass = "vip";
                                    } else if ("Sweetbox".equalsIgnoreCase(s.getSeatType())) {
                                        cssClass = "sweetbox";
                                    } else {
                                        cssClass = "regular";
                                    }
                        %>
                        <div id="seat_<%= code %>" 
                             class="seat <%= cssClass %>"
                             onclick="toggleSeat('<%= code %>', 'cb_<%= code %>', 'seat_<%= code %>', '<%= s.getSeatType() %>')">
                            <%= code %>
                            <input type="checkbox"
                                   name="selectedSeats"
                                   value="<%= code %>"
                                   id="cb_<%= code %>"
                                   style="display:none;"
                                   <%= !s.isIsActivate() ? "disabled" : "" %> />
                        </div>
                        <%
                                } // end for
                            } // end if
                        %>
                    </div>

                    <!-- Chú thích -->
                    <div class="legend" style="margin-top:30px;">
                        <h3>🎟️ Chú thích ghế</h3>
                        <div style="display:flex; gap:20px; flex-wrap:wrap; font-size:14px;">
                            <div style="display:flex; align-items:center; gap:8px;">
                                <div style="width:20px; height:20px; background-color:green; border-radius:4px;"></div>
                                <span>Thường</span>
                            </div>
                            <div style="display:flex; align-items:center; gap:8px;">
                                <div style="width:20px; height:20px; background-color:hotpink; border-radius:4px;"></div>
                                <span>VIP</span>
                            </div>
                            <div style="display:flex; align-items:center; gap:8px;">
                                <div style="width:20px; height:20px; background-color:purple; border-radius:4px;"></div>
                                <span>Sweetbox</span>
                            </div>
                            <div style="display:flex; align-items:center; gap:8px;">
                                <div style="width:20px; height:20px; background-color:gray; border-radius:4px;"></div>
                                <span>Không thể chọn</span>
                            </div>
                            <div style="display:flex; align-items:center; gap:8px;">
                                <div style="width:20px; height:20px; background-color:green; border:3px solid yellow; border-radius:4px;"></div>
                                <span>Đã chọn</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Bảng thông tin vé -->
                <div class="ticket-info">
                    <h3>Thông tin vé</h3>
                    <p><strong>Phim:</strong> <%= movieTitle %></p>
                    <p><strong>Phòng chiếu:</strong> <%= auditoriumName %></p>
                    <p><strong>Suất chiếu:</strong> <%= startTime %></p>
                    <p><strong>Loại ghế:</strong> <span id="selectedSeatType">Chưa chọn</span></p>
                    <p><strong>Ghế đã chọn:</strong> <span id="selectedSeatsText">Chưa chọn</span></p>
                    <p><strong>Tổng tiền:</strong> <span id="totalPrice">0 VND</span></p>

                    <div style="text-align:center; margin-top:30px;">
                        <button type="submit" class="btn btn-success">Đặt ghế</button>
                    </div>
                </div>
            </div>
        </form>
    </div>

    <script src="${pageContext.request.contextPath}/js/Seat.js"></script>
    <jsp:include page="/Inculude/Footer.jsp" />

</body>
</html>
