<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Dashboard - Hola Cinema</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: #f4f6f9;
            color: #333;
        }

        /* HEADER */
        header {
            background: #fff;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            padding: 12px 60px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        .logo {
            font-size: 22px;
            font-weight: 700;
            color: #111;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 14px;
        }
        .btn-logout {
            background: #dc3545;
            color: #fff;
            border: none;
            padding: 6px 12px;
            border-radius: 5px;
            text-decoration: none;
            font-size: 13px;
        }
        .btn-logout:hover { background: #c82333; }

        /* SIDEBAR */
        .sidebar {
            width: 240px;
            background: #1a1a1a;
            color: #ddd;
            position: fixed;
            top: 0;
            left: 0;
            bottom: 0;
            padding: 20px;
            padding-top: 80px;
            overflow-y: auto;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
            z-index: 875;
        }
        .sidebar h4 {
            text-align: center;
            margin-bottom: 30px;
            font-size: 20px;
            color: #007bff;
        }
        .sidebar .nav-link {
            display: block;
            padding: 12px 15px;
            color: #ccc;
            text-decoration: none;
            border-radius: 6px;
            margin-bottom: 5px;
            font-weight: 500;
            transition: all 0.3s;
        }
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background: #007bff;
            color: white;
            padding-left: 20px;
        }
        .sidebar .nav-link i {
            margin-right: 8px;
            font-style: normal;
        }

        /* MAIN CONTENT */
        .main-content {
            margin-left: 240px;
            padding: 30px 60px;
            min-height: 100vh;
        }
        .page-title {
            font-size: 26px;
            font-weight: 600;
            color: #111;
            margin-bottom: 10px;
            border-left: 5px solid #007bff;
            padding-left: 12px;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
            gap: 20px;
            margin-top: 25px;
        }
        .stat-card {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            text-align: center;
            transition: transform 0.3s;
        }
        .stat-card:hover {
            transform: translateY(-5px);
        }
        .stat-card h3 {
            font-size: 14px;
            color: #666;
            margin: 0 0 10px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .stat-card .number {
            font-size: 28px;
            font-weight: 700;
            color: #007bff;
        }

        /* Responsive */
        @media (max-width: 992px) {
            .sidebar { width: 80px; padding: 20px 10px; }
            .sidebar h4, .sidebar .nav-link span { display: none; }
            .sidebar .nav-link { text-align: center; padding: 15px 0; }
            .main-content { margin-left: 80px; padding: 20px; }
            header { padding: 10px 20px; }
        }
        @media (max-width: 768px) {
            .sidebar { 
                transform: translateX(-100%);
                transition: transform 0.3s;
            }
            .sidebar.active { transform: translateX(0); }
            .main-content { margin-left: 0; }
            .mobile-toggle {
                display: block !important;
                background: none;
                border: none;
                font-size: 20px;
                color: #333;
                cursor: pointer;
            }
        }
        .mobile-toggle { display: none; }
    </style>
</head>
<body>
     <jsp:include page="/Inculude/Header.jsp" />

    <!-- SIDEBAR -->
    <div class="sidebar" id="sidebar">
        <h4>🎬 Manager</h4>
        <a href="dashboard.jsp" class="nav-link active"><i>📊</i> <span>Overview</span></a>
        <a href="movie_management.jsp" class="nav-link"><i>🎥</i> <span>Movie Management</span></a>
        <a href="showtime_management.jsp" class="nav-link"><i>🕒</i> <span>Showtime</span></a>
        <a href="ticket_management.jsp" class="nav-link"><i>🎟️</i> <span>Ticket</span></a>
        <a href="${pageContext.request.contextPath}/listAuditorium" class="nav-link"><i>💺</i> <span>Auditorium Management</span></a>
        <a href="revenue_management.jsp" class="nav-link"><i>💰</i> <span>Revenue</span></a>
        <a href="staff_management.jsp" class="nav-link"><i>👥</i> <span>Staff</span></a>
        <a href="user_management.jsp" class="nav-link"><i>👤</i> <span>User</span></a>
    </div>

 

 

    <!-- Mobile menu toggle script -->
    <script>
        const sidebar = document.getElementById('sidebar');
        const toggle = document.getElementById('mobileToggle');
        toggle.addEventListener('click', () => {
            sidebar.classList.toggle('active');
        });
    </script>
</body>
</html>