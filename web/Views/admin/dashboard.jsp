<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
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
                --primary: #6d28d9;     /* Tím hiện đại */
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
                    <a href="dashboard"><i class="bi bi-speedometer2"></i> Tổng quan</a>
                    <a href="revenue"><i class="bi bi-graph-up"></i> Doanh thu</a>
                    <a href="foodManagement" class="active"><i class="bi bi-cup-straw"></i> Quản lý Food</a>
                    <a href="../home"><i class="bi bi-house"></i> Trang người dùng</a>
                    <a href="../logout"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a>
                </div>
            </div>
        </header>

        <div class="main-container">

            <!-- Welcome -->
            <div class="welcome-card">
                <div class="bi bi-person-circle"></div>
                <div>
                    Xin chào, <strong>${adminUser.name}</strong>!  
                    <small class="text-muted d-block">| Vai trò: <em>Quản trị viên</em></small>
                </div>
            </div>

            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="icon" style="background: linear-gradient(135deg, #10b981, #059669);">
                        <i class="bi bi-currency-exchange"></i>
                    </div>
                    <h3><fmt:formatNumber value="${todayRevenue}" type="currency" currencySymbol="₫"/></h3>
                    <p>Doanh thu hôm nay</p>
                </div>
                <div class="stat-card">
                    <div class="icon" style="background: linear-gradient(135deg, #3b82f6, #2563eb);">
                        <i class="bi bi-calendar-month"></i>
                    </div>
                    <h3><fmt:formatNumber value="${monthRevenue}" type="currency" currencySymbol="₫"/></h3>
                    <p>Doanh thu tháng</p>
                </div>
                <div class="stat-card">
                    <div class="icon" style="background: linear-gradient(135deg, #8b5cf6, #7c3aed);">
                        <i class="bi bi-calendar3"></i>
                    </div>
                    <h3><fmt:formatNumber value="${yearRevenue}" type="currency" currencySymbol="₫"/></h3>
                    <p>Doanh thu năm</p>
                </div>
                <div class="stat-card">
                    <div class="icon" style="background: linear-gradient(135deg, #f59e0b, #d97706);">
                        <i class="bi bi-ticket-perforated"></i>
                    </div>
                    <h3><c:out value="${totalTickets}"/></h3>
                    <p>Vé đã bán</p>
                </div>
                <div class="stat-card">
                    <div class="icon" style="background: linear-gradient(135deg, #ef4444, #dc2626);">
                        <i class="bi bi-play-circle"></i>
                    </div>
                    <h3><c:out value="${nowShowing}"/></h3>
                    <p>Phim đang chiếu</p>
                </div>
                <div class="stat-card">
                    <div class="icon" style="background: linear-gradient(135deg, #06b6d4, #0891b2);">
                        <i class="bi bi-clock-history"></i>
                    </div>
                    <h3><c:out value="${comingSoon}"/></h3>
                    <p>Phim sắp chiếu</p>
                </div>
                <div class="stat-card">
                    <div class="icon" style="background: linear-gradient(135deg, #10b981, #059669);">
                        <i class="bi bi-building"></i>
                    </div>
                    <h3><c:out value="${activeCinemas}"/></h3>
                    <p>Rạp đang hoạt động</p>
                </div>
                <div class="stat-card">
                    <div class="icon" style="background: linear-gradient(135deg, #8b5cf6, #7c3aed);">
                        <i class="bi bi-people"></i>
                    </div>
                    <h3><c:out value="${totalUsers}"/></h3>
                    <p>Tổng người dùng</p>
                </div>
                <div class="stat-card">
                    <div class="icon" style="background: linear-gradient(135deg, #f97316, #ea580c);">
                        <i class="bi bi-star-fill"></i>
                    </div>
                    <h3><fmt:formatNumber value="${avgRating}" pattern="#.##"/></h3>
                    <p>Đánh giá trung bình</p>
                </div>
            </div>

            <!-- Charts Section -->
            <div class="charts-section">

                <!-- Biểu đồ đường: Doanh thu 12 tháng -->
                <div class="chart-container">
                    <h3><i class="bi bi-graph-up-arrow"></i> Doanh thu 12 tháng</h3>
                    <canvas id="revenueLineChart"></canvas>
                </div>

                <!-- Biểu đồ tròn: Phân bố loại phim -->
                <div class="chart-container small-chart">
                    <h3><i class="bi bi-pie-chart"></i> Phân bố phim</h3>
                    <canvas id="movieTypeChart"></canvas>
                </div>
            </div>

            <!-- Biểu đồ cột: Doanh thu theo rạp (nếu có dữ liệu) -->
            <c:if test="${not empty cinemaRevenue}">
                <div class="chart-container" style="margin-top: 1.5rem;">
                    <h3><i class="bi bi-building-fill-gear"></i> Doanh thu theo rạp</h3>
                    <canvas id="cinemaBarChart"></canvas>
                </div>
            </c:if>

        </div>

        <footer>
            © 2025 Hola Cinema — Admin Dashboard. Được thiết kế với <i class="bi bi-heart-fill text-danger"></i> bởi Team Dev
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Dữ liệu từ server
            const monthlyRevenue = [
            <c:forEach var="r" items="${monthlyRevenue}" varStatus="loop">
                ${r}<c:if test="${!loop.last}">,</c:if>
            </c:forEach>
            ];

            // Giả lập dữ liệu phân bố phim (có thể thay bằng dữ liệu thật)
            const movieTypes = ['Hành động', 'Tình cảm', 'Kinh dị', 'Hài', 'Hoạt hình'];
            const movieCounts = [25, 18, 15, 22, 12];

            // Biểu đồ đường
            const ctxLine = document.getElementById('revenueLineChart').getContext('2d');
            new Chart(ctxLine, {
                type: 'line',
                data: {
                    labels: ['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8', 'T9', 'T10', 'T11', 'T12'],
                    datasets: [{
                            label: 'Doanh thu (₫)',
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
                                callback: value => value.toLocaleString('vi-VN') + '₫'
                            }
                        }
                    }
                }
            });

            // Biểu đồ tròn
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

            // Biểu đồ cột (nếu có dữ liệu rạp)
            <c:if test="${not empty cinemaRevenue}">
            const ctxBar = document.getElementById('cinemaBarChart').getContext('2d');
                    const cinemaNames = [<c:forEach var="entry" items="${cinemaRevenue}">'${entry.key}',</c:forEach>];
            const cinemaRevenues = [<c:forEach var="entry" items="${cinemaRevenue}">${entry.value},</c:forEach>];

            new Chart(ctxBar, {
                type: 'bar',
                data: {
                    labels: cinemaNames,
                    datasets: [{
                            label: 'Doanh thu',
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