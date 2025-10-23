<%@ page import="java.util.*, Models.Seat" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Quản lý ghế</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 40px;
                background-color: #f8f9fa;
            }

            h2 {
                text-align: center;
                color: #333;
            }

            .seat-grid {
                display: grid;
                grid-template-columns: repeat(12, 50px);
                gap: 6px;
                margin-top: 20px;
                justify-content: center;
            }

            .seat {
                width: 50px;
                height: 50px;
                text-align: center;
                line-height: 50px;
                border-radius: 6px;
                font-weight: bold;
                color: white;
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

            .form-container {
                margin-top: 30px;
                text-align: center;
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
                width: fit-content;
                margin-left: auto;
                margin-right: auto;
            }

            .form-container select, .form-container input, button {
                margin: 5px;
                padding: 8px;
            }

            .row-label {
                grid-column: 1 / span 12;
                text-align: left;
                font-weight: bold;
                margin-top: 15px;
            }

            .legend {
                margin-top: 20px;
                text-align: center;
            }

            .legend span {
                display: inline-block;
                width: 20px;
                height: 20px;
                border-radius: 4px;
                margin-right: 6px;
            }
        </style>
    </head>
    <body>
        <h2>➕ Thêm Ghế Mới cho Phòng ${auditoriumId}</h2>

        <!-- 🪑 Sơ đồ ghế -->
        <div class="seat-grid">
            <%
                List<Seat> seats = (List<Seat>) request.getAttribute("seats");
                String[] rows = {"A","B","C","D","E","F","G","H","I"};

                for (String r : rows) {
                    out.println("<div class='row-label'>Hàng " + r + ":</div>");
                    for (int n = 1; n <= 12; n++) {
                        Seat found = null;
                        if (seats != null) {
                            for (Seat s : seats) {
                                if ( s.getRow() != null && s.getRow().equalsIgnoreCase(    r) && s.getNumber() == n) {
                                    found = s;
                                    break;
                                }
                            }
                        }
                        if (found != null) {
                            String cssClass = found.getSeatType().equalsIgnoreCase("VIP") ? "vip" :
                                              found.getSeatType().equalsIgnoreCase("SweetBox") ? "sweetbox" : "regular";
                            if (!found.isIsActivate()) cssClass = "inactive";
                            out.println("<div class='seat " + cssClass + "'>" + r + n + "</div>");
                        } else {
                            out.println("<div class='seat' style='background:#ccc; color:#333;'>" + r + n + "</div>");
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
                <select name="row">
                    <option value="A">A</option>
                    <option value="B">B</option>
                    <option value="C">C</option>
                    <option value="D">D</option>
                    <option value="E">E</option>
                    <option value="F">F</option>
                    <option value="G">G</option>
                    <option value="H">H</option>
                    <option value="I">I</option>
                </select>

                <label>Số ghế:</label>
                <input type="number" name="number" min="1" max="20" required>

                <label>Loại ghế:</label>
                <select name="seatType">
                    <option value="Regular">Regular</option>
                    <option value="VIP">VIP</option>
                    <option value="SweetBox">SweetBox</option>
                </select>

                <button type="submit">Thêm Ghế</button>
            </form>
        </div>

        <div class="legend">
            <h4>🗝 Chú thích:</h4>
            <p>
                <span class="regular"></span> Regular &nbsp;&nbsp;
                <span class="vip"></span> VIP &nbsp;&nbsp;
                <span class="sweetbox"></span> SweetBox &nbsp;&nbsp;
                <span class="inactive"></span> Đã bị khóa
            </p>
        </div>
    </body>
</html>
