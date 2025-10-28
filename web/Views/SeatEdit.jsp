<%@ page import="java.util.*, Models.Seat" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cập nhật ghế phòng ${auditoriumId}</title>
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

        .seat-layout {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 50px;
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

        .form-container {
            width: 260px;
            background: #f8f9fa;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            position: sticky;
            top: 80px;
            height: fit-content;
        }

        .form-container h3 {
            text-align: center;
            color: #007bff;
            margin-bottom: 15px;
        }

        .form-container label {
            display: block;
            margin-top: 10px;
            font-weight: bold;
        }

        .form-container input, select {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .form-container button {
            width: 100%;
            margin-top: 15px;
            padding: 10px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            transition: 0.2s;
        }

        .form-container button {
            background: #007bff;
            color: white;
        }

        .form-container button:hover {
            background: #0056b3;
        }

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
            color: green;
            font-weight: bold;
            margin: 10px 0;
        }
    </style>
</head>
<body>
<div class="container">
    <a href="seatDetail?auditoriumId=${auditoriumId}" class="btn-back">⬅ Quay lại sơ đồ ghế</a>
    <h2>🛠 Cập nhật ghế phòng ${auditoriumId}</h2>

    <c:if test="${not empty sessionScope.message}">
        <p class="message">${sessionScope.message}</p>
        <c:remove var="message" scope="session"/>
    </c:if>

    <div class="seat-layout">
        <!-- Sơ đồ ghế -->
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

        <!-- Form cập nhật ghế -->
        <div class="form-container">
            <h3>⚙️ Cập nhật ghế</h3>
            <form method="post" action="seatEdit">
                <input type="hidden" name="auditoriumId" value="${auditoriumId}">

                <label>Hàng (A–Z):</label>
                <input type="text" name="row" maxlength="1" required>

                <label>Số ghế:</label>
                <input type="number" name="number" min="1" max="50" required>

                <label>Đổi loại ghế (tùy chọn):</label>
                <select name="seatType">
                    <option value="">-- Giữ nguyên --</option>
                    <option value="Regular">Regular</option>
                    <option value="VIP">VIP</option>
                    <option value="SweetBox">SweetBox</option>
                </select>

                <button type="submit">Cập nhật</button>
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
