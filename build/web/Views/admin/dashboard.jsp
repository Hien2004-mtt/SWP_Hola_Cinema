<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard - Hola Cinema</title>

        <!-- Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css">

        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <style>
            :root {
                --primary: #6C5CE7;
                --primary-light: #A66EFF;
                --primary-dark: #5B4BC4;
                --bg: #F4F6FA;
                --card: #ffffff;
                --text: #2D3436;
                --text-light: #636E72;
                --border: #E5E7EB;
                --shadow: 0 4px 12px rgba(0,0,0,0.06);
                --shadow-hover: 0 8px 20px rgba(0,0,0,0.1);
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Poppins', sans-serif;
                background: var(--bg);
                color: var(--text);
                min-height: 100vh;
            }

            /* Header */
            .header {
                background: var(--card);
                color: var(--text);
                padding: 1.2rem 2rem;
                box-shadow: var(--shadow);
                position: sticky;
                top: 0;
                z-index: 1000;
                border-bottom: 1px solid var(--border);
            }

            .header-content {
                display: flex;
                justify-content: space-between;
                align-items: center;
                max-width: 1400px;
                margin: 0 auto;
            }

            .logo {
                font-weight: 800;
                font-size: 1.6rem;
                display: flex;
                align-items: center;
                gap: 12px;
                background: linear-gradient(135deg, var(--primary) 0%, var(--primary-light) 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }

            .logo i {
                background: linear-gradient(135deg, var(--primary) 0%, var(--primary-light) 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                font-size: 28px;
            }

            .nav-links {
                display: flex;
                gap: 10px;
            }

            .nav-links a {
                color: var(--text);
                text-decoration: none;
                font-weight: 600;
                padding: 0.6rem 1.2rem;
                border-radius: 10px;
                transition: all 0.3s ease;
                font-size: 14px;
            }

            .nav-links a:hover, .nav-links a.active {
                background: linear-gradient(135deg, var(--primary), var(--primary-light));
                color: white;
            }

            /* Main Container */
            .main-container {
                padding: 2.5rem;
                max-width: 1400px;
                margin: 0 auto;
            }

            .page-title {
                font-size: 2rem;
                font-weight: 800;
                color: var(--text);
                margin-bottom: 0.5rem;
                display: flex;
                align-items: center;
                gap: 12px;
            }

            .page-title i {
                background: linear-gradient(135deg, var(--primary), var(--primary-light));
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }

            .page-subtitle {
                color: var(--text-light);
                margin-bottom: 2rem;
                font-size: 15px;
            }

            /* Stats Grid */
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                gap: 24px;
                margin-bottom: 2.5rem;
            }

            .stat-card {
                background: var(--card);
                border-radius: 20px;
                padding: 1.8rem;
                box-shadow: var(--shadow);
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                border: 1px solid var(--border);
                position: relative;
                overflow: hidden;
            }

            .stat-card::before {
                content: '';
                position: absolute;
                top: 0;
                right: 0;
                width: 100px;
                height: 100px;
                background: linear-gradient(135deg, var(--primary), var(--primary-light));
                opacity: 0.05;
                border-radius: 50%;
                transform: translate(30%, -30%);
            }

            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: var(--shadow-hover);
            }

            .stat-header {
                display: flex;
                justify-content: space-between;
                align-items: flex-start;
                margin-bottom: 1rem;
            }

            .stat-icon {
                width: 56px;
                height: 56px;
                border-radius: 16px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 26px;
                color: white;
            }

            .stat-icon.revenue {
                background: linear-gradient(135deg, #6C5CE7, #A66EFF);
            }

            .stat-icon.tickets {
                background: linear-gradient(135deg, #00B894, #55EFC4);
            }

            .stat-icon.movies {
                background: linear-gradient(135deg, #FD79A8, #FDCB6E);
            }

            .stat-icon.users {
                background: linear-gradient(135deg, #0984E3, #74B9FF);
            }

            .stat-content {
                position: relative;
                z-index: 1;
            }

            .stat-label {
                font-size: 14px;
                color: var(--text-light);
                font-weight: 600;
                margin-bottom: 8px;
            }

            .stat-value {
                font-size: 32px;
                font-weight: 800;
                color: var(--text);
                line-height: 1;
            }

            .stat-change {
                font-size: 13px;
                margin-top: 10px;
                display: flex;
                align-items: center;
                gap: 5px;
            }

            .stat-change.positive {
                color: #00B894;
            }

            .stat-change.negative {
                color: #D63031;
            }

            /* Charts Section */
            .charts-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
                gap: 24px;
                margin-bottom: 2.5rem;
            }

            .chart-card {
                background: var(--card);
                border-radius: 20px;
                padding: 1.8rem;
                box-shadow: var(--shadow);
                border: 1px solid var(--border);
            }

            .chart-header {
                margin-bottom: 1.5rem;
            }

            .chart-title {
                font-size: 18px;
                font-weight: 700;
                color: var(--text);
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .chart-title i {
                color: var(--primary);
            }

            .chart-container {
                height: 350px;
                position: relative;
            }

            /* Recent Activity */
            .activity-card {
                background: var(--card);
                border-radius: 20px;
                padding: 1.8rem;
                box-shadow: var(--shadow);
                border: 1px solid var(--border);
            }

            .activity-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 1.5rem;
            }

            .activity-title {
                font-size: 18px;
                font-weight: 700;
                color: var(--text);
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .activity-item {
                padding: 1rem;
                border-bottom: 1px solid var(--border);
                display: flex;
                align-items: center;
                gap: 15px;
                transition: background 0.3s ease;
            }

            .activity-item:last-child {
                border-bottom: none;
            }

            .activity-item:hover {
                background: var(--bg);
                border-radius: 10px;
            }

            .activity-icon {
                width: 40px;
                height: 40px;
                border-radius: 10px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 18px;
                color: white;
                background: linear-gradient(135deg, var(--primary), var(--primary-light));
            }

            .activity-content {
                flex: 1;
            }

            .activity-text {
                font-size: 14px;
                color: var(--text);
                font-weight: 500;
            }

            .activity-time {
                font-size: 12px;
                color: var(--text-light);
            }

            /* Responsive */
            @media (max-width: 768px) {
                .main-container {
                    padding: 1.5rem;
                }

                .stats-grid {
                    grid-template-columns: 1fr;
                }

                .charts-grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <div class="header">
            <div class="header-content">
                <div class="logo">
                    <i class="ri-movie-2-fill"></i>
                    Hola Cinema Admin
                </div>
                <div class="nav-links">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="active">
                        <i class="ri-dashboard-line"></i> Overview
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/revenue">
                        <i class="ri-line-chart-line"></i> Revenue
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/foodManagement">
                        <i class="ri-restaurant-line"></i> Food Management
                    </a>
                    <a href="${pageContext.request.contextPath}/home">
                        <i class="ri-home-line"></i> User Page
                    </a>
                    <a href="${pageContext.request.contextPath}/logout">
                        <i class="ri-logout-box-line"></i> Logout
                    </a>
                </div>
            </div>
        </div>

        <!-- Main Container -->
        <div class="main-container">
            <h1 class="page-title">
                <i class="ri-dashboard-3-line"></i>
                Dashboard Overview
            </h1>
            <p class="page-subtitle">Welcome back! Here's what's happening with your cinema today.</p>

            <!-- Stats Grid -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon revenue">
                            <i class="ri-money-dollar-circle-line"></i>
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-label">Total Revenue</div>
                        <div class="stat-value">
                            <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="$"/>
                        </div>
                        <div class="stat-change positive">
                            <i class="ri-arrow-up-line"></i>
                            +12.5% from last month
                        </div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon tickets">
                            <i class="ri-ticket-2-line"></i>
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-label">Tickets Sold</div>
                        <div class="stat-value">${totalTickets}</div>
                        <div class="stat-change positive">
                            <i class="ri-arrow-up-line"></i>
                            +8.2% from last month
                        </div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon movies">
                            <i class="ri-film-line"></i>
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-label">Active Movies</div>
                        <div class="stat-value">${totalMovies}</div>
                        <div class="stat-change positive">
                            <i class="ri-arrow-up-line"></i>
                            +3 new releases
                        </div>
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-icon users">
                            <i class="ri-user-line"></i>
                        </div>
                    </div>
                    <div class="stat-content">
                        <div class="stat-label">Total Users</div>
                        <div class="stat-value">${totalUsers}</div>
                        <div class="stat-change positive">
                            <i class="ri-arrow-up-line"></i>
                            +156 new users
                        </div>
                    </div>
                </div>
            </div>

            <!-- Charts Grid -->
            <div class="charts-grid">
                <div class="chart-card">
                    <div class="chart-header">
                        <h3 class="chart-title">
                            <i class="ri-bar-chart-line"></i>
                            Revenue Overview
                        </h3>
                    </div>
                    <div class="chart-container">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>

                <div class="chart-card">
                    <div class="chart-header">
                        <h3 class="chart-title">
                            <i class="ri-pie-chart-line"></i>
                            Ticket Distribution
                        </h3>
                    </div>
                    <div class="chart-container">
                        <canvas id="ticketChart"></canvas>
                    </div>
                </div>
            </div>

            <!-- Recent Activity -->
            <div class="activity-card">
                <div class="activity-header">
                    <h3 class="activity-title">
                        <i class="ri-time-line"></i>
                        Recent Activity
                    </h3>
                </div>
                <div class="activity-item">
                    <div class="activity-icon">
                        <i class="ri-ticket-2-line"></i>
                    </div>
                    <div class="activity-content">
                        <div class="activity-text">New ticket booking for "Avengers: Endgame"</div>
                        <div class="activity-time">2 minutes ago</div>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon">
                        <i class="ri-user-add-line"></i>
                    </div>
                    <div class="activity-content">
                        <div class="activity-text">New user registration</div>
                        <div class="activity-time">15 minutes ago</div>
                    </div>
                </div>
                <div class="activity-item">
                    <div class="activity-icon">
                        <i class="ri-film-line"></i>
                    </div>
                    <div class="activity-content">
                        <div class="activity-text">New movie added: "Spider-Man: No Way Home"</div>
                        <div class="activity-time">1 hour ago</div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Revenue Chart
            const revenueCtx = document.getElementById('revenueChart').getContext('2d');
            new Chart(revenueCtx, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                    datasets: [{
                        label: 'Revenue',
                        data: [12000, 19000, 15000, 25000, 22000, 30000],
                        borderColor: '#6C5CE7',
                        backgroundColor: 'rgba(108, 92, 231, 0.1)',
                        tension: 0.4,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: { display: false }
                    }
                }
            });

            // Ticket Chart
            const ticketCtx = document.getElementById('ticketChart').getContext('2d');
            new Chart(ticketCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Standard', 'VIP', 'Premium'],
                    datasets: [{
                        data: [300, 150, 100],
                        backgroundColor: ['#6C5CE7', '#A66EFF', '#00B894']
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
        </script>
    </body>
</html>

