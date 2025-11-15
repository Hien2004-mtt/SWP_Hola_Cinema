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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/accountList.css">

</head>
<body>
    <!-- Header - Match Dashboard -->
    <header class="header">
        <div class="container-fluid d-flex justify-content-between align-items-center">
            <div class="logo">
                <span class="bi bi-film"></span> Hola Cinema
            </div>
            <div class="nav-links">
                <a href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2"></i> Tổng quan</a>
                <a href="${pageContext.request.contextPath}/admin/revenue"><i class="bi bi-graph-up"></i> Doanh thu</a>
                <a href="${pageContext.request.contextPath}/admin/foodManagement"><i class="bi bi-cup-straw"></i> Quản lý Food</a>
                <a href="${pageContext.request.contextPath}/admin/accountList" class="active"><i class="bi bi-people"></i> Quản lý tài khoản</a>
                <a href="${pageContext.request.contextPath}/home"><i class="bi bi-house"></i> Trang người dùng</a>
                <a href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a>
            </div>
        </div>
    </header>

    <div class="main-container">
        <!-- Welcome Card - Match Dashboard -->
        <div class="welcome-card">
            <div class="bi bi-person-circle"></div>
            <div>
                <strong>Account Management</strong>
                <small class="text-muted d-block">Manage user accounts, roles, and status</small>
            </div>
        </div>
        <!-- Content Card -->
        <div class="content-card">
            <h2><i class="bi bi-people"></i> User List</h2>
            
            <form action="accountList" method="get" class="search-form">
                <input type="text" name="search" placeholder="Search by email, name or phone" value="${param.search}">
                <button type="submit" class="btn-primary-custom">
                    <i class="bi bi-search"></i> Search
                </button>
                <c:if test="${not empty param.search}">
                    <button type="button" onclick="window.location.href='accountList'" class="btn-secondary-custom">
                        <i class="bi bi-x-circle"></i> Clear
                    </button>
                </c:if>
                <button type="button" id="sortBtn" class="btn-warning-custom">
                    <i class="bi bi-sort-down"></i> Sort
                </button>
                <div class="filter-section">
                    <label>
                        <input type="radio" name="roleFilter" value="all" <c:if test='${roleFilter == null || roleFilter == "all"}'>checked</c:if>> Show All
                    </label>
                    <label>
                        <input type="radio" name="roleFilter" value="0" <c:if test='${roleFilter == "0"}'>checked</c:if>> Admin
                    </label>
                    <label>
                        <input type="radio" name="roleFilter" value="1" <c:if test='${roleFilter == "1"}'>checked</c:if>> Manager
                    </label>
                    <label>
                        <input type="radio" name="roleFilter" value="2" <c:if test='${roleFilter == "2"}'>checked</c:if>> Customer
                    </label>
                </div>
            </form>
            
            <!-- Sort popup -->
            <div id="sortPopup" style="display:none; position:fixed; top:50%; left:50%; transform:translate(-50%, -50%); z-index:1001;">
                <div class="modal-content-custom" style="padding: 2rem;">
                    <h3><i class="bi bi-sort-alpha-down"></i> Sort Options</h3>
                    <div style="margin-bottom: 1rem;">
                        <label style="margin-right: 1rem; display: inline-flex; align-items: center; gap: 0.5rem;">
                            <input type="radio" name="sortFieldPopup" value="userId" checked> ID
                        </label>
                        <label style="display: inline-flex; align-items: center; gap: 0.5rem;">
                            <input type="radio" name="sortFieldPopup" value="role"> Role
                        </label>
                    </div>
                    <div style="margin-bottom: 1.5rem;">
                        <label style="margin-right: 1rem; display: inline-flex; align-items: center; gap: 0.5rem;">
                            <input type="radio" name="sortOrderPopup" value="asc" checked> Ascending
                        </label>
                        <label style="display: inline-flex; align-items: center; gap: 0.5rem;">
                            <input type="radio" name="sortOrderPopup" value="desc"> Descending
                        </label>
                    </div>
                    <div style="display:flex; gap:0.75rem; justify-content:flex-end;">
                        <button type="button" id="applySortBtn" class="btn-primary-custom">Apply</button>
                        <button type="button" id="closeSortBtn" class="btn-secondary-custom">Cancel</button>
                    </div>
                </div>
            </div>
            
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Email</th>
                            <th>Name</th>
                            <th>Phone</th>
                            <th>Role</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty userList}">
                                <tr>
                                    <td colspan="6" style="text-align:center; color:#ef4444; font-weight:bold; padding: 2rem;">
                                        <i class="bi bi-exclamation-circle"></i> No accounts available
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="user" items="${userList}">
                                    <tr>
                                        <td>${user.userId}</td>
                                        <td>${user.email}</td>
                                        <td>${user.name}</td>
                                        <td>${user.phone}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${user.role == 0}">
                                                    <span style="background: linear-gradient(135deg, #ef4444, #dc2626); color: white; padding: 0.25rem 0.75rem; border-radius: 12px; font-size: 0.85rem; font-weight: 500;">Admin</span>
                                                </c:when>
                                                <c:when test="${user.role == 1}">
                                                    <span style="background: linear-gradient(135deg, #f59e0b, #d97706); color: white; padding: 0.25rem 0.75rem; border-radius: 12px; font-size: 0.85rem; font-weight: 500;">Manager</span>
                                                </c:when>
                                                <c:when test="${user.role == 2}">
                                                    <span style="background: linear-gradient(135deg, #3b82f6, #2563eb); color: white; padding: 0.25rem 0.75rem; border-radius: 12px; font-size: 0.85rem; font-weight: 500;">Customer</span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <a href="#" class="action-btn btn-detail detail-btn" 
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
                                                <i class="bi bi-info-circle"></i> Detail
                                            </a>
                                            <c:choose>
                                                <c:when test="${user.role == 0}">
                                                    <a href="#" class="action-btn btn-disabled">
                                                        <i class="bi bi-shield-lock"></i> Edit Role
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="#" class="action-btn btn-edit-role edit-role-btn" 
                                                        data-userid="${user.userId}"
                                                        data-role="${user.role}">
                                                        <i class="bi bi-pencil-square"></i> Edit Role
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                            <a href="#" class="action-btn btn-edit-status edit-status-btn"
                                                data-userid="${user.userId}"
                                                data-status="${user.status}">
                                                <i class="bi bi-toggle-on"></i> Status: <c:choose><c:when test="${user.status}">Active</c:when><c:otherwise>Locked</c:otherwise></c:choose>
                                            </a>
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
                        onclick="window.location.href='accountList?page=${i}'"
                    >
                        ${i}
                    </button>
                </c:forEach>
            </div>
        </div>
        
        <!-- Modal chỉnh sửa role -->
        <div id="editRoleModal" style="display:none;position:fixed;top:0;left:0;width:100vw;height:100vh;z-index:1001;align-items:center;justify-content:center;" class="modal-overlay">
            <div class="modal-content-custom" style="padding: 2rem; min-width: 320px; max-width: 400px;">
                <div class="modal-header-custom" style="margin-bottom: 1.5rem; text-align: center;">
                    <h2><i class="bi bi-pencil-square"></i> Edit User Role</h2>
                </div>
                <form id="editRoleForm" method="post" action="editRole" style="width:100%;">
                    <input type="hidden" name="userId" id="editRoleUserId" />
                    <div style="margin-bottom: 1.5rem;">
                        <div style="margin-bottom: 1rem; display: flex; align-items: center; gap: 0.75rem; padding: 0.75rem; background: var(--bg); border-radius: 8px;">
                            <input type="radio" name="role" value="0" id="roleAdmin" style="accent-color: var(--text-light);" disabled>
                            <label for="roleAdmin" style="font-size: 1rem; color: var(--text-light);">Admin (not allowed)</label>
                        </div>
                        <div style="margin-bottom: 1rem; display: flex; align-items: center; gap: 0.75rem; padding: 0.75rem; background: var(--bg); border-radius: 8px;">
                            <input type="radio" name="role" value="1" id="roleManager" style="accent-color: var(--primary);">
                            <label for="roleManager" style="font-size: 1rem;">Manager</label>
                        </div>
                        <div style="display: flex; align-items: center; gap: 0.75rem; padding: 0.75rem; background: var(--bg); border-radius: 8px;">
                            <input type="radio" name="role" value="2" id="roleCustomer" style="accent-color: var(--primary);">
                            <label for="roleCustomer" style="font-size: 1rem;">Customer</label>
                        </div>
                    </div>
                    <div style="display:flex; gap:0.75rem; justify-content:center;">
                        <button type="submit" class="btn-primary-custom">Save</button>
                        <button type="button" id="closeEditRoleBtn" class="btn-secondary-custom">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
        
        <!-- Modal for user detail -->
        <div id="userDetailModal" style="display:none;position:fixed;top:0;left:0;width:100vw;height:100vh;z-index:999;align-items:center;justify-content:center;" class="modal-overlay">
            <div class="modal-content-custom" style="padding: 2rem; min-width: 320px; max-width: 450px; position: relative;">
                <button onclick="closeModal()" id="closeModalBtn" style="position:absolute;top:1rem;right:1rem;background:transparent;color:var(--text-light);border:none;font-size:1.5rem;font-weight:bold;cursor:pointer;width:32px;height:32px;display:flex;align-items:center;justify-content:center;border-radius:50%;transition:all 0.3s ease;">
                    <i class="bi bi-x-lg"></i>
                </button>
                <div class="modal-header-custom" style="margin-bottom: 1.5rem;">
                    <h2><i class="bi bi-person-circle"></i> User Detail</h2>
                </div>
                <div id="modalContent" style="line-height: 2;">
                    <!-- Info will be injected here -->
                </div>
                <div style="display:flex;justify-content:flex-end;gap:0.75rem;margin-top:1.5rem;">
                    <button onclick="closeModal()" class="btn-primary-custom">Close</button>
                </div>
            </div>
        </div>
        
        <!-- Modal chỉnh sửa trạng thái -->
        <div id="editStatusModal" style="display:none;position:fixed;top:0;left:0;width:100vw;height:100vh;z-index:1002;align-items:center;justify-content:center;" class="modal-overlay">
            <div class="modal-content-custom" style="padding: 2rem; min-width: 320px; max-width: 400px;">
                <div class="modal-header-custom" style="margin-bottom: 1.5rem; text-align: center;">
                    <h2><i class="bi bi-toggle-on"></i> Update Account Status</h2>
                </div>
                <form id="editStatusForm" method="post" action="editStatus" style="width:100%;">
                    <input type="hidden" name="userId" id="editStatusUserId" />
                    <div style="margin-bottom: 1.5rem;">
                        <div style="margin-bottom: 1rem; display: flex; align-items: center; gap: 0.75rem; padding: 0.75rem; background: var(--bg); border-radius: 8px;">
                            <input type="radio" name="status" value="true" id="statusActive" style="accent-color: var(--primary);">
                            <label for="statusActive" style="font-size: 1rem;">
                                <i class="bi bi-check-circle" style="color: #10b981;"></i> Active
                            </label>
                        </div>
                        <div style="display: flex; align-items: center; gap: 0.75rem; padding: 0.75rem; background: var(--bg); border-radius: 8px;">
                            <input type="radio" name="status" value="false" id="statusLocked" style="accent-color: var(--primary);">
                            <label for="statusLocked" style="font-size: 1rem;">
                                <i class="bi bi-lock" style="color: #ef4444;"></i> Locked
                            </label>
                        </div>
                    </div>
                    <div style="display:flex; gap:0.75rem; justify-content:center;">
                        <button type="submit" class="btn-primary-custom">Save</button>
                        <button type="button" id="closeEditStatusBtn" class="btn-secondary-custom">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <footer>
        © 2025 Hola Cinema — Admin Dashboard. Designed with <i class="bi bi-heart-fill text-danger"></i> by the Dev Team.
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Xử lý radio lọc role
        document.querySelectorAll('input[name="roleFilter"]').forEach(function(radio) {
            radio.addEventListener('change', function() {
                const form = document.querySelector('form[action=accountList]');
                const params = new URLSearchParams(new FormData(form));
                if (radio.value === 'all') {
                    params.delete('role');
                } else {
                    params.set('role', radio.value);
                }
                window.location.href = form.action + '?' + params.toString();
            });
        });
        
        // Hiện popup sort và giữ nguyên lựa chọn hiện tại
        document.getElementById('sortBtn').addEventListener('click', function() {
            var currentField = "${sortField != null ? sortField : 'userId'}";
            var currentOrder = "${sortOrder != null ? sortOrder : 'asc'}";
            document.querySelectorAll('input[name="sortFieldPopup"]').forEach(function(radio) {
                radio.checked = (radio.value === currentField);
            });
            document.querySelectorAll('input[name="sortOrderPopup"]').forEach(function(radio) {
                radio.checked = (radio.value === currentOrder);
            });
            document.getElementById('sortPopup').style.display = 'block';
        });
        
        // Đóng popup sort
        document.getElementById('closeSortBtn').addEventListener('click', function() {
            document.getElementById('sortPopup').style.display = 'none';
        });
        
        // Áp dụng sort
        document.getElementById('applySortBtn').addEventListener('click', function() {
            const form = document.querySelector('form[action=accountList]');
            const sortField = document.querySelector('input[name="sortFieldPopup"]:checked').value;
            const sortOrder = document.querySelector('input[name="sortOrderPopup"]:checked').value;
            const params = new URLSearchParams(new FormData(form));
            params.set('sortField', sortField);
            params.set('sortOrder', sortOrder);
            window.location.href = form.action + '?' + params.toString();
            document.getElementById('sortPopup').style.display = 'none';
        });
        
        // Xử lý nút Edit Role
        document.querySelectorAll('.edit-role-btn').forEach(function(btn) {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                document.getElementById('editRoleUserId').value = btn.dataset.userid;
                var role = btn.dataset.role;
                document.querySelectorAll('#editRoleForm input[name="role"]').forEach(function(radio) {
                    radio.checked = (radio.value === role);
                });
                document.getElementById('editRoleModal').style.display = 'flex';
            });
        });
        
        // Đóng modal Edit Role
        document.getElementById('closeEditRoleBtn').addEventListener('click', function() {
            document.getElementById('editRoleModal').style.display = 'none';
        });
        
        // Xử lý nút Edit Status
        document.querySelectorAll('.edit-status-btn').forEach(function(btn) {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                document.getElementById('editStatusUserId').value = btn.dataset.userid;
                var status = btn.dataset.status === 'true';
                document.getElementById('statusActive').checked = status;
                document.getElementById('statusLocked').checked = !status;
                document.getElementById('editStatusModal').style.display = 'flex';
            });
        });
        
        // Đóng modal Edit Status
        document.getElementById('closeEditStatusBtn').addEventListener('click', function() {
            document.getElementById('editStatusModal').style.display = 'none';
        });
        
        // Xử lý modal chi tiết user
        function closeModal() {
            document.getElementById('userDetailModal').style.display = 'none';
        }
        
        document.querySelectorAll('.detail-btn').forEach(function(btn) {
            btn.addEventListener('click', function(e) {
                e.preventDefault();
                var html = '';
                html += '<div style="display: grid; gap: 0.75rem;">';
                html += '<div style="padding: 0.75rem; background: var(--bg); border-radius: 8px;"><strong><i class="bi bi-hash"></i> ID:</strong> ' + btn.dataset.userid + '</div>';
                html += '<div style="padding: 0.75rem; background: var(--bg); border-radius: 8px;"><strong><i class="bi bi-envelope"></i> Email:</strong> ' + btn.dataset.email + '</div>';
                html += '<div style="padding: 0.75rem; background: var(--bg); border-radius: 8px;"><strong><i class="bi bi-person"></i> Name:</strong> ' + btn.dataset.name + '</div>';
                html += '<div style="padding: 0.75rem; background: var(--bg); border-radius: 8px;"><strong><i class="bi bi-telephone"></i> Phone:</strong> ' + btn.dataset.phone + '</div>';
                html += '<div style="padding: 0.75rem; background: var(--bg); border-radius: 8px;"><strong><i class="bi bi-calendar"></i> Date of Birth:</strong> ' + (btn.dataset.dob || '-') + '</div>';
                html += '<div style="padding: 0.75rem; background: var(--bg); border-radius: 8px;"><strong><i class="bi bi-gender-ambiguous"></i> Gender:</strong> ' + (btn.dataset.gender == 'true' ? 'Male' : 'Female') + '</div>';
                var roleText = btn.dataset.role == '0' ? 'Admin' : (btn.dataset.role == '1' ? 'Manager' : 'Customer');
                html += '<div style="padding: 0.75rem; background: var(--bg); border-radius: 8px;"><strong><i class="bi bi-shield-check"></i> Role:</strong> ' + roleText + '</div>';
                html += '<div style="padding: 0.75rem; background: var(--bg); border-radius: 8px;"><strong><i class="bi bi-clock"></i> Created At:</strong> ' + (btn.dataset.createdat || '-') + '</div>';
                html += '<div style="padding: 0.75rem; background: var(--bg); border-radius: 8px;"><strong><i class="bi bi-clock-history"></i> Updated At:</strong> ' + (btn.dataset.updatedat || '-') + '</div>';
                var statusText = btn.dataset.status === 'true' ? '<span style="color: #10b981;">Active</span>' : '<span style="color: #ef4444;">Locked</span>';
                html += '<div style="padding: 0.75rem; background: var(--bg); border-radius: 8px;"><strong><i class="bi bi-toggle-on"></i> Status:</strong> ' + statusText + '</div>';
                html += '</div>';
                document.getElementById('modalContent').innerHTML = html;
                document.getElementById('userDetailModal').style.display = 'flex';
            });
        });
        
        // Đóng modal khi click bên ngoài
        window.addEventListener('click', function(event) {
            var editRoleModal = document.getElementById('editRoleModal');
            var editStatusModal = document.getElementById('editStatusModal');
            var userDetailModal = document.getElementById('userDetailModal');
            var sortPopup = document.getElementById('sortPopup');
            
            if (event.target == editRoleModal) {
                editRoleModal.style.display = 'none';
            }
            if (event.target == editStatusModal) {
                editStatusModal.style.display = 'none';
            }
            if (event.target == userDetailModal) {
                userDetailModal.style.display = 'none';
            }
            if (event.target == sortPopup) {
                sortPopup.style.display = 'none';
            }
        });
    </script>
</body>
</html>
