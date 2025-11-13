<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Tin Tức & Khuyến Mãi - Hola Cinema</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/newsAndPromotion.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body class="news-page">
    <%@include file="../manager/sidebar.jsp" %>
    <jsp:include page="/Inculude/Header.jsp" />

    
    <div class="news-wrapper">
        <div class="main-content fade-in">
            <h1><i class="fas fa-newspaper"></i> Quản Lý Tin Tức & Khuyến Mãi</h1>
            
            <!-- Alert Messages -->
            <c:if test="${not empty success}">
                <div class="alert alert-success" id="success-alert">
                    <i class="fas fa-check-circle"></i> ${success}
                </div>
                <script>
                    if (window.location.search.indexOf('success') === -1) {
                        if (typeof window.history.replaceState === 'function') {
                            window.history.replaceState({}, document.title, window.location.pathname);
                        }
                    }
                </script>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-error" id="error-alert">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                </div>
                <script>
                    if (window.location.search.indexOf('error') === -1) {
                        if (typeof window.history.replaceState === 'function') {
                            window.history.replaceState({}, document.title, window.location.pathname);
                        }
                    }
                </script>
            </c:if>
            
            <!-- Add New News/Promotion Form -->
            <div class="form-section card-surface">
                <h2><i class="fas fa-plus-circle"></i> Thêm Mới</h2>
                <form action="manageNewsAndPromotion" method="post" id="addForm">
                    <input type="hidden" name="action" value="add"/>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="type"><i class="fas fa-tag"></i> Loại:</label>
                            <select name="type" id="type" required>
                                <option value="">-- Chọn loại --</option>
                                <option value="news">Tin Tức</option>
                                <option value="promotion">Khuyến Mãi</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="title"><i class="fas fa-heading"></i> Tiêu đề: <span style="color:red;">*</span></label>
                            <input type="text" name="title" id="title" required placeholder="Nhập tiêu đề...">
                        </div>
                        <div class="form-group" style="grid-column: 1 / -1;">
                            <label for="content"><i class="fas fa-align-left"></i> Nội dung: <span style="color:red;">*</span></label>
                            <textarea name="content" id="content" required placeholder="Nhập nội dung..."></textarea>
                        </div>
                        <div class="form-group">
                            <label for="imageUrl"><i class="fas fa-image"></i> URL Hình ảnh:</label>
                            <input type="url" name="imageUrl" id="imageUrl" placeholder="https://example.com/image.jpg">
                        </div>
                        <div class="form-group">
                            <label for="startDate"><i class="fas fa-calendar-check"></i> Ngày bắt đầu:</label>
                            <input type="datetime-local" name="startDate" id="startDate">
                        </div>
                        <div class="form-group">
                            <label for="endDate"><i class="fas fa-calendar-times"></i> Ngày kết thúc:</label>
                            <input type="datetime-local" name="endDate" id="endDate">
                        </div>
                        <div class="form-group">
                            <label for="isActive"><i class="fas fa-toggle-on"></i> Trạng thái:</label>
                            <select name="isActive" id="isActive">
                                <option value="1">Hoạt động</option>
                                <option value="0">Không hoạt động</option>
                            </select>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Thêm Mới
                    </button>
                </form>
            </div>
            
            <!-- News/Promotion List -->
            <div class="table-container card-surface">
                <div style="margin-bottom: 10px;">
                    <h2 style="margin: 0 0 16px 0; text-align: center;"><i class="fas fa-list"></i> Danh Sách Tin Tức & Khuyến Mãi</h2>
                    <div style="display: flex; flex-wrap: wrap; align-items: center; justify-content: center; gap: 28px; margin-bottom: 18px;">
                        <form method="get" action="manageNewsAndPromotion" style="display: flex; gap: 8px; align-items: center; margin: 0;" onsubmit="saveScrollAndSubmitSearch(this); return false;">
                            <input type="text" name="search" placeholder="Tìm kiếm theo tiêu đề, nội dung..." value="${currentSearch}" style="padding: 6px 14px; border-radius: 18px; border: 1px solid #ccc; min-width: 220px; outline: none; font-size: 15px;">
                            <button type="submit" class="btn btn-primary" style="border-radius: 18px; padding: 6px 18px; font-weight: 600;">
                                <i class="fas fa-search"></i> Tìm kiếm
                            </button>
                            <c:if test="${not empty currentSearch}">
                                <button type="button" onclick="localStorage.setItem('newsPromotionScroll', window.scrollY); window.location.href='manageNewsAndPromotion'" class="btn btn-secondary" style="border-radius: 18px; padding: 6px 18px; font-weight: 600; cursor: pointer; border: none; margin-left: 2px;">
                                    <i class="fas fa-times"></i> Xóa tìm
                                </button>
                            </c:if>
                        </form>
                        <span style="display: inline-block; width: 1px; height: 32px; background: #e0e0e0; margin: 0 12px;"></span>
                        <div class="filter-buttons" style="display: flex; gap: 12px; flex-wrap: wrap; align-items: center;">
                            <form method="get" action="manageNewsAndPromotion" onsubmit="saveScrollAndSubmit(this); return false;">
                                <input type="hidden" name="filter" value="all"/>
                                <button type="submit" class="filter-btn${currentFilter == null || currentFilter == 'all' ? ' active' : ''}">Tất cả</button>
                            </form>
                            <form method="get" action="manageNewsAndPromotion" onsubmit="saveScrollAndSubmit(this); return false;">
                                <input type="hidden" name="filter" value="news"/>
                                <button type="submit" class="filter-btn${currentFilter == 'news' ? ' active' : ''}">Tin Tức</button>
                            </form>
                            <form method="get" action="manageNewsAndPromotion" onsubmit="saveScrollAndSubmit(this); return false;">
                                <input type="hidden" name="filter" value="promotion"/>
                                <button type="submit" class="filter-btn${currentFilter == 'promotion' ? ' active' : ''}">Khuyến Mãi</button>
                            </form>
                            <form method="get" action="manageNewsAndPromotion" onsubmit="saveScrollAndSubmit(this); return false;">
                                <input type="hidden" name="filter" value="active"/>
                                <button type="submit" class="filter-btn${currentFilter == 'active' ? ' active' : ''}">Đang hoạt động</button>
                            </form>
                        </div>
                    </div>
                </div>
                <div class="table-scroll">
                <table class="news-table">
                    <thead>
                        <tr>
                            <th style="white-space: nowrap;"><i class="fas fa-hashtag"></i> ID</th>
                            <th><i class="fas fa-tag"></i> Loại</th>
                            <th><i class="fas fa-heading"></i> Tiêu đề</th>
                            <th><i class="fas fa-align-left"></i> Nội dung</th>
                            <th><i class="fas fa-image"></i> Hình ảnh</th>
                            <th><i class="fas fa-calendar"></i> Thời gian</th>
                            <th style="white-space: nowrap;"><i class="fas fa-info-circle"></i> Trạng thái</th>
                            <th style="white-space: nowrap;"><i class="fas fa-cogs"></i> Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${newsList}">
                            <tr class="schedule-row ${item.active ? 'status-active' : 'status-inactive'}">
                                <td style="white-space: nowrap;"><strong>#${item.id}</strong></td>
                                <td style="white-space: nowrap;">
                                    <c:choose>
                                        <c:when test="${item.type == 'news'}">
                                            <span class="status-badge status-active">
                                                <i class="fas fa-newspaper"></i> Tin Tức
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-completed">
                                                <i class="fas fa-tags"></i> Khuyến Mãi
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="white-space: nowrap; max-width: 200px; overflow: hidden; text-overflow: ellipsis;">
                                    <strong>${item.title}</strong>
                                </td>
                                <td>
                                    <div class="content-preview">${item.content}</div>
                                </td>
                                <td>
                                    <c:if test="${not empty item.imageUrl}">
                                        <img src="${item.imageUrl}" alt="Image" class="image-preview" onerror="this.style.display='none'">
                                    </c:if>
                                    <c:if test="${empty item.imageUrl}">
                                        <span style="color: #999;"><i class="fas fa-image"></i> Không có</span>
                                    </c:if>
                                </td>
                                <td style="white-space: nowrap; font-size: 0.9rem;">
                                    <c:if test="${not empty item.startDate}">
                                        <div><strong>Bắt đầu:</strong></div>
                                        <div><fmt:formatDate value="${item.startDate}" pattern="dd/MM/yyyy HH:mm"/></div>
                                    </c:if>
                                    <c:if test="${not empty item.endDate}">
                                        <div style="margin-top: 5px;"><strong>Kết thúc:</strong></div>
                                        <div><fmt:formatDate value="${item.endDate}" pattern="dd/MM/yyyy HH:mm"/></div>
                                    </c:if>
                                    <c:if test="${empty item.startDate && empty item.endDate}">
                                        <span style="color: #999;">Không giới hạn</span>
                                    </c:if>
                                </td>
                                <td style="white-space: nowrap;">
                                    <c:choose>
                                        <c:when test="${item.active}">
                                            <span class="status-badge status-active">
                                                <i class="fas fa-check-circle"></i> Hoạt động
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-inactive">
                                                <i class="fas fa-times-circle"></i> Không hoạt động
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <button class="btn btn-small btn-primary" onclick="toggleEditForm('edit-${item.id}')">
                                        <i class="fas fa-edit"></i> Sửa
                                    </button>
                                    <form action="manageNewsAndPromotion" method="post" style="display:inline-block;">
                                        <input type="hidden" name="action" value="toggleActive"/>
                                        <input type="hidden" name="id" value="${item.id}"/>
                                        <button type="submit" class="btn btn-small ${item.active ? 'btn-warning' : 'btn-success'}">
                                            <i class="fas fa-toggle-${item.active ? 'off' : 'on'}"></i> ${item.active ? 'Tắt' : 'Bật'}
                                        </button>
                                    </form>
                                    <form action="manageNewsAndPromotion" method="post" style="display:inline-block;" onsubmit="return confirm('Bạn có chắc chắn muốn xóa?');">
                                        <input type="hidden" name="action" value="delete"/>
                                        <input type="hidden" name="id" value="${item.id}"/>
                                        <button type="submit" class="btn btn-small btn-danger">
                                            <i class="fas fa-trash"></i> Xóa
                                        </button>
                                    </form>
                                </td>
                            </tr>
                            <tr id="edit-${item.id}" class="edit-form" style="display: none;">
                                <td colspan="8">
                                    <h3><i class="fas fa-edit"></i> Chỉnh sửa #${item.id}</h3>
                                    <form action="manageNewsAndPromotion" method="post">
                                        <input type="hidden" name="action" value="update"/>
                                        <input type="hidden" name="id" value="${item.id}"/>
                                        <div class="edit-form-grid">
                                            <div class="form-group">
                                                <label><i class="fas fa-tag"></i> Loại:</label>
                                                <select name="type" required>
                                                    <option value="news" ${item.type == 'news' ? 'selected' : ''}>Tin Tức</option>
                                                    <option value="promotion" ${item.type == 'promotion' ? 'selected' : ''}>Khuyến Mãi</option>
                                                </select>
                                            </div>
                                            <div class="form-group" style="grid-column: 1 / -1;">
                                                <label><i class="fas fa-heading"></i> Tiêu đề:</label>
                                                <input type="text" name="title" value="${item.title}" required/>
                                            </div>
                                            <div class="form-group" style="grid-column: 1 / -1;">
                                                <label><i class="fas fa-align-left"></i> Nội dung:</label>
                                                <textarea name="content" required>${item.content}</textarea>
                                            </div>
                                            <div class="form-group">
                                                <label><i class="fas fa-image"></i> URL Hình ảnh:</label>
                                                <input type="url" name="imageUrl" value="${item.imageUrl}"/>
                                            </div>
                                            <div class="form-group">
                                                <label><i class="fas fa-calendar-check"></i> Ngày bắt đầu:</label>
                                                <c:choose>
                                                    <c:when test="${not empty item.startDate}">
                                                        <fmt:formatDate value="${item.startDate}" pattern="yyyy-MM-dd'T'HH:mm" var="startDateFormatted"/>
                                                        <input type="datetime-local" name="startDate" value="${startDateFormatted}"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <input type="datetime-local" name="startDate"/>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="form-group">
                                                <label><i class="fas fa-calendar-times"></i> Ngày kết thúc:</label>
                                                <c:choose>
                                                    <c:when test="${not empty item.endDate}">
                                                        <fmt:formatDate value="${item.endDate}" pattern="yyyy-MM-dd'T'HH:mm" var="endDateFormatted"/>
                                                        <input type="datetime-local" name="endDate" value="${endDateFormatted}"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <input type="datetime-local" name="endDate"/>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="form-group">
                                                <label><i class="fas fa-toggle-on"></i> Trạng thái:</label>
                                                <select name="isActive">
                                                    <option value="1" ${item.active ? 'selected' : ''}>Hoạt động</option>
                                                    <option value="0" ${!item.active ? 'selected' : ''}>Không hoạt động</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="edit-form-buttons">
                                            <button type="submit" class="btn btn-success">
                                                <i class="fas fa-save"></i> Lưu thay đổi
                                            </button>
                                            <button type="button" class="btn btn-danger" onclick="toggleEditForm('edit-${item.id}')">
                                                <i class="fas fa-times"></i> Hủy
                                            </button>
                                        </div>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty newsList}">
                            <tr>
                                <td colspan="8" style="text-align: center; padding: 40px; color: #666;">
                                    <i class="fas fa-newspaper" style="font-size: 3rem; margin-bottom: 20px; display: block;"></i>
                                    <h3>Chưa có tin tức hoặc khuyến mãi nào</h3>
                                    <p>Hãy thêm tin tức hoặc khuyến mãi đầu tiên bằng form phía trên.</p>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
                </div>
            </div>
        </div>
    </div>
    <footer>
        <p><i class="fas fa-heart"></i> &copy; 2025 Hola Cinema - Hệ thống quản lý rạp chiếu phim</p>
        <p><small>Phiên bản 1.0 - <%= new java.util.Date() %></small></p>
    </footer>

    <!-- JavaScript -->
    <script>
        function toggleEditForm(formId) {
            const form = document.getElementById(formId);
            if (form.style.display === 'none' || form.style.display === '') {
                form.style.display = 'table-row';
                form.scrollIntoView({ behavior: 'smooth', block: 'center' });
            } else {
                form.style.display = 'none';
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                setTimeout(function() {
                    alert.style.opacity = '0';
                    alert.style.transform = 'translateY(-20px)';
                    setTimeout(function() {
                        alert.remove();
                    }, 300);
                }, 5000);
            });

            const forms = document.querySelectorAll('form');
            forms.forEach(function(form) {
                form.addEventListener('submit', function() {
                    const submitBtn = form.querySelector('button[type="submit"]');
                    if (submitBtn) {
                        const originalText = submitBtn.innerHTML;
                        submitBtn.innerHTML = '<span class="loading"></span> Đang xử lý...';
                        submitBtn.disabled = true;
                        
                        setTimeout(function() {
                            submitBtn.innerHTML = originalText;
                            submitBtn.disabled = false;
                        }, 10000);
                    }
                });
            });
        });

        function saveScrollAndSubmit(form) {
            localStorage.setItem('newsPromotionScroll', window.scrollY);
            form.submit();
        }

        function saveScrollAndSubmitSearch(form) {
            localStorage.setItem('newsPromotionScroll', window.scrollY);
            form.submit();
        }

        window.addEventListener('DOMContentLoaded', function() {
            var scroll = localStorage.getItem('newsPromotionScroll');
            if (scroll) {
                window.scrollTo(0, parseInt(scroll));
                localStorage.removeItem('newsPromotionScroll');
            }
        });
    </script>
</body>
</html>

