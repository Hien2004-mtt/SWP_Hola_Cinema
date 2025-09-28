<%-- 
    Document   : accountList
    Created on : Sep 26, 2025, 8:32:13 AM
    Author     : ASUS
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Account List</title>
    <link rel="stylesheet" href="css/admin.css">
    <style>
        .container {
            display: flex;
            min-height: 100vh;
        }
        .sidebar {
            width: 220px;
            background: linear-gradient(180deg, #2c3e50 70%, #2980b9 100%);
            color: #fff;
            padding: 32px 0 0 0;
            box-shadow: 2px 0 8px rgba(44,62,80,0.08);
            display: flex;
            flex-direction: column;
            align-items: center;
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            z-index: 10;
        }
        .sidebar h2 {
            margin-bottom: 32px;
            font-size: 1.3rem;
            letter-spacing: 1px;
        }
        .sidebar nav {
            display: flex;
            flex-direction: column;
            gap: 18px;
            width: 100%;
        }
        .sidebar nav a {
            color: #fff;
            text-decoration: none;
            padding: 12px 32px;
            font-weight: 500;
            font-size: 1.05rem;
            border-radius: 8px 0 0 8px;
            transition: background 0.2s, color 0.2s;
        }
        .sidebar nav a.active {
            background: #fff;
            color: #2980b9;
            font-weight: bold;
            cursor: default;
            pointer-events: none;
        }
        .sidebar nav a:hover:not(.active) {
            background: #ffd700;
            color: #2c3e50;
        }
        .main-content {
            flex: 1;
            margin-left: 220px;
        }
        header {
            background: #2980b9;
            color: #fff;
            padding: 18px 0 10px 0;
            box-shadow: 0 2px 8px rgba(44,62,80,0.08);
            text-align: center;
        }
        header h1 {
            margin: 0 0 8px 0;
            font-size: 2.2rem;
            letter-spacing: 1px;
        }
        /* ...existing code... */
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f6f8fa;
            margin: 0;
        }
        header {
            background: linear-gradient(90deg, #2c3e50 60%, #2980b9 100%);
            color: #fff;
            padding: 24px 0 12px 0;
            box-shadow: 0 2px 8px rgba(44,62,80,0.08);
            text-align: center;
        }
        header h1 {
            margin: 0 0 8px 0;
            font-size: 2.2rem;
            letter-spacing: 1px;
        }
        nav a {
            color: #fff;
            text-decoration: none;
            margin: 0 12px;
            font-weight: 500;
            transition: color 0.2s;
        }
        nav a:hover {
            color: #ffd700;
        }
        main {
            max-width: 900px;
            margin: 32px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 16px rgba(44,62,80,0.08);
            padding: 32px 24px;
        }
        h2 {
            color: #2980b9;
            margin-bottom: 24px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: #fafbfc;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 1px 6px rgba(44,62,80,0.06);
        }
        th, td {
            padding: 12px 10px;
            text-align: left;
        }
        th {
            background: #2980b9;
            color: #fff;
            font-weight: 600;
        }
        tr {
            transition: background 0.2s;
        }
        tr:hover {
            background: #eaf6fb;
        }
        td:last-child a {
            background: #27ae60;
            color: #fff;
            padding: 6px 14px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.95rem;
            transition: background 0.2s;
        }
        td:last-child a:hover {
            background: #219150;
        }
        form {
            margin: 24px 0 0 0;
            display: flex;
            gap: 8px;
            justify-content: flex-end;
        }
        input[type="text"] {
            padding: 8px 12px;
            border: 1px solid #b2bec3;
            border-radius: 6px;
            font-size: 1rem;
            outline: none;
            transition: border 0.2s;
        }
        input[type="text"]:focus {
            border: 1.5px solid #2980b9;
        }
        button[type="submit"] {
            background: linear-gradient(90deg, #2980b9 60%, #27ae60 100%);
            color: #fff;
            border: none;
            border-radius: 6px;
            padding: 8px 18px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            box-shadow: 0 1px 4px rgba(44,62,80,0.08);
            transition: background 0.2s;
        }
        button[type="submit"]:hover {
            background: linear-gradient(90deg, #27ae60 60%, #2980b9 100%);
        }
        @media (max-width: 600px) {
            main { padding: 12px 4px; }
            table th, table td { padding: 8px 4px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <h2>Menu</h2>
            <nav>
                <a href="/Views/admin/accountList.jsp" class="active">Account List</a>
                <a href="rolesManagement.jsp">Roles Management</a>
                <a href="showtimesManagement.jsp">Showtimes Management</a>
                <a href="revenueManagement.jsp">Revenue Management</a>
            </nav>
        </div>
        <div class="main-content">
            <header>
                <h1>System Administration - Account List</h1>
            </header>
            <main>
                <h2>User List</h2>
                <form action="accountList" method="get" style="margin-bottom: 18px; display: flex; gap: 8px; justify-content: flex-start;">
                    <input type="text" name="search" placeholder="Search by email or name">
                    <button type="submit">Search</button>
                    <button type="button" onclick="showAllUsers()" style="background: #b2bec3; color: #2c3e50; border: none; border-radius: 6px; padding: 8px 18px; font-size: 1rem; font-weight: 500; cursor: pointer;">Show All</button>
                </form>
                <script>
                function showAllUsers() {
                    document.querySelector('input[name=search]').value = '';
                    document.querySelector('form[action=accountList]').submit();
                }
                </script>
                </form>
                <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Email</th>
                    <th>Name</th>
                    <th>Phone</th>
                    <th>Date of Birth</th>
                    <!-- Gender column removed -->
                    <th>Role</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="user" items="${userList}">
                    <tr>
                        <td>${user.userId}</td>
                        <td>${user.email}</td>
                        <td>${user.name}</td>
                        <td>${user.phone}</td>
                        <td>${user.dob}</td>
                        <!-- Gender column removed -->
                        <td>
                            <c:choose>
                                <c:when test="${user.role == 0}">Admin</c:when>
                                <c:when test="${user.role == 1}">Manager</c:when>
                                <c:when test="${user.role == 2}">Customer</c:when>
                            </c:choose>
                        </td>
                        <td>
                            <a href="#" class="detail-btn" 
                               data-userid="${user.userId}"
                               data-email="${user.email}"
                               data-name="${user.name}"
                               data-phone="${user.phone}"
                               data-dob="${user.dob}"
                               data-gender="${user.gender}"
                               data-role="${user.role}">Detail</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
                </table>
            <!-- Modal for user detail -->
            <div id="userDetailModal" style="display:none;position:fixed;top:0;left:0;width:100vw;height:100vh;background:rgba(44,62,80,0.25);z-index:999;align-items:center;justify-content:center;">
                <div style="background:#fff;padding:32px 24px;border-radius:12px;min-width:320px;max-width:400px;box-shadow:0 2px 16px rgba(44,62,80,0.18);position:relative;">
                    <h2 style="color:#2980b9;margin-top:0;">User Detail</h2>
                    <div id="modalContent">
                        <!-- Info will be injected here -->
                    </div>
                    <button onclick="closeModal()" id="closeModalBtn" style="position:absolute;top:12px;right:12px;background:transparent;color:#2980b9;border:none;font-size:1.5rem;font-weight:bold;cursor:pointer;">&times;</button>
                    <div style="display:flex;justify-content:flex-end;gap:12px;margin-top:24px;">
                        <button onclick="showDeleteConfirm()" id="deleteBtn" style="background:#e74c3c;color:#fff;border:none;padding:8px 18px;border-radius:6px;cursor:pointer;">Delete</button>
                        <button onclick="closeModal()" style="background:#2980b9;color:#fff;border:none;padding:8px 18px;border-radius:6px;cursor:pointer;">Close</button>
                    </div>
                    <!-- Modal xác nhận xóa -->
                    <div id="deleteConfirmModal" style="display:none;position:fixed;top:0;left:0;width:100vw;height:100vh;background:rgba(44,62,80,0.25);z-index:1000;align-items:center;justify-content:center;">
                        <div style="background:#fff;padding:28px 22px;border-radius:12px;min-width:280px;max-width:340px;box-shadow:0 2px 16px rgba(44,62,80,0.18);position:relative;">
                            <h3 style="color:#e74c3c;margin-top:0;">Confirm Delete</h3>
                            <p>Are you sure you want to delete this user?</p>
                            <div style="display:flex;justify-content:flex-end;gap:12px;margin-top:18px;">
                                <button onclick="confirmDeleteUser()" style="background:#e74c3c;color:#fff;border:none;padding:8px 18px;border-radius:6px;cursor:pointer;">Delete</button>
                                <button onclick="closeDeleteModal()" style="background:#2980b9;color:#fff;border:none;padding:8px 18px;border-radius:6px;cursor:pointer;">Cancel</button>
                            </div>
                        </div>
                    </div>
                    <form id="deleteUserForm" method="post" action="deleteUser" style="display:none;">
                        <input type="hidden" name="user_id" id="deleteUserId" />
                    </form>
                    <script>
                        let currentDeleteUserId = null;
                        function showDeleteConfirm() {
                            document.getElementById('deleteConfirmModal').style.display = 'flex';
                        }
                        function closeDeleteModal() {
                            document.getElementById('deleteConfirmModal').style.display = 'none';
                        }
                        function confirmDeleteUser() {
                            document.getElementById('deleteConfirmModal').style.display = 'none';
                            document.getElementById('userDetailModal').style.display = 'none';
                            document.getElementById('deleteUserForm').submit();
                        }
                        // Gán userId cho form xóa khi mở modal chi tiết
                        document.querySelectorAll('.detail-btn').forEach(function(btn) {
                            btn.addEventListener('click', function(e) {
                                // ...existing code...
                                document.getElementById('deleteUserId').value = btn.dataset.userid;
                                currentDeleteUserId = btn.dataset.userid;
                            });
                        });
                    </script>
                </div>
            </div>
            <script>
                function closeModal() {
                    document.getElementById('userDetailModal').style.display = 'none';
                }
                document.querySelectorAll('.detail-btn').forEach(function(btn) {
                    btn.addEventListener('click', function(e) {
                        e.preventDefault();
                        var html = '';
                        html += '<p><strong>ID:</strong> ' + btn.dataset.userid + '</p>';
                        html += '<p><strong>Email:</strong> ' + btn.dataset.email + '</p>';
                        html += '<p><strong>Name:</strong> ' + btn.dataset.name + '</p>';
                        html += '<p><strong>Phone:</strong> ' + btn.dataset.phone + '</p>';
                        html += '<p><strong>Date of Birth:</strong> ' + btn.dataset.dob + '</p>';
                        html += '<p><strong>Gender:</strong> ' + (btn.dataset.gender == 'true' ? 'Male' : 'Female') + '</p>';
                        html += '<p><strong>Role:</strong> ' + (btn.dataset.role == '0' ? 'Admin' : (btn.dataset.role == '1' ? 'Manager' : 'Customer')) + '</p>';
                        document.getElementById('modalContent').innerHTML = html;
                        document.getElementById('userDetailModal').style.display = 'flex';
                    });
                });
            </script>
            </main>
            <footer>
                <p>&copy; 2025 Cinema Booking System</p>
            </footer>
        </div>
    </div>
</body>
</html>
