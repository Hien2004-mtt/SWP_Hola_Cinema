<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch Chiếu Phim - Hola Cinema</title>
    <link rel="stylesheet" href="css/schedule.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .agenda-content {
            margin-left: 250px;
            padding: 40px;
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.08);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <h2>Menu</h2>
            <nav>
                <a href="Views/agenda.jsp" class="active">
                    <i class="fas fa-calendar-alt" style="margin-right:8px;"></i> Lịch Chiếu Phim
                </a>
                <a href="Views/manageSchedule.jsp">
                    <i class="fas fa-cogs" style="margin-right:8px;"></i> Quản Lý Lịch Chiếu
                </a>
            </nav>
        </div>
        <div class="agenda-content">
            <h1><i class="fas fa-calendar-alt"></i> Lịch Chiếu Phim</h1>
            <p>Đây là trang hiển thị lịch chiếu phim tổng quan cho rạp Hola Cinema.</p>
            <!-- Bạn có thể thêm bảng lịch chiếu, filter, hoặc calendar ở đây -->
        </div>
    </div>
</body>
</html>
