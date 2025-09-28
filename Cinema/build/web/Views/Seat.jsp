<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="Models.Seat" %>
<%
    List<Seat> seats = (List<Seat>) request.getAttribute("seats");
    String movieTitle = (String) request.getAttribute("movieTitle");
    String startTime = String.valueOf(request.getAttribute("startTime"));
    Double basePrice = (Double) request.getAttribute("basePrice");
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chọn ghế</title>
        <style>
            .layout {
                display: flex;
                justify-content: center;
                gap: 40px;
                align-items: flex-start;
                margin-top: 30px;
            }
            .seat-map {
                display: grid;
                grid-template-columns: repeat(12, 50px);
                gap: 8px;
            }
            .seat {
                width: 50px;
                height: 50px;
                border-radius: 6px;
                text-align: center;
                line-height: 50px;
                font-size: 12px;
                font-weight: bold;
                color: white;
                cursor: pointer;
            }
            .regular {
                background-color: green;
            }
            .vip {
                background-color: hotpink;
            }
            .sweetbox {
                background-color: purple;
            }
            .inactive {
                background-color: gray;
                cursor: not-allowed;
            }
            .selected {
                border: 3px solid yellow;
            }

            .ticket-info {
                min-width: 250px;
                border: 1px solid #ccc;
                padding: 20px;
                border-radius: 8px;
                background-color: #f9f9f9;
                font-size: 14px;
            }
            .ticket-info h3 {
                margin-top: 0;
                text-align: center;
            }
            .screen-label {
                text-align: center;
                margin-bottom: 20px;
            }

            .screen {
                background-color: #ccc;
                color: black;
                font-weight: bold;
                padding: 10px 0;
                border-radius: 6px;
                width: 80%;
                margin: 0 auto;
                font-size: 18px;
                box-shadow: 0 2px 6px rgba(0,0,0,0.2);
            }

        </style>
        <script>
            let selectedCount = 0;
            let selectedType = null;
            let totalPrice = 0;

            function updateSelectedSeatsText() {
                const selected = document.querySelectorAll('input[name="selectedSeats"]:checked');
                const seatCodes = Array.from(selected).map(cb => cb.value);
                document.getElementById("selectedSeatsText").innerText = seatCodes.length > 0 ? seatCodes.join(", ") : "Chưa chọn";
            }

            function toggleSeat(seatCode, checkboxId, divId, seatType) {
                const checkbox = document.getElementById(checkboxId);
                const div = document.getElementById(divId);
                const basePrice = parseFloat(document.getElementById("basePrice").value);

                if (checkbox.disabled)
                    return;

                const isSelecting = !checkbox.checked;
                let seatPrice = basePrice;

                if (seatType.toLowerCase() === "vip")
                    seatPrice += 70000;
                else if (seatType.toLowerCase() === "sweetbox")
                    seatPrice += 100000;

                if (isSelecting) {
                    if (selectedCount >= 8) {
                        alert("Bạn chỉ được chọn tối đa 8 ghế.");
                        return;
                    }
                    if (selectedType && selectedType !== seatType) {
                        alert("Bạn chỉ được chọn ghế cùng một loại: " + selectedType);
                        return;
                    }
                    checkbox.checked = true;
                    div.classList.add("selected");
                    selectedCount++;
                    selectedType = seatType;
                    totalPrice += seatPrice;
                } else {
                    checkbox.checked = false;
                    div.classList.remove("selected");
                    selectedCount--;
                    totalPrice -= seatPrice;
                    if (selectedCount === 0)
                        selectedType = null;
                }

                document.getElementById("totalPrice").innerText = totalPrice.toLocaleString() + " VND";
                updateSelectedSeatsText();
            }

            function validateSelection() {
                if (selectedCount === 0) {
                    alert("Bạn chưa chọn ghế nào.");
                    return false;
                }
                return true;
            }
        </script>
    </head>
    <body>
        <h2 style="text-align:center;">Chọn ghế cho phim: "<%= movieTitle %>"</h2>
        <p style="text-align:center;">Suất chiếu: <%= startTime %></p>

        <form action="Seat" method="post" onsubmit="return validateSelection();">
            <input type="hidden" id="basePrice" value="<%= basePrice %>" />

            <div class="layout">
                <!-- Sơ đồ ghế -->
                <div>
                    <div class="screen-label">
                        <div class="screen">MÀN HÌNH</div>
                    </div>
                    <div class="seat-map">
                        <% if (seats != null) {
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
                        <div id="seat_<%= code %>" class="seat <%= cssClass %>"
                             onclick="toggleSeat('<%= code %>', 'cb_<%= code %>', 'seat_<%= code %>', '<%= s.getSeatType() %>')">
                            <%= code %>
                            <input type="checkbox" name="selectedSeats" value="<%= code %>"
                                   id="cb_<%= code %>" style="display:none;" <%= !s.isIsActivate() ? "disabled" : "" %> />
                        </div>
                        <% }} %>
                    </div>

                    <!-- Chú thích -->
                    <div style="margin-top:30px;">
                        <h3>Chú thích ghế</h3>
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
                    <p><strong>Suất chiếu:</strong> <%= startTime %></p>
                    <p><strong>Ghế đã chọn:</strong> <span id="selectedSeatsText">Chưa chọn</span></p>
                    <p><strong>Tổng tiền:</strong> <span id="totalPrice">0 VND</span></p>
            <div style="text-align:center; margin-top:30px;">
                <button type="submit">Đặt ghế</button>
            </div>
                </div>
            </div>

        </form>
    </body>
</html>
