<%@ page import="java.util.*, Models.Seat" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Ẩn ghế phòng ${auditoriumId}</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SeatDelete.css">
    </head>
    <body>
        <div class="container">
            <a href="seatList" class="btn-back"> Quay lại danh sách phòng</a>
            <h2> Ẩn ghế trong phòng ${auditoriumId}</h2>

            <c:if test="${not empty sessionScope.messageSeatDelete}">
                <p class="message">${sessionScope.messageSeatDelete}</p>
                <c:remove var="messageSeatDelete" scope="session"/>
            </c:if>

            <div class="seat-layout">
                <!-- ✅ Sơ đồ ghế -->
                <div class="seat-area">
                    <div class="screen">MÀN HÌNH</div>
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
                            out.println("<p style='text-align:center;color:gray;'>⚠️ Phòng này chưa có ghế nào.</p>");
                        }
                    %>
                </div>

                <!-- ✅ Form ẩn ghế -->
                <div class="form-container">
                    <h3> Ẩn ghế</h3>
                    <form method="post" action="seatDelete">
                        <input type="hidden" name="auditoriumId" value="${auditoriumId}">
                        <label>Hàng (A–Z):</label>
                        <input type="text" name="row" maxlength="1" required>

                        <label>Số ghế:</label>
                        <input type="number" name="number" min="1" max="50" required>

                        <button type="submit" name="action" value="hide">Ẩn ghế</button>
                    </form>
                </div>
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
