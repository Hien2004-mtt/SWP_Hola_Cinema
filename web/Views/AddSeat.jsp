<%@ page import="java.util.*, Models.Auditorium" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <title>Tạo sơ đồ ghế cho phòng</title>
        <style>
            body {
                font-family: Arial;
                background: #f9f9f9;
                margin: 40px;
            }
            .container {
                max-width: 600px;
                margin: auto;
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            label {
                font-weight: bold;
            }
            input, select, button {
                width: 100%;
                padding: 8px;
                margin: 8px 0;
            }
            button {
                background: #007bff;
                color: white;
                border: none;
                cursor: pointer;
                border-radius: 4px;
            }
            button:hover {
                background: #0056b3;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h2>🎬 Tạo sơ đồ ghế cho phòng có sẵn</h2>
            <form method="post" action="seatAdd">
                <label>Chọn phòng chiếu:</label>
                <select name="auditoriumId" required>
                    <%
                        List<Auditorium> auditoriums = (List<Auditorium>) request.getAttribute("auditoriums");
                        if (auditoriums != null) {
                            for (Auditorium a : auditoriums) {
                    %>
                    <option value="<%= a.getAuditoriumId() %>"><%= a.getName() %></option>
                    <%
                            }
                        }
                    %>
                </select>

                <label>Số hàng:</label>
                <input type="number" name="rows" min="1" max="26" required>

                <label>Số cột mỗi hàng:</label>
                <input type="number" name="cols" min="1" max="20" required>

                <label>Loại ghế mặc định:</label>
                <select name="seatType">
                    <option value="Regular">Regular</option>
                    <option value="VIP">VIP</option>
                    <option value="SweetBox">SweetBox</option>
                </select>

                <button type="submit">Tạo sơ đồ ghế</button>
            </form>
        </div>
    </body>
</html>
