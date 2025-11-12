<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard - Hola Cinema</title>

        <!-- Bootstrap 5 + Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <style>
            :root {
                --primary: #6d28d9;
                --primary-light: #a78bff;
                --primary-dark: #5b21b6;
                --accent: #e879f9;
                --bg: #f8f9ff;
                --card: #ffffff;
                --text: #1f2937;
                --text-light: #6b7280;
                --border: #e5e7eb;
                --shadow: 0 4px 15px rgba(109, 40, 217, 0.1);
            }

            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Inter', 'Segoe UI', sans-serif;
                background: linear-gradient(to bottom right, #f8f9ff, #eef2ff);
                color: var(--text);
                min-height: 100vh;
            }

            /* Header */
            .header {
                background: linear-gradient(135deg, var(--primary), var(--primary-dark));
                color: white;
                padding: 1rem 2rem;
                box-shadow: 0 4px 12px rgba(109, 40, 217, 0.2);
                position: sticky;
                top: 0;
                z-index: 1000;
            }

            .header .logo {
                font-weight: 700;
                font-size: 1.5rem;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .nav-links a {
                color: rgba(255,255,255,0.9);
                text-decoration: none;
                font-weight: 500;
                padding: 0.5rem 1rem;
                border-radius: 8px;
                transition: all 0.3s ease;
            }

            .nav-links a:hover {
                background: rgba(255,255,255,0.15);
                color: white;
            }

            /* Container */
            .main-container {
                padding: 2rem;
                max-width: 1400px;
                margin: 0 auto;
            }

            .welcome-card {
                background: var(--card);
                padding: 1.5rem;
                border-radius: 16px;
                box-shadow: var(--shadow);
                margin-bottom: 2rem;
                display: flex;
                align-items: center;
                gap: 1rem;
                font-size: 1.1rem;
            }

            .welcome-card .bi {
                font-size: 1.8rem;
                color: var(--primary);
            }

            /* Stats Cards */
            .stats-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
                gap: 1.5rem;
                margin-bottom: 2rem;
            }

            .stat-card {
                background: var(--card);
                padding: 1.5rem;
                border-radius: 16px;
                box-shadow: var(--shadow);
                text-align: center;
                transition: all 0.3s ease;
                border: 1px solid var(--border);
            }

            .stat-card:hover {
                transform: translateY(-6px);
                box-shadow: 0 12px 25px rgba(109, 40, 217, 0.18);
            }

            .stat-card .icon {
                width: 50px;
                height: 50px;
                margin: 0 auto 1rem;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
                color: white;
            }

            .stat-card h3 {
                font-size: 1.8rem;
                font-weight: 700;
                color: var(--primary);
                margin: 0.5rem 0;
            }

            .stat-card p {
                color: var(--text-light);
                font-size: 0.95rem;
                margin: 0;
            }

            /* Chart Section */
            .charts-section {
                display: grid;
                grid-template-columns: 2fr 1fr;
                gap: 1.5rem;
                margin-top: 1rem;
            }

            .chart-container {
                background: var(--card);
                padding: 1.5rem;
                border-radius: 16px;
                box-shadow: var(--shadow);
                height: 320px;
                display: flex;
                flex-direction: column;
            }

            .chart-container h3 {
                margin: 0 0 1rem;
                font-size: 1.1rem;
                color: var(--text);
                display: flex;
                align-items: center;
                gap: 8px;
            }

            .chart-container canvas {
                flex: 1;
                max-height: 260px;
            }

            .small-chart {
                height: 320px;
            }

            /* Footer */
            footer {
                text-align: center;
                padding: 2rem;
                color: var(--text-light);
                font-size: 0.9rem;
                margin-top: 3rem;
                border-top: 1px solid var(--border);
            }

            /* Responsive */
            @media (max-width: 992px) {
                .charts-section {
                    grid-template-columns: 1fr;
                }
            }

            @media (max-width: 576px) {
                .main-container {
                    padding: 1rem;
                }
                .welcome-card {
                    flex-direction: column;
                    text-align: center;
                }
                .stats-grid {
                    grid-template-columns: 1fr;
                }
            }
        </style>
    </head>
    <body>

        <header class="header">
            <div class="container-fluid d-flex justify-content-between align-items-center">
                <div class="logo">
                    <span class="bi bi-film"></span> Hola Cinema
                </div>
                <div class="nav-links">
                    <a href="dashboard"><i class="bi bi-speedometer2"></i> Overview</a>
                    <a href="revenue"><i class="bi bi-graph-up"></i> Revenue</a>
                    <a href="foodManagement" class="active"><i class="bi bi-cup-straw"></i> Manage Food</a>
                    <a href="../home"><i class="bi bi-house"></i> User Page</a>
                    <a href="../logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
                </div>
            </div>
        </header>

        <div class="main-container">

            <!-- Welcome -->
            <div class="welcome-card">
                <div class="bi bi-person-circle"></div>
                <div>
                    Welcome, <strong>${adminUser.name}</strong>!  
                    <small class="text-muted d-block">| Role: <em>Administrator</em></small>
                </div>
            </div>

            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="icon" style="background: linear-gradient(135deg, #10b981, #059669);">
                        <i class="bi bi-currency-exchange"></i>
                    </div>
                    <h3><fmt:formatNumber value="${todayRevenue}" type="currency" currencySymbol="₫"/></h3>
                    <p>Today's Revenue</p>
                </div>
                <div class="stat-card">
                    <div class="icon" style="background: linear-gradient(135deg, #3b82f6, #2563eb);">
                        <i class="bi bi-calendar-month"></i>
                    </div>
                    <h3><fmt:formatNumber value="${monthRevenue}" type="currency" currencySymbol="₫"/></h3>
                    <p>Monthly Revenue</p>
                </div>
                <div class="stat-card">
                    <div class="icon" style="background: linear-gradient(135deg, #8b5cf6, #7c3aed);">
                        <i class="bi bi-calendar3"></i>
                    </div>
                    <h3><fmt:formatNumber value="${yearRevenue}" type="currency" currencySymbol="₫"/></h3>
                    <p>Yearly Revenue</p>
                </div>
                <div class="stat-card">
                    <div class="icon" style="background: linear-gradient(135deg, #f59e0b, #d97706);">
                        <i class="bi bi-ticket-perforated"></i>
                    </div>
                    <h3><c:out value="${totalTickets}"/></h3>
                    <p>Tickets Sold</p>
                </div>
                <div class="stat-card">
                    <div class="icon" style="background: linear-gradient(135deg, #ef4444, #dc2626);">
                        <i class="bi bi-play-circle"></i>
                    </div>
                    <h3><c:out value="${nowShowing}"/></h3>
                    <p>Now Showing</p>
                </div>
                <div class="stat-card">
                    <div class="icon" style="background: linear-gradient(135deg, #06b6d4, #0891b2);">
                        <i class="bi bi-clock-history"></i>
                    </div>
                    <h3><c:out value="${comingSoon}"/></h3>
                    <p>Coming Soon</p>
                </div>
                <div class="stat-card">
                    <div class="icon" style="background: linear-gradient(135deg, #10b981, #059669);">
                        <i class="bi bi-building"></i>
                    </div>
                    <h3><c:out value="${activeCinemas}"/></h3>
                    <p>Active Cinemas</p>
                </div>
                <div class="stat-card">
                    <div class="icon" style="background: linear-gradient(135deg, #8b5cf6, #7c3aed);">
                        <i class="bi bi-people"></i>
                    </div>
                    <h3><c:out value="${totalUsers}"/></h3>
                    <p>Total Users</p>
                </div>
                <div class="stat-card">
                    <div class="icon" style="background: linear-gradient(135deg, #f97316, #ea580c);">
                        <i class="bi bi-star-fill"></i>
                    </div>
                    <h3><fmt:formatNumber value="${avgRating}" pattern="#.##"/></h3>
                    <p>Average Rating</p>
                </div>
            </div>

            <!-- Charts Section -->
            <div class="charts-section">

                <!-- Line Chart: 12-Month Revenue -->
                <div class="chart-container">
                    <h3><i class="bi bi-graph-up-arrow"></i> 12-Month Revenue</h3>
                    <canvas id="revenueLineChart"></canvas>
                </div>

                <!-- Pie Chart: Movie Distribution -->
                <div class="chart-container small-chart">
                    <h3><i class="bi bi-pie-chart"></i> Movie Distribution</h3>
                    <canvas id="movieTypeChart"></canvas>
                </div>
            </div>

            <!-- Bar Chart: Revenue by Cinema (if data available) -->
            <c:if test="${not empty cinemaRevenue}">
                <div class="chart-container" style="margin-top: 1.5rem;">
                    <h3><i class="bi bi-building-fill-gear"></i> Revenue by Cinema</h3>
                    <canvas id="cinemaBarChart"></canvas>
                </div>
            </c:if>

        </div>

        <footer>
            © 2025 Hola Cinema — Admin Dashboard. Designed with <i class="bi bi-heart-fill text-danger"></i> by the Dev Team.
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Data from server
            const monthlyRevenue = [
            <c:forEach var="r" items="${monthlyRevenue}" varStatus="loop">
                ${r}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
            ];

            // Example data for movie distribution (replace with actual data)
            const movieTypes = ['Action', 'Romance', 'Horror', 'Comedy', 'Animation'];
            const movieCounts = [25, 18, 15, 22, 12];

            // Line Chart
            const ctxLine = document.getElementById('revenueLineChart').getContext('2d');
            new Chart(ctxLine, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                    datasets: [{
                            label: 'Revenue (₫)',
                            data: monthlyRevenue,
                            borderColor: '#6d28d9',
                            backgroundColor: 'rgba(109, 40, 217, 0.1)',
                            fill: true,
                            tension: 0.4,
                            pointBackgroundColor: '#6d28d9',
                            pointRadius: 5,
                            pointHoverRadius: 7
                        }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {display: false}
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: value => value.toLocaleString('en-US') + '₫'
                            }
                        }
                    }
                }
            });

            // Pie Chart
            const ctxPie = document.getElementById('movieTypeChart').getContext('2d');
            new Chart(ctxPie, {
                type: 'doughnut',
                data: {
                    labels: movieTypes,
                    datasets: [{
                            data: movieCounts,
                            backgroundColor: [
                                '#8b5cf6', '#3b82f6', '#10b981', '#f59e0b', '#ef4444'
                            ],
                            borderWidth: 2,
                            borderColor: '#fff'
                        }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {position: 'bottom', labels: {padding: 15}}
                    }
                }
            });

            // Bar Chart (if cinema data exists)
            <c:if test="${not empty cinemaRevenue}">
            const ctxBar = document.getElementById('cinemaBarChart').getContext('2d');
            const cinemaNames = [<c:forEach var="entry" items="${cinemaRevenue}">'${entry.key}',</c:forEach>];
            const cinemaRevenues = [<c:forEach var="entry" items="${cinemaRevenue}">${entry.value},</c:forEach>];

            new Chart(ctxBar, {
                type: 'bar',
                data: {
                    labels: cinemaNames,
                    datasets: [{
                            label: 'Revenue',
                            data: cinemaRevenues,
                            backgroundColor: 'rgba(109, 40, 217, 0.7)',
                            borderColor: '#6d28d9',
                            borderWidth: 1
                        }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {legend: {display: false}},
                    scales: {
                        y: {beginAtZero: true}
                    }
                }
            });
            </c:if>
        </script>

    </body>
</html>
