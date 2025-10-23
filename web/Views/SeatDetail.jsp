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
            width: 85%;
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

        .seat-grid {
            display: grid;
            grid-template-columns: repeat(12, 60px);
            gap: 8px;
            justify-content: center;
            margin-bottom: 40px;
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
            cursor: pointer;
            transition: 0.2s;
        }

        .regular {
            background-color: #28a745;
        }

        .vip {
            background-color: gold;
            color: black;
        }

        .sweetbox {
            background-color: hotpink;
        }

        .inactive {
            background-color: gray;
            text-decoration: line-through;
        }

        .row-label {
            grid-column: 1 / span 12;
            font-weight: bold;
            margin-top: 20px;
            text-align: left;
            color: #555;
        }

        .form-container {
            text-align: center;
            background: #f9f9f9;
            border-radius: 8px;
            padding: 20px;
            width: fit-content;
            margin: 0 auto;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
        }

        select, input {
            padding: 8px;
            border-radius: 5px;
            border: 1px solid #ccc;
            margin: 0 5px;
        }

        button {
            padding: 8px 14px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            background: #007bff;
            color: white;
            transition: 0.2s;
        }

        button:hover {
            background: #0056b3;
        }

        .legend {
            text-align: center;
            margin-top: 30px;
        }

        .legend span {
            display: inline-block;
            width: 20px;
            height: 20px;
            margin-right: 8px;
            border-radius: 4px;
        }

        .action-btn {
            margin-top: 5px;
            display: inline-block;
            background: #dc3545;
            color: white;
            padding: 3px 6px;
            border-radius: 4px;
            font-size: 12px;
            text-decoration: none;
        }

        .action-btn:hover {
            background: #b02a37;
        }

    </style>
</head>
<body>
<div class="container">
    <a href="seatList" class="btn-back">⬅ Quay lại danh sách phòng</a>
    <h2>💺 Sơ đồ ghế của phòng ${auditoriumId}</h2>

    <!-- 🪑 Lưới ghế -->
    <div class="seat-grid">
        <%
            List<Seat> seats = (List<Seat>) request.getAttribute("seats");
            String[] rows = {"A","B","C","D","E","F","G","H","I"};
            for (String r : rows) {
                out.println("<div class='row-label'>Hàng " + r + "</div>");
                for (int n = 1; n <= 12; n++) {
                    Seat found = null;
                    if (seats != null) {
                        for (Seat s : seats) {
                            if (s.getRow() != null && s.getRow().equalsIgnoreCase(r) && s.getNumber() == n) {
                                found = s;
                                break;
                            }
                        }
                    }

                    if (found != null) {
                        String cssClass = found.getSeatType().equalsIgnoreCase("VIP") ? "vip"
                                : found.getSeatType().equalsIgnoreCase("SweetBox") ? "sweetbox" : "regular";
                        if (!found.isIsActivate()) cssClass = "inactive";

                        out.println("<div class='seat " + cssClass + "'>" +
                                r + n +
                                "<br><a class='action-btn' href='seatDelete?seatId=" + found.getSeatId() +
                                "&auditoriumId=" + found.getAuditoriumId() + "'>Xóa</a>" +
                                "</div>");
                    } else {
                        out.println("<div class='seat' style='background:#e0e0e0; color:#333;'>" + r + n + "</div>");
                    }
                }
            }
        %>
    </div>

    <!-- 🧾 Form thêm ghế -->
    <div class="form-container">
        <form method="post" action="seatAdd">
            <input type="hidden" name="auditoriumId" value="${auditoriumId}">
            <label>Hàng:</label>
            <select name="row" required>
                <option value="">-- Chọn --</option>
                <option>A</option><option>B</option><option>C</option>
                <option>D</option><option>E</option><option>F</option>
                <option>G</option><option>H</option><option>I</option>
            </select>

            <label>Số ghế:</label>
            <input type="number" name="number" min="1" max="20" required>

            <label>Loại ghế:</label>
            <select name="seatType">
                <option>Regular</option>
                <option>VIP</option>
                <option>SweetBox</option>
            </select>

            <button type="submit">➕ Thêm Ghế</button>
        </form>
    </div>

    <!-- 🗝 Chú thích -->
    <div class="legend">
        <p><b>Chú thích:</b></p>
        <p>
            <span style="background:#28a745;"></span> Regular &nbsp;&nbsp;
            <span style="background:gold;"></span> VIP &nbsp;&nbsp;
            <span style="background:hotpink;"></span> SweetBox &nbsp;&nbsp;
            <span style="background:gray;"></span> Đã khóa
        </p>
    </div>
</div>
</body>
</html>
