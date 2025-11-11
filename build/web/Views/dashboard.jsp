<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background: #f5f5f5;
        }
        h1 {
            color: #333;
        }
        .card {
            background: white;
            padding: 20px;
            margin: 15px 0;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .stat {
            font-size: 20px;
            font-weight: bold;
            color: #0078d7;
        }
    </style>
</head>
<body>
    <h1>🎬 Cinema Dashboard</h1>

    <div class="card">
        <p>Total Revenue:</p>
        <p class="stat">$<%= request.getAttribute("revenue") %></p>
    </div>

    <div class="card">
        <p>Tickets Sold:</p>
        <p class="stat"><%= request.getAttribute("tickets") %></p>
    </div>

    <div class="card">
        <p>Total Customers:</p>
        <p class="stat"><%= request.getAttribute("customers") %></p>
    </div>

</body>
</html>
