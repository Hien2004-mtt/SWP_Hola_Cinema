<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.Food, java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Food - Hola Cinema Admin</title>

    <!-- Bootstrap 5 + Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">

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

        /* Nút thêm món */
        .btn-add {
            background: var(--primary);
            color: white;
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            font-weight: 600;
            box-shadow: var(--shadow);
            transition: all 0.3s;
        }

        .btn-add:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
        }

        /* Filters */
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
            min-width: 260px;
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
        .filter-group .form-select,
        .filter-group .btn {
            font-size: 0.85rem;
            padding: 0.35rem 0.6rem;
            border-radius: 8px;
        }

        .filter-group .form-control,
        .filter-group .form-select {
            flex: 1;
            min-width: 80px;
        }

        .filter-group .btn {
            background: var(--primary);
            border: none;
            white-space: nowrap;
            min-width: 70px;
        }

        .filter-group .btn:hover {
            background: var(--primary-dark);
        }

        /* Bảng */
        .table-container {
            background: var(--card);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
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

        .badge {
            font-size: 0.8rem;
            padding: 0.35rem 0.65rem;
        }

        /* Nút hành động */
        .action-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 0.35rem 0.75rem;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 500;
            text-decoration: none;
            transition: all 0.2s;
        }

        .edit-btn {
            background: #10b981;
            color: white;
        }
        .edit-btn:hover { background: #059669; }

        .toggle-btn {
            background: #f59e0b;
            color: white;
        }
        .toggle-btn:hover { background: #d97706; }

        .delete-btn {
            background: #ef4444;
            color: white;
        }
        .delete-btn:hover { background: #dc2626; }

        /* Phân trang */
        .pagination {
            display: flex;
            justify-content: center;
            gap: 0.5rem;
            margin: 2rem 0;
        }

        .pagination a {
            padding: 0.5rem 1rem;
            border: 1px solid var(--border);
            border-radius: 8px;
            text-decoration: none;
            color: var(--text);
            font-size: 0.9rem;
            transition: all 0.3s;
        }

        .pagination a.active {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
        }

        .pagination a:hover:not(.active) {
            background: #f1f5f9;
        }

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
            .filter-group { min-width: 100%; }
        }

        @media (max-width: 576px) {
            .filter-group form {
                flex-direction: column;
                align-items: stretch;
            }
            .filter-group .form-control,
            .filter-group .form-select,
            .filter-group .btn {
                width: 100%;
            }
            .main-container { padding: 1rem; }
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
            <a href="revenue"><i class="bi bi-graph-up"></i> Doanh thu</a>
            <a href="foodManagement" class="active"><i class="bi bi-cup-straw"></i> Quản lý Food</a>
            <a href="../accountList"><i class="bi bi-people"></i> Account List</a>
            <a href="../home"><i class="bi bi-house"></i> Trang người dùng</a>
            <a href="../logout"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a>
        </div>
    </div>
</header>

<div class="main-container">

    <!-- Page Title + Nút thêm -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="page-title">
            <i class="bi bi-cup-straw"></i> Quản lý Food & Đồ uống
        </h1>
        <button class="btn btn-add" data-bs-toggle="modal" data-bs-target="#addModal">
            <i class="bi bi-plus-circle"></i> Thêm món
        </button>
    </div>

    <!-- Bộ lọc + Sắp xếp -->
    <div class="filter-card">
        <div class="filter-row">

            <!-- Tìm tên -->
            <div class="filter-group">
                <form method="get" action="foodManagement">
                    <label>Tên:</label>
                    <input type="text" name="name" placeholder="Tìm tên..." value="${name}" class="form-control">
                    <button type="submit" class="btn btn-primary">Tìm</button>
                </form>
            </div>

            <!-- Loại -->
            <div class="filter-group">
                <form method="get" action="foodManagement">
                    <label>Loại:</label>
                    <select name="type" class="form-select">
                        <option value="">-- Tất cả --</option>
                        <option value="snack" ${type=="snack"?"selected":""}>Snack</option>
                        <option value="drink" ${type=="drink"?"selected":""}>Drink</option>
                        <option value="popcorn" ${type=="popcorn"?"selected":""}>Popcorn</option>
                    </select>
                    <button type="submit" class="btn btn-primary">Lọc</button>
                </form>
            </div>

            <!-- Khoảng giá -->
            <div class="filter-group">
                <form method="get" action="foodManagement">
                    <label>Từ:</label>
                    <input type="number" name="min" placeholder="VNĐ" step="1000" value="${min}" class="form-control">
                    <label>Đến:</label>
                    <input type="number" name="max" placeholder="VNĐ" step="1000" value="${max}" class="form-control">
                    <button type="submit" class="btn btn-primary">Lọc giá</button>
                </form>
            </div>

            <!-- Trạng thái -->
            <div class="filter-group">
                <form method="get" action="foodManagement">
                    <label>Trạng thái:</label>
                    <select name="status" class="form-select">
                        <option value="">-- Tất cả --</option>
                        <option value="1" ${status=="1"?"selected":""}>Còn hàng</option>
                        <option value="0" ${status=="0"?"selected":""}>Hết hàng</option>
                    </select>
                    <button type="submit" class="btn btn-primary">Lọc</button>
                </form>
            </div>

            <!-- Sắp xếp -->
            <div class="filter-group">
                <form method="get" action="foodManagement">
                    <label>Sắp xếp:</label>
                    <select name="sort" class="form-select">
                        <option value="">-- Giá --</option>
                        <option value="asc" ${sort=="asc"?"selected":""}>Tăng dần</option>
                        <option value="desc" ${sort=="desc"?"selected":""}>Giảm dần</option>
                    </select>
                    <button type="submit" class="btn btn-primary">Sắp xếp</button>
                </form>
            </div>

        </div>
    </div>

    <!-- Bảng dữ liệu -->
    <div class="table-container">
        <table class="table table-hover">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên món</th>
                    <th>Loại</th>
                    <th>Giá (VNĐ)</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Food> list = (List<Food>) request.getAttribute("foodList");
                    if (list != null && !list.isEmpty()) {
                        for (Food f : list) {
                %>
                <tr>
                    <td><%= f.getFoodId() %></td>
                    <td><strong><%= f.getName() %></strong></td>
                    <td>
                        <span class="badge bg-primary-subtle text-primary">
                            <%= f.getType().equals("snack") ? "Snack" : 
                                f.getType().equals("drink") ? "Drink" : "Popcorn" %>
                        </span>
                    </td>
                    <td><fmt:formatNumber value="<%= f.getPrice() %>" type="currency" currencySymbol="₫"/></td>
                    <td>
                        <span class="badge <%= f.isStatus() ? "bg-success" : "bg-danger" %>">
                            <%= f.isStatus() ? "Còn hàng" : "Hết hàng" %>
                        </span>
                    </td>
                    <td>
                        <a href="#" class="action-btn edit-btn" data-bs-toggle="modal" data-bs-target="#editModal"
                           onclick="fillEditModal(<%= f.getFoodId() %>, '<%= f.getName().replace("'", "\\'") %>', '<%= f.getType() %>', <%= f.getPrice() %>, <%= f.isStatus() %>)">
                            <i class="bi bi-pencil-square"></i> Sửa
                        </a>
                        <a href="foodManagement?action=toggle&id=<%= f.getFoodId() %>" class="action-btn toggle-btn">
                            <i class="bi bi-arrow-repeat"></i> Đổi
                        </a>
                        <a href="foodManagement?action=delete&id=<%= f.getFoodId() %>" class="action-btn delete-btn" onclick="return confirm('Xác nhận xóa món này?')">
                            <i class="bi bi-trash"></i> Xóa
                        </a>
                    </td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="6" class="text-center py-4 text-muted">Không có dữ liệu phù hợp</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- Phân trang -->
    <div class="pagination">
        <%
            int currentPage = (int) request.getAttribute("currentPage");
            int totalPages = (int) request.getAttribute("totalPages");
            String name = (String) request.getAttribute("name");
            String type = (String) request.getAttribute("type");
            String min = (String) request.getAttribute("min");
            String max = (String) request.getAttribute("max");
            String status = (String) request.getAttribute("status");
            String sort = (String) request.getAttribute("sort");

            String query = String.format("name=%s&type=%s&min=%s&max=%s&status=%s&sort=%s",
                    (name != null ? name : ""),
                    (type != null ? type : ""),
                    (min != null ? min : ""),
                    (max != null ? max : ""),
                    (status != null ? status : ""),
                    (sort != null ? sort : ""));

            for (int i = 1; i <= totalPages; i++) {
        %>
        <a href="foodManagement?page=<%= i %>&<%= query %>" class="<%= i == currentPage ? "active" : "" %>"><%= i %></a>
        <% } %>
    </div>

    <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary btn-sm">Quay lại trang chủ</a>

</div>

<!-- MODAL THÊM -->
<div class="modal fade" id="addModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-plus-circle"></i> Thêm món ăn mới</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form method="post" action="foodManagement">
                    <input type="hidden" name="foodId">
                    <div class="mb-3">
                        <label class="form-label">Tên món</label>
                        <input type="text" name="name" class="form-control" placeholder="Nhập tên món..." required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Loại</label>
                        <select name="type" class="form-select" required>
                            <option value="snack">Snack</option>
                            <option value="drink">Drink</option>
                            <option value="popcorn">Popcorn</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Giá (VNĐ)</label>
                        <input type="number" name="price" step="1000" class="form-control" placeholder="0" required>
                    </div>
                    <div class="form-check mb-3">
                        <input type="checkbox" name="status" class="form-check-input" id="addStatus" checked>
                        <label class="form-check-label" for="addStatus">Còn hàng</label>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Lưu món</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- MODAL SỬA -->
<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Chỉnh sửa món ăn</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form method="post" action="foodManagement">
                    <input type="hidden" id="editId" name="foodId">
                    <div class="mb-3">
                        <label class="form-label">Tên món</label>
                        <input type="text" id="editName" name="name" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Loại</label>
                        <select id="editType" name="type" class="form-select" required>
                            <option value="snack">Snack</option>
                            <option value="drink">Drink</option>
                            <option value="popcorn">Popcorn</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Giá (VNĐ)</label>
                        <input type="number" id="editPrice" name="price" step="1000" class="form-control" required>
                    </div>
                    <div class="form-check mb-3">
                        <input type="checkbox" id="editStatus" name="status" class="form-check-input">
                        <label class="form-check-label" for="editStatus">Còn hàng</label>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Cập nhật</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<footer>
    © 2025 Hola Cinema — Admin Dashboard. Được thiết kế với <i class="bi bi-heart-fill text-danger"></i> bởi Team Dev
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function fillEditModal(id, name, type, price, status) {
        document.getElementById("editId").value = id;
        document.getElementById("editName").value = name;
        document.getElementById("editType").value = type;
        document.getElementById("editPrice").value = price;
        document.getElementById("editStatus").checked = status;
    }
</script>
</body>
</html>