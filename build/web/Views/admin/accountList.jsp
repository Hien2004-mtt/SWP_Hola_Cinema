<%-- 
    Document   : accountList
    Created on : Sep 26, 2025, 8:32:13 AM
    Author     : ASUS
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account List - Hola Cinema</title>
    
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

        .nav-links a:hover,
        .nav-links a.active {
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

        /* Content Card */
        .content-card {
            background: var(--card);
            padding: 2rem;
            border-radius: 16px;
            box-shadow: var(--shadow);
            margin-bottom: 2rem;
        }

        .content-card h2 {
            color: var(--primary);
            margin-bottom: 1.5rem;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Search and Filter Section */
        .search-filter-section {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            margin-bottom: 1.5rem;
            align-items: center;
        }

        .search-box {
            flex: 1;
            min-width: 250px;
            display: flex;
            gap: 0.5rem;
        }

        .search-box input {
            flex: 1;
            padding: 0.75rem 1rem;
            border: 1px solid var(--border);
            border-radius: 8px;
            font-size: 0.95rem;
            outline: none;
            transition: all 0.3s ease;
        }

        .search-box input:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(109, 40, 217, 0.1);
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(109, 40, 217, 0.3);
        }

        .btn-secondary {
            background: var(--text-light);
            color: white;
        }

        .btn-secondary:hover {
            background: var(--text);
        }

        .btn-warning {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: white;
        }

        .btn-warning:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(245, 158, 11, 0.3);
        }

        /* Filter Buttons */
        .filter-group {
            display: flex;
            gap: 1rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .filter-group label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            font-weight: 500;
            color: var(--text);
        }

        .filter-group input[type="radio"] {
            accent-color: var(--primary);
            cursor: pointer;
        }

        /* Table */
        .table-wrapper {
            overflow-x: auto;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background: var(--card);
        }

        thead {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
        }

        th {
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        td {
            padding: 1rem;
            border-bottom: 1px solid var(--border);
        }

        tbody tr {
            transition: all 0.2s ease;
        }

        tbody tr:hover {
            background: rgba(109, 40, 217, 0.05);
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        /* Action Buttons */
        .action-buttons {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }

        .btn-sm {
            padding: 0.5rem 1rem;
            font-size: 0.85rem;
            border-radius: 6px;
        }

        .btn-success {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
        }

        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }

        .btn-info {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            color: white;
        }

        .btn-info:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }

        .btn-danger {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
        }

        .btn-danger:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(239, 68, 68, 0.3);
        }

        .btn-disabled {
            background: var(--border);
            color: var(--text-light);
            cursor: not-allowed;
            pointer-events: none;
        }

        /* Role Badge */
        .role-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .role-admin {
            background: linear-gradient(135deg, #ef4444, #dc2626);
            color: white;
        }

        .role-manager {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            color: white;
        }

        .role-customer {
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            color: white;
        }

        /* Status Badge */
        .status-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .status-active {
            background: linear-gradient(135deg, #10b981, #059669);
            color: white;
        }

        .status-locked {
            background: linear-gradient(135deg, #6b7280, #4b5563);
            color: white;
        }

        /* Pagination */
        .pagination {
            display: flex;
            justify-content: center;
            gap: 0.5rem;
            margin-top: 2rem;
            flex-wrap: wrap;
        }

        .page-btn {
            padding: 0.75rem 1rem;
            border: 1px solid var(--border);
            background: var(--card);
            color: var(--text);
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            min-width: 44px;
        }

        .page-btn:hover:not(.active):not(:disabled) {
            background: var(--primary);
            color: white;
            border-color: var(--primary);
            transform: translateY(-2px);
        }

        .page-btn.active {
            background: linear-gradient(135deg, var(--primary), var(--primary-dark));
            color: white;
            border-color: var(--primary);
            cursor: not-allowed;
        }

        .page-btn:disabled {
            background: var(--border);
            color: var(--text-light);
            cursor: not-allowed;
            opacity: 0.6;
        }

        /* Sort Popup */
        .sort-popup {
            position: absolute;
            top: 100%;
            left: 50%;
            transform: translateX(-50%);
            background: var(--card);
            box-shadow: 0 8px 24px rgba(0,0,0,0.15);
            border-radius: 12px;
            padding: 1.5rem;
            z-index: 1001;
            min-width: 280px;
            margin-top: 0.5rem;
        }

        .sort-popup h3 {
            color: var(--primary);
            margin-bottom: 1rem;
            font-size: 1.1rem;
        }

        .sort-popup .form-group {
            margin-bottom: 1rem;
        }

        .sort-popup label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-right: 1rem;
            cursor: pointer;
        }

        /* Modal */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(0,0,0,0.5);
            z-index: 2000;
            align-items: center;
            justify-content: center;
            backdrop-filter: blur(4px);
        }

        .modal-overlay.show {
            display: flex;
        }

        .modal-content {
            background: var(--card);
            padding: 2rem;
            border-radius: 16px;
            min-width: 400px;
            max-width: 500px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            position: relative;
        }

        .modal-content h2 {
            color: var(--primary);
            margin-bottom: 1.5rem;
            font-size: 1.5rem;
        }

        .modal-close {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: transparent;
            border: none;
            font-size: 1.5rem;
            color: var(--text-light);
            cursor: pointer;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: all 0.3s ease;
        }

        .modal-close:hover {
            background: var(--border);
            color: var(--text);
        }

        .modal-form-group {
            margin-bottom: 1.5rem;
        }

        .modal-form-group label {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 0.75rem;
            font-weight: 500;
            cursor: pointer;
        }

        .modal-form-group input[type="radio"] {
            accent-color: var(--primary);
        }

        .modal-actions {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            margin-top: 1.5rem;
        }

        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
            color: var(--text-light);
        }

        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            color: var(--border);
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
            .main-container {
                padding: 1rem;
            }
            
            .search-filter-section {
                flex-direction: column;
                align-items: stretch;
            }
            
            .search-box {
                width: 100%;
            }
        }

        @media (max-width: 576px) {
            .header {
                padding: 1rem;
            }
            
            .nav-links {
                display: flex;
                flex-wrap: wrap;
                gap: 0.5rem;
            }
            
            .nav-links a {
                font-size: 0.85rem;
                padding: 0.4rem 0.75rem;
            }
            
            .content-card {
                padding: 1rem;
            }
            
            table {
                font-size: 0.85rem;
            }
            
            th, td {
                padding: 0.75rem 0.5rem;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .modal-content {
                min-width: 90%;
                padding: 1.5rem;
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
                    <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2"></i> Overview</a>
                    <a href="revenue"><i class="bi bi-graph-up"></i> Revenue</a>
                    <a href="foodManagement" ><i class="bi bi-cup-straw"></i> Manage Food</a>
                    <a href="../accountList" class="active"><i class="bi bi-people"></i> Account List</a>
                    <a href="../home"><i class="bi bi-house"></i> User Page</a>
                    <a href="../logout"><i class="bi bi-box-arrow-right"></i> Logout</a>
            </div>
        </div>
    </header>

    <div class="main-container">
        <!-- Welcome Card -->
        <div class="welcome-card">
            <div class="bi bi-people-fill"></div>
            <div>
                <strong>Account Management</strong>
                <small class="text-muted d-block">Manage user accounts, roles, and status</small>
            </div>
        </div>

        <!-- Content Card -->
        <div class="content-card">
            <h2><i class="bi bi-list-ul"></i> User List</h2>
            
            <!-- Alert Messages -->
            <c:if test="${not empty success}">
                <div class="alert alert-success" style="background: linear-gradient(135deg, #10b981, #059669); color: white; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.5rem;">
                    <i class="bi bi-check-circle-fill"></i> ${success}
                </div>
                <c:remove var="success" scope="session"/>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-error" style="background: linear-gradient(135deg, #ef4444, #dc2626); color: white; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; display: flex; align-items: center; gap: 0.5rem;">
                    <i class="bi bi-exclamation-circle-fill"></i> ${error}
                </div>
                <c:remove var="error" scope="session"/>
            </c:if>
            
            <!-- Search and Filter Section -->
            <form action="accountList" method="get" class="search-filter-section">
                <div class="search-box">
                    <input type="text" name="search" placeholder="Search by email, name or phone..." value="${param.search}">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-search"></i> Search
                    </button>
                    <c:if test="${not empty param.search}">
                        <a href="accountList" class="btn btn-secondary">
                            <i class="bi bi-x-circle"></i> Clear
                        </a>
                    </c:if>
                </div>
                
                <div style="position: relative;">
                    <button type="button" id="sortBtn" class="btn btn-warning">
                        <i class="bi bi-sort-down"></i> Sort
                    </button>
                    <div id="sortPopup" class="sort-popup" style="display:none;">
                        <h3>Sort Options</h3>
                        <div class="form-group">
                            <label><input type="radio" name="sortFieldPopup" value="userId" checked> ID</label>
                            <label><input type="radio" name="sortFieldPopup" value="role"> Role</label>
                        </div>
                        <div class="form-group">
                            <label><input type="radio" name="sortOrderPopup" value="asc" checked> Ascending</label>
                            <label><input type="radio" name="sortOrderPopup" value="desc"> Descending</label>
                        </div>
                        <div class="modal-actions">
                            <button type="button" id="applySortBtn" class="btn btn-primary">Apply</button>
                            <button type="button" id="closeSortBtn" class="btn btn-secondary">Cancel</button>
                        </div>
                    </div>
                </div>
                
                <div class="filter-group">
                    <label>
                        <input type="radio" name="roleFilter" value="all" <c:if test='${roleFilter == null || roleFilter == "all"}'>checked</c:if> onchange="handleRoleFilterChange(this)">
                        Show All
                    </label>
                    <label>
                        <input type="radio" name="roleFilter" value="0" <c:if test='${roleFilter == "0"}'>checked</c:if> onchange="handleRoleFilterChange(this)">
                        Admin
                    </label>
                    <label>
                        <input type="radio" name="roleFilter" value="1" <c:if test='${roleFilter == "1"}'>checked</c:if> onchange="handleRoleFilterChange(this)">
                        Manager
                    </label>
                    <label>
                        <input type="radio" name="roleFilter" value="2" <c:if test='${roleFilter == "2"}'>checked</c:if> onchange="handleRoleFilterChange(this)">
                        Customer
                    </label>
                </div>
            </form>

            <!-- Table -->
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Email</th>
                            <th>Name</th>
                            <th>Phone</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty userList}">
                                <tr>
                                    <td colspan="7" class="empty-state">
                                        <i class="bi bi-inbox"></i>
                                        <p>No accounts available</p>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="user" items="${userList}">
                                    <tr>
                                        <td><strong>#${user.userId}</strong></td>
                                        <td>${user.email}</td>
                                        <td>${user.name}</td>
                                        <td>${user.phone}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${user.role == 0}">
                                                    <span class="role-badge role-admin">Admin</span>
                                                </c:when>
                                                <c:when test="${user.role == 1}">
                                                    <span class="role-badge role-manager">Manager</span>
                                                </c:when>
                                                <c:when test="${user.role == 2}">
                                                    <span class="role-badge role-customer">Customer</span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${user.status}">
                                                    <span class="status-badge status-active">Active</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge status-locked">Locked</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-buttons">
                                                <a href="#" class="btn btn-success btn-sm detail-btn" 
                                                    data-userid="${user.userId}"
                                                    data-email="${user.email}"
                                                    data-name="${user.name}"
                                                    data-phone="${user.phone}"
                                                    data-dob="${user.dob}"
                                                    data-gender="${user.gender}"
                                                    data-role="${user.role}"
                                                    data-createdat="${user.createdAt}"
                                                    data-updatedat="${user.updatedAt}"
                                                    data-status="${user.status}">
                                                    <i class="bi bi-eye"></i> Detail
                                                </a>
                                                <c:choose>
                                                    <c:when test="${user.role == 0}">
                                                        <span class="btn btn-disabled btn-sm">
                                                            <i class="bi bi-pencil"></i> Edit Role
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <a href="#" class="btn btn-warning btn-sm edit-role-btn" 
                                                            data-userid="${user.userId}"
                                                            data-role="${user.role}">
                                                            <i class="bi bi-pencil"></i> Edit Role
                                                        </a>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div class="pagination">
                <c:forEach var="i" begin="1" end="${totalPages}">
                    <button 
                        type="button"
                        class="page-btn <c:if test='${i == currentPage}'>active</c:if>"
                        <c:if test='${totalPages == 1 || i == currentPage}'>disabled</c:if>
                        onclick="window.location.href='accountList?page=${i}<c:if test='${not empty param.search}'>&search=${param.search}</c:if><c:if test='${not empty param.role}'>&role=${param.role}</c:if><c:if test='${not empty param.sortField}'>&sortField=${param.sortField}</c:if><c:if test='${not empty param.sortOrder}'>&sortOrder=${param.sortOrder}</c:if>'"
                    >
                        ${i}
                    </button>
                </c:forEach>
            </div>
        </div>
    </div>

    <footer>
        © 2025 Hola Cinema — Admin Dashboard. Designed with <i class="bi bi-heart-fill text-danger"></i> by the Dev Team.
    </footer>

    <!-- User Detail Modal -->
    <div id="userDetailModal" class="modal-overlay">
        <div class="modal-content">
            <button class="modal-close" onclick="closeModal()">&times;</button>
            <h2><i class="bi bi-person-circle"></i> User Detail</h2>
            <div id="modalContent">
                <!-- Info will be injected here -->
            </div>
            <div class="modal-actions">
                <button onclick="closeModal()" class="btn btn-secondary">Close</button>
            </div>
        </div>
    </div>

    <!-- Edit Role Modal -->
    <div id="editRoleModal" class="modal-overlay">
        <div class="modal-content">
            <button class="modal-close" onclick="closeEditRoleModal()">&times;</button>
            <h2><i class="bi bi-pencil-square"></i> Edit User Role</h2>
            <form id="editRoleForm" method="post" action="${pageContext.request.contextPath}/editRole">
                <input type="hidden" name="userId" id="editRoleUserId" />
                <div class="modal-form-group">
                    <label>
                        <input type="radio" name="role" value="0" id="roleAdmin" disabled>
                        <span style="color: var(--text-light);">Admin (not allowed)</span>
                    </label>
                    <label>
                        <input type="radio" name="role" value="1" id="roleManager">
                        Manager
                    </label>
                    <label>
                        <input type="radio" name="role" value="2" id="roleCustomer">
                        Customer
                    </label>
                </div>
                <div class="modal-actions">
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                    <button type="button" onclick="closeEditRoleModal()" class="btn btn-secondary">Cancel</button>
                </div>
            </form>
        </div>
    </div>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Debug: Check if script is loaded
        console.log('Account List page script loaded');
        
        // Handle Role Filter Change
        function handleRoleFilterChange(radio) {
            const form = document.querySelector('form[action="accountList"]');
            const params = new URLSearchParams();
            
            // Get search value
            const searchInput = form.querySelector('input[name="search"]');
            if (searchInput && searchInput.value) {
                params.set('search', searchInput.value);
            }
            
            // Get sort values
            const sortField = "${sortField != null ? sortField : ''}";
            const sortOrder = "${sortOrder != null ? sortOrder : ''}";
            if (sortField) {
                params.set('sortField', sortField);
            }
            if (sortOrder) {
                params.set('sortOrder', sortOrder);
            }
            
            // Set role parameter (or remove if "all")
            if (radio.value !== 'all') {
                params.set('role', radio.value);
            }
            
            // Redirect with new parameters
            window.location.href = 'accountList' + (params.toString() ? '?' + params.toString() : '');
        }

        // Sort Popup
        document.getElementById('sortBtn').addEventListener('click', function() {
            const popup = document.getElementById('sortPopup');
            popup.style.display = popup.style.display === 'none' ? 'block' : 'none';
            
            // Set current values
            var currentField = "${sortField != null ? sortField : 'userId'}";
            var currentOrder = "${sortOrder != null ? sortOrder : 'asc'}";
            document.querySelectorAll('input[name="sortFieldPopup"]').forEach(function(radio) {
                radio.checked = (radio.value === currentField);
            });
            document.querySelectorAll('input[name="sortOrderPopup"]').forEach(function(radio) {
                radio.checked = (radio.value === currentOrder);
            });
        });

        document.getElementById('closeSortBtn').addEventListener('click', function() {
            document.getElementById('sortPopup').style.display = 'none';
        });

        document.getElementById('applySortBtn').addEventListener('click', function() {
            const form = document.querySelector('form[action="accountList"]');
            const sortField = document.querySelector('input[name="sortFieldPopup"]:checked').value;
            const sortOrder = document.querySelector('input[name="sortOrderPopup"]:checked').value;
            const params = new URLSearchParams(new FormData(form));
            params.set('sortField', sortField);
            params.set('sortOrder', sortOrder);
            window.location.href = form.action + '?' + params.toString();
        });

        // Close popup when clicking outside
        document.addEventListener('click', function(event) {
            const sortBtn = document.getElementById('sortBtn');
            const sortPopup = document.getElementById('sortPopup');
            if (!sortBtn.contains(event.target) && !sortPopup.contains(event.target)) {
                sortPopup.style.display = 'none';
            }
        });

        // User Detail Modal
        function closeModal() {
            document.getElementById('userDetailModal').classList.remove('show');
        }

        document.querySelectorAll('.detail-btn').forEach(function(btn) {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                var html = '<div style="line-height: 2;">';
                html += '<p><strong>ID:</strong> ' + btn.dataset.userid + '</p>';
                html += '<p><strong>Email:</strong> ' + btn.dataset.email + '</p>';
                html += '<p><strong>Name:</strong> ' + btn.dataset.name + '</p>';
                html += '<p><strong>Phone:</strong> ' + btn.dataset.phone + '</p>';
                html += '<p><strong>Date of Birth:</strong> ' + (btn.dataset.dob || '-') + '</p>';
                html += '<p><strong>Gender:</strong> ' + (btn.dataset.gender == 'true' ? 'Male' : 'Female') + '</p>';
                html += '<p><strong>Role:</strong> ' + (btn.dataset.role == '0' ? '<span class="role-badge role-admin">Admin</span>' : (btn.dataset.role == '1' ? '<span class="role-badge role-manager">Manager</span>' : '<span class="role-badge role-customer">Customer</span>')) + '</p>';
                html += '<p><strong>Status:</strong> ' + (btn.dataset.status === 'true' ? '<span class="status-badge status-active">Active</span>' : '<span class="status-badge status-locked">Locked</span>') + '</p>';
                html += '<p><strong>Created At:</strong> ' + (btn.dataset.createdat || '-') + '</p>';
                html += '<p><strong>Updated At:</strong> ' + (btn.dataset.updatedat || '-') + '</p>';
                html += '</div>';
                document.getElementById('modalContent').innerHTML = html;
                document.getElementById('userDetailModal').classList.add('show');
            });
        });

        // Edit Role Modal
        function closeEditRoleModal() {
            document.getElementById('editRoleModal').classList.remove('show');
        }

        document.querySelectorAll('.edit-role-btn').forEach(function(btn) {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                document.getElementById('editRoleUserId').value = btn.dataset.userid;
                var role = btn.dataset.role;
                document.querySelectorAll('#editRoleForm input[name="role"]').forEach(function(radio) {
                    radio.checked = (radio.value === role);
                });
                document.getElementById('editRoleModal').classList.add('show');
            });
        });

        // Wait for DOM to be fully loaded
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM loaded');
        });

        // Close modals when clicking outside
        document.querySelectorAll('.modal-overlay').forEach(function(modal) {
            modal.addEventListener('click', function(e) {
                if (e.target === modal) {
                    modal.classList.remove('show');
                }
            });
        });

        // Auto-hide alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                setTimeout(function() {
                    alert.style.transition = 'opacity 0.5s ease';
                    alert.style.opacity = '0';
                    setTimeout(function() {
                        alert.remove();
                    }, 500);
                }, 5000);
            });
        });
    </script>
</body>
</html>
