<%@ page import="java.util.*, Models.Seat" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết ghế phòng ${auditoriumId}</title>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #f8f9fb;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 95%;
            margin: 40px auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }
        .btn-back {
            display: inline-block;
            padding: 10px 16px;
            background: #6c757d;
            color: #fff;
            text-decoration: none;
            border-radius: 6px;
            margin-bottom: 20px;
        }
        .btn-back:hover {
            background: #5a6268;
        }
        .screen {
            text-align: center;
            background: #ddd;
            padding: 10px;
            font-weight: bold;
            margin-bottom: 30px;
            border-radius: 6px;
        }
        .seat-area {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .row-block {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 25px;
        }
        .row-label {
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
        }
        .row-seats {
            display: grid;
            grid-template-columns: repeat(12, 60px);
            gap: 10px;
            justify-content: center;
        }
        .seat {
            width: 55px;
            height: 55px;
            line-height: 55px;
            text-align: center;
            border-radius: 6px;
            color: #fff;
            font-weight: bold;
            font-size: 14px;
            transition: all 0.2s ease;
        }
        .regular { background-color: #28a745; }
        .vip { background-color: gold; color: black; }
        .sweetbox { background-color: hotpink; }
        .hidden-seat { background-color: #7a7a7a; text-decoration: line-through; opacity: 0.7; }

        .legend {
            text-align: center;
            margin-top: 40px;
        }
        .legend span {
            display: inline-block;
            width: 20px;
            height: 20px;
            margin-right: 8px;
            border-radius: 4px;
        }

        .message {
            text-align: center;
            color: #0a602a;
            font-weight: bold;
            background: #e6ffed;
            border: 1px solid #37b34a;
            border-radius: 6px;
            padding: 10px;
            margin-bottom: 15px;
        }

        .btn-manage {
            display: inline-block;
            padding: 10px 16px;
            background: #007bff;
            color: #fff;
            text-decoration: none;
            border-radius: 6px;
            margin-top: 15px;
        }
        .btn-manage:hover {
            background: #0056b3;
        }
    </style>
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
