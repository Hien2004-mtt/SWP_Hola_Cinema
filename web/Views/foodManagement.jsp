<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Models.Food, java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Food Management - Hola Cinema Admin</title>

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
            <a href="dashboard"><i class="bi bi-speedometer2"></i> Overview</a>
            <a href="revenue"><i class="bi bi-graph-up"></i> Revenue</a>
            <a href="foodManagement" class="active"><i class="bi bi-cup-straw"></i> Food Management</a>
            <a href="../accountList"><i class="bi bi-people"></i> Account List</a>
            <a href="../home"><i class="bi bi-house"></i> User Page</a>
            <a href="../logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
        </div>
    </div>
</header>

<div class="main-container">

    <!-- Page Title + Add Button -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="page-title">
            <i class="bi bi-cup-straw"></i> Food & Beverage Management
        </h1>
        <button class="btn btn-add" data-bs-toggle="modal" data-bs-target="#addModal">
            <i class="bi bi-plus-circle"></i> Add Item
        </button>
    </div>

    <!-- Filters + Sort -->
    <div class="filter-card">
        <div class="filter-row">

            <!-- Search Name -->
            <div class="filter-group">
                <form method="get" action="foodManagement">
                    <label>Name:</label>
                    <input type="text" name="name" placeholder="Search name..." value="${name}" class="form-control">
                    <button type="submit" class="btn btn-primary">Search</button>
                </form>
            </div>

            <!-- Type -->
            <div class="filter-group">
                <form method="get" action="foodManagement">
                    <label>Type:</label>
                    <select name="type" class="form-select">
                        <option value="">-- All --</option>
                        <option value="snack" ${type=="snack"?"selected":""}>Snack</option>
                        <option value="drink" ${type=="drink"?"selected":""}>Drink</option>
                        <option value="popcorn" ${type=="popcorn"?"selected":""}>Popcorn</option>
                    </select>
                    <button type="submit" class="btn btn-primary">Filter</button>
                </form>
            </div>

            <!-- Price Range -->
            <div class="filter-group">
                <form method="get" action="foodManagement">
                    <label>From:</label>
                    <input type="number" name="min" placeholder="VND" step="1000" value="${min}" class="form-control">
                    <label>To:</label>
                    <input type="number" name="max" placeholder="VND" step="1000" value="${max}" class="form-control">
                    <button type="submit" class="btn btn-primary">Filter Price</button>
                </form>
            </div>

            <!-- Status -->
            <div class="filter-group">
                <form method="get" action="foodManagement">
                    <label>Status:</label>
                    <select name="status" class="form-select">
                        <option value="">-- All --</option>
                        <option value="1" ${status=="1"?"selected":""}>In Stock</option>
                        <option value="0" ${status=="0"?"selected":""}>Out of Stock</option>
                    </select>
                    <button type="submit" class="btn btn-primary">Filter</button>
                </form>
            </div>

            <!-- Sort -->
            <div class="filter-group">
                <form method="get" action="foodManagement">
                    <label>Sort:</label>
                    <select name="sort" class="form-select">
                        <option value="">-- Price --</option>
                        <option value="asc" ${sort=="asc"?"selected":""}>Ascending</option>
                        <option value="desc" ${sort=="desc"?"selected":""}>Descending</option>
                    </select>
                    <button type="submit" class="btn btn-primary">Sort</button>
                </form>
            </div>

        </div>
    </div>

    <!-- Data Table -->
    <div class="table-container">
        <table class="table table-hover">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Item Name</th>
                    <th>Type</th>
                    <th>Price (VND)</th>
                    <th>Status</th>
                    <th>Actions</th>
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
                            <%= f.isStatus() ? "In Stock" : "Out of Stock" %>
                        </span>
                    </td>
                    <td>
                        <a href="#" class="action-btn edit-btn" data-bs-toggle="modal" data-bs-target="#editModal"
                           onclick="fillEditModal(<%= f.getFoodId() %>, '<%= f.getName().replace("'", "\\'") %>', '<%= f.getType() %>', <%= f.getPrice() %>, <%= f.isStatus() %>)">
                            <i class="bi bi-pencil-square"></i> Edit
                        </a>
                        <a href="foodManagement?action=toggle&id=<%= f.getFoodId() %>" class="action-btn toggle-btn">
                            <i class="bi bi-arrow-repeat"></i> Toggle
                        </a>
                        <a href="foodManagement?action=delete&id=<%= f.getFoodId() %>" class="action-btn delete-btn" onclick="return confirm('Confirm delete this item?')">
                            <i class="bi bi-trash"></i> Delete
                        </a>
                    </td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="6" class="text-center py-4 text-muted">No matching data found</td>
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

    <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary btn-sm">Back to Home</a>

</div>

<!-- ADD MODAL -->
<div class="modal fade" id="addModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-plus-circle"></i> Add New Item</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form method="post" action="foodManagement">
                    <input type="hidden" name="foodId">
                    <div class="mb-3">
                        <label class="form-label">Item Name</label>
                        <input type="text" name="name" class="form-control" placeholder="Enter item name..." required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Type</label>
                        <select name="type" class="form-select" required>
                            <option value="snack">Snack</option>
                            <option value="drink">Drink</option>
                            <option value="popcorn">Popcorn</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Price (VND)</label>
                        <input type="number" name="price" step="1000" class="form-control" placeholder="0" required>
                    </div>
                    <div class="form-check mb-3">
                        <input type="checkbox" name="status" class="form-check-input" id="addStatus" checked>
                        <label class="form-check-label" for="addStatus">In Stock</label>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Save Item</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- EDIT MODAL -->
<div class="modal fade" id="editModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Item</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form method="post" action="foodManagement">
                    <input type="hidden" id="editId" name="foodId">
                    <div class="mb-3">
                        <label class="form-label">Item Name</label>
                        <input type="text" id="editName" name="name" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Type</label>
                        <select id="editType" name="type" class="form-select" required>
                            <option value="snack">Snack</option>
                            <option value="drink">Drink</option>
                            <option value="popcorn">Popcorn</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Price (VND)</label>
                        <input type="number" id="editPrice" name="price" step="1000" class="form-control" required>
                    </div>
                    <div class="form-check mb-3">
                        <input type="checkbox" id="editStatus" name="status" class="form-check-input">
                        <label class="form-check-label" for="editStatus">In Stock</label>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Update</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<footer>
    © 2025 Hola Cinema — Admin Dashboard. Designed with <i class="bi bi-heart-fill text-danger"></i> by Team Dev
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