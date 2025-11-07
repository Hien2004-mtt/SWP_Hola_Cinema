<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.math.BigDecimal, Models.RevenueRecord"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Doanh thu - Hola Cinema Admin</title>

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

            .nav-links a:hover, .nav-links a.active {
                background: rgba(255,255,255,0.15);
                color: white;
            }

            .main-container {
                padding: 2rem;
                max-width: 1400px;
                margin: 0 auto;
            }

            .page-title {
                font-size: 1.8rem;
                font-weight: 700;
                color: var(--primary);
                margin-bottom: 1.5rem;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            /* === FILTERS - FIX ĐÈ CHỮ 100% === */
            .filter-card {
                background: var(--card);
                padding: 1.5rem;
                border-radius: 16px;
                box-shadow: var(--shadow);
                margin-bottom: 1.5rem;
            }

            .filter-row {
                display: flex;
                flex-wrap: wrap;
                gap: 1rem;
                align-items: flex-start;
            }

            .filter-group {
                flex: 1;
                min-width: 280px;
                background: #f8f9ff;
                padding: 0.75rem 1rem;
                border-radius: 12px;
                border: 1px solid #e2e8f0;
            }

            .filter-group form {
                display: flex;
                flex-wrap: wrap;
                gap: 0.5rem;
                align-items: center;
            }

            .filter-group label {
                font-weight: 600;
                color: var(--text);
                white-space: nowrap;
                font-size: 0.9rem;
                min-width: 50px;
            }

            .filter-group .form-control,
            .filter-group .btn {
                font-size: 0.85rem;
                padding: 0.35rem 0.6rem;
                border-radius: 8px;
                flex-shrink: 0;
            }

            .filter-group .form-control {
                flex: 1;
                min-width: 80px;
            }

            .filter-group .btn {
                white-space: nowrap;
                min-width: 70px;
            }

            .sort-group {
                display: flex;
                gap: 0.5rem;
                align-items: center;
                flex-wrap: wrap;
            }

            .table-container {
                background: var(--card);
                border-radius: 16px;
                overflow: hidden;
                box-shadow: var(--shadow);
                margin-bottom: 2rem;
            }

            .table {
                margin: 0;
            }

            .table thead {
                background: linear-gradient(135deg, var(--primary), var(--primary-dark));
                color: white;
            }

            .table th {
                font-weight: 600;
                border: none;
            }

            .table tbody tr:hover {
                background: #f8f9ff;
            }

            .charts-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 1.5rem;
                margin-bottom: 2rem;
            }

            .chart-container {
                background: var(--card);
                padding: 1.5rem;
                border-radius: 16px;
                box-shadow: var(--shadow);
                height: 380px;
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
                font-weight: 600;
            }

            .chart-container canvas {
                flex: 1;
            }

            footer {
                text-align: center;
                padding: 2rem;
                color: var(--text-light);
                font-size: 0.9rem;
                margin-top: 3rem;
                border-top: 1px solid var(--border);
            }

            /* RESPONSIVE */
            @media (max-width: 992px) {
                .filter-group {
                    min-width: 100%;
                }
                .charts-grid {
                    grid-template-columns: 1fr;
                }
            }

            @media (max-width: 576px) {
                .filter-group form {
                    flex-direction: column;
                    align-items: stretch;
                }
                .filter-group .form-control,
                .filter-group .btn {
                    width: 100%;
                }
                .filter-group label {
                    text-align: left;
                }
                .main-container {
                    padding: 1rem;
                }
            }
        </style>
    </head>
    <body>

        <!-- Header -->
        <header class="header">
            <div class="container-fluid d-flex justify-content-between align-items-center">
                <div class="logo">
                    <span class="bi bi-film"></span> Hola Cinema
                </div>
                <div class="nav-links">
                    <a href="dashboard"><i class="bi bi-speedometer2"></i> Tổng quan</a>
                    <a href="revenue" class="active"><i class="bi bi-graph-up"></i> Doanh thu</a>
                    <a href="foodManagement" class="active"><i class="bi bi-cup-straw"></i> Quản lý Food</a>
                    <a href="../home"><i class="bi bi-house"></i> Trang người dùng</a>
                    <a href="../logout"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a>
                </div>
            </div>
        </header>

        <div class="main-container">

            <!-- Page Title -->
            <h1 class="page-title">
                <i class="bi bi-graph-up-arrow"></i> Quản lý Doanh thu Nâng cao
            </h1>

            <!-- Filters - KHÔNG CÒN ĐÈ CHỮ -->
            <div class="filter-card">
                <div class="filter-row">

                    <!-- Lọc ngày -->
                    <div class="filter-group">
                        <form method="get" action="revenue">
                            <label>Từ:</label>
                            <input type="date" name="from" value="${fromDate}" class="form-control">
                            <label>Đến:</label>
                            <input type="date" name="to" value="${toDate}" class="form-control">
                            <button type="submit" class="btn btn-primary">Lọc</button>
                        </form>
                    </div>

                    <!-- Tìm phim -->
                    <div class="filter-group">
                        <form method="get" action="revenue">
                            <input type="hidden" name="from" value="${fromDate}">
                            <input type="hidden" name="to" value="${toDate}">
                            <label>Tên phim:</label>
                            <input type="text" name="movieName" placeholder="Nhập tên..." value="${movieName}" class="form-control">
                            <button type="submit" name="action" value="searchByName" class="btn btn-primary">Tìm</button>
                        </form>
                    </div>

                    <!-- Lọc tiền -->
                    <div class="filter-group">
                        <form method="get" action="revenue">
                            <input type="hidden" name="from" value="${fromDate}">
                            <input type="hidden" name="to" value="${toDate}">
                            <label>Từ:</label>
                            <input type="number" step="1000" name="min" placeholder="VNĐ" value="${min}" class="form-control">
                            <label>Đến:</label>
                            <input type="number" step="1000" name="max" placeholder="VNĐ" value="${max}" class="form-control">
                            <button type="submit" name="action" value="searchByPrice" class="btn btn-primary">Lọc tiền</button>
                        </form>
                    </div>

                    <!-- Sắp xếp -->
                    <div class="filter-group">
                        <div class="sort-group w-100 d-flex justify-content-center gap-2">
                            <form method="get" action="revenue">
                                <input type="hidden" name="from" value="${fromDate}">
                                <input type="hidden" name="to" value="${toDate}">
                                <button type="submit" name="action" value="sortAsc" class="btn btn-outline-secondary">Tăng dần</button>
                            </form>
                            <form method="get" action="revenue">
                                <input type="hidden" name="from" value="${fromDate}">
                                <input type="hidden" name="to" value="${toDate}">
                                <button type="submit" name="action" value="sortDesc" class="btn btn-outline-secondary">Giảm dần</button>
                            </form>
                        </div>
                    </div>

                </div>
            </div>

            <!-- Bảng dữ liệu -->
            <div class="table-container">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Tên phim</th>
                            <th>Số vé bán</th>
                            <th>Doanh thu (VNĐ)</th>
                            <th>Ngày thanh toán gần nhất</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<RevenueRecord> list = (List<RevenueRecord>) request.getAttribute("revenueList");
                            if (list != null && !list.isEmpty()) {
                                int i = 1;
                                for (RevenueRecord r : list) {
                        %>
                        <tr>
                            <td><%= i++ %></td>
                            <td><strong><%= r.getMovieTitle() %></strong></td>
                            <td><%= r.getTotalTickets() %></td>
                            <td><fmt:formatNumber value="<%= r.getTotalRevenue() %>" type="currency" currencySymbol="₫"/></td>
                            <td><%= r.getPaidAt() %></td>
                        </tr>
                        <%  }
                    } else { %>
                        <tr>
                            <td colspan="5" class="text-center py-4 text-muted">Không có dữ liệu phù hợp</td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- Biểu đồ -->
            <% if (list != null && !list.isEmpty()) { %>
            <div class="charts-grid">
                <!-- Biểu đồ cột -->
                <div class="chart-container">
                    <h3><i class="bi bi-bar-chart-fill"></i> Doanh thu theo phim</h3>
                    <canvas id="revenueBarChart"></canvas>
                </div>

                <!-- Biểu đồ tròn -->
                <div class="chart-container">
                    <h3><i class="bi bi-pie-chart-fill"></i> Tỷ lệ đóng góp</h3>
                    <canvas id="revenuePieChart"></canvas>
                </div>
            </div>

            <!-- Biểu đồ đường -->
            <div class="chart-container" style="grid-column: span 2; height: 400px;">
                <h3><i class="bi bi-graph-up-arrow"></i> Xu hướng doanh thu theo ngày</h3>
                <canvas id="revenueLineChart"></canvas>
            </div>

            <script>
                const movies = [
                <% for (RevenueRecord r : list) { %>
                    {name: "<%= r.getMovieTitle().replace("\"", "\\\"") %>",
                        revenue: <%= r.getTotalRevenue() %>,
                        tickets: <%= r.getTotalTickets() %>,
                        date: "<%= r.getPaidAt() %>"},
                <% } %>
                ];

                // Biểu đồ cột
                new Chart(document.getElementById('revenueBarChart').getContext('2d'), {
                    type: 'bar',
                    data: {
                        labels: movies.map(m => m.name.length > 15 ? m.name.substring(0, 15) + '...' : m.name),
                        datasets: [{
                                label: 'Doanh thu (₫)',
                                data: movies.map(m => m.revenue),
                                backgroundColor: 'rgba(109, 40, 217, 0.7)',
                                borderColor: '#6d28d9',
                                borderWidth: 1
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {legend: {display: false}},
                        scales: {y: {beginAtZero: true}}
                    }
                });

                // Biểu đồ tròn
                new Chart(document.getElementById('revenuePieChart').getContext('2d'), {
                    type: 'doughnut',
                    data: {
                        labels: movies.map(m => m.name.length > 12 ? m.name.substring(0, 12) + '...' : m.name),
                        datasets: [{
                                data: movies.map(m => m.revenue),
                                backgroundColor: ['#8b5cf6', '#3b82f6', '#10b981', '#f59e0b', '#ef4444', '#06b6d4', '#f97316', '#ec4899', '#6366f1', '#14b8a6'],
                                borderWidth: 2,
                                borderColor: '#fff'
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {legend: {position: 'bottom'}}
                    }
                });

                // Biểu đồ đường
                const dateMap = {};
                movies.forEach(m => {
                    dateMap[m.date] = (dateMap[m.date] || 0) + m.revenue;
                });
                const sortedDates = Object.keys(dateMap).sort();
                const lineData = sortedDates.map(d => dateMap[d]);

                new Chart(document.getElementById('revenueLineChart').getContext('2d'), {
                    type: 'line',
                    data: {
                        labels: sortedDates,
                        datasets: [{
                                label: 'Doanh thu theo ngày',
                                data: lineData,
                                borderColor: '#6d28d9',
                                backgroundColor: 'rgba(109, 40, 217, 0.1)',
                                fill: true,
                                tension: 0.4,
                                pointBackgroundColor: '#6d28d9',
                                pointRadius: 5
                            }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {legend: {display: false}},
                        scales: {
                            y: {
                                beginAtZero: true,
                                ticks: {callback: v => v.toLocaleString('vi-VN') + '₫'}
                            }
                        }
                    }
                });
            </script>
            <% } %>

        </div>

        <!-- Footer -->
        <footer>
            © 2025 Hola Cinema — Admin Dashboard. Được thiết kế với <i class="bi bi-heart-fill text-danger"></i> bởi Team Dev
        </footer>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>