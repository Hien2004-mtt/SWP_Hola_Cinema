<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<script>
// Lưu vị trí scroll trước khi submit filter
function saveScrollAndSubmit(form) {
    localStorage.setItem('manageScheduleScroll', window.scrollY);
    form.submit();
}
window.addEventListener('DOMContentLoaded', function() {
    var scroll = localStorage.getItem('manageScheduleScroll');
    if (scroll) {
        window.scrollTo(0, parseInt(scroll));
        localStorage.removeItem('manageScheduleScroll');
    }
});
</script>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Lịch Chiếu - Hola Cinema</title>
    <link rel="stylesheet" href="css/admin.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="container">
        <div class="main-content fade-in">
            <h1><i class="fas fa-calendar-alt"></i> Quản Lý Lịch Chiếu</h1>
            
            <!-- Alert Messages -->
            <c:if test="${not empty success}">
                <div class="alert alert-success" id="success-alert">
                    <i class="fas fa-check-circle"></i> ${success}
                </div>
                <script>
                    // Xóa thông báo thành công khỏi session sau khi hiển thị
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
                    // Xóa lỗi khỏi session sau khi hiển thị
                    if (window.location.search.indexOf('error') === -1) {
                        if (typeof window.history.replaceState === 'function') {
                            window.history.replaceState({}, document.title, window.location.pathname);
                        }
                    }
                </script>
            </c:if>
            
            <!-- Debug Info (Remove in production) -->
            <c:if test="${empty upcomingMovies}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i> 
                    <strong>Cảnh báo:</strong> Không có phim nào để chọn. Vui lòng kiểm tra dữ liệu phim trong database.
                </div>
            </c:if>
            <c:if test="${empty activeAuditoriums}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i> 
                    <strong>Cảnh báo:</strong> Không có phòng chiếu nào hoạt động. Vui lòng kiểm tra dữ liệu phòng chiếu.
                </div>
            </c:if>
            <!-- Add New Schedule Form -->
            <div class="form-section">
                <h2><i class="fas fa-plus-circle"></i> Thêm Lịch Chiếu Mới</h2>
                <form action="manageSchedule" method="post">
                    <input type="hidden" name="action" value="add"/>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="movieId"><i class="fas fa-film"></i> Chọn Phim:</label>
                            <select name="movieId" required <c:if test="${empty upcomingMovies}">disabled</c:if>>
                                <option value="">-- Chọn phim --</option>
                                <c:forEach var="movie" items="${upcomingMovies}">
                                    <option value="${movie.movieId}" <c:if test="${movie.movieId == form_movieId}">selected</c:if>>${movie.movieName}</option>
                                </c:forEach>
                            </select>
                            <c:if test="${empty upcomingMovies}">
                                <small style="color: #e74c3c; margin-top: 5px; display: block;">
                                    <i class="fas fa-info-circle"></i> Không có phim nào khả dụng
                                </small>
                            </c:if>
                        </div>
                        <div class="form-group">
                            <label for="auditoriumId"><i class="fas fa-door-open"></i> Chọn Phòng:</label>
                            <select name="auditoriumId" required <c:if test="${empty activeAuditoriums}">disabled</c:if>>
                                <option value="">-- Chọn phòng --</option>
                                <c:forEach var="auditorium" items="${activeAuditoriums}">
                                    <option value="${auditorium.auditoriumId}" <c:if test="${auditorium.auditoriumId == form_auditoriumId}">selected</c:if>>${auditorium.auditoriumName}</option>
                                </c:forEach>
                            </select>
                            <c:if test="${empty activeAuditoriums}">
                                <small style="color: #e74c3c; margin-top: 5px; display: block;">
                                    <i class="fas fa-info-circle"></i> Không có phòng chiếu nào hoạt động
                                </small>
                            </c:if>
                        </div>
                        <div class="form-group">
                            <label for="showDate"><i class="fas fa-calendar-day"></i> Ngày chiếu:</label>
                            <input type="date" name="showDate" required id="showDate" value="${form_showDate}">
                        </div>
                        <div class="form-group">
                            <label for="startTime"><i class="fas fa-clock"></i> Thời gian bắt đầu:</label>
                            <input type="time" name="startTime" required id="startTime" value="${form_startTime}">
                        </div>
                        <div class="form-group">
                            <label for="endTime"><i class="fas fa-clock"></i> Thời gian kết thúc:</label>
                            <input type="time" name="endTime" required id="endTime" value="${form_endTime}">
                        </div>
                        <div class="form-group">
                            <label for="basePrice"><i class="fas fa-money-bill-wave"></i> Giá vé (VND):</label>
                            <input type="number" name="basePrice" step="1000" min="0" placeholder="Nhập giá vé..." required value="${form_basePrice}">
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-plus"></i> Thêm Lịch Chiếu
                    </button>
                </form>
            </div>
            <!-- Schedule List -->
            <div class="table-container">
                <div style="display: flex; flex-direction: column; align-items: center; gap: 10px; margin-bottom: 10px;">
                    <h2 style="margin: 0; text-align: center;"><i class="fas fa-list"></i> Danh Sách Lịch Chiếu</h2>
                    <div class="filter-buttons" style="display: flex; gap: 8px; flex-wrap: wrap;">
                        <style>
                        .filter-buttons form { display: inline; }
                        .filter-btn {
                            border-radius: 20px;
                            padding: 6px 18px;
                            font-weight: 600;
                            border: none;
                            background: #f1f1f1;
                            color: #333;
                            transition: background 0.2s, color 0.2s, box-shadow 0.2s;
                            box-shadow: 0 1px 2px rgba(0,0,0,0.04);
                            cursor: pointer;
                            outline: none;
                        }
                        .filter-btn.active, .filter-btn:focus {
                            background: #007bff;
                            color: #fff;
                            box-shadow: 0 2px 8px rgba(0,123,255,0.10);
                        }
                        .filter-btn:hover:not(.active) {
                            background: #e0e0e0;
                        }
                        @media (max-width: 600px) {
                            .filter-buttons { flex-wrap: wrap; gap: 4px; }
                            .filter-btn { padding: 6px 10px; font-size: 14px; }
                        }
                        </style>
                        <form method="get" action="manageSchedule" onsubmit="saveScrollAndSubmit(this); return false;">
                            <input type="hidden" name="filter" value="all"/>
                            <button type="submit" class="filter-btn${param.filter == null || param.filter == 'all' ? ' active' : ''}">Tất cả</button>
                        </form>
                        <form method="get" action="manageSchedule" onsubmit="saveScrollAndSubmit(this); return false;">
                            <input type="hidden" name="filter" value="active"/>
                            <button type="submit" class="filter-btn${param.filter == 'active' ? ' active' : ''}">Hoạt động</button>
                        </form>
                        <form method="get" action="manageSchedule" onsubmit="saveScrollAndSubmit(this); return false;">
                            <input type="hidden" name="filter" value="completed"/>
                            <button type="submit" class="filter-btn${param.filter == 'completed' ? ' active' : ''}">Hoàn thành</button>
                        </form>
                        <form method="get" action="manageSchedule" onsubmit="saveScrollAndSubmit(this); return false;">
                            <input type="hidden" name="filter" value="cancelled"/>
                            <button type="submit" class="filter-btn${param.filter == 'cancelled' ? ' active' : ''}">Hủy</button>
                        </form>
                    </div>
                </div>
                <table>
                    <thead>
                        <tr>
                            <th><i class="fas fa-hashtag"></i> ID</th>
                            <th><i class="fas fa-film"></i> Tên Phim</th>
                            <th><i class="fas fa-door-open"></i> Phòng</th>
                            <th><i class="fas fa-clock"></i> Bắt đầu</th>
                            <th><i class="fas fa-clock"></i> Kết thúc</th>
                            <th><i class="fas fa-money-bill-wave"></i> Giá vé</th>
                            <th><i class="fas fa-info-circle"></i> Trạng thái</th>
                            <th><i class="fas fa-cogs"></i> Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="schedule" items="${scheduleList}">
                            <tr class="schedule-row status-${schedule.status}">
                                <td><strong>#${schedule.showtimeId}</strong></td>
                                <td>${schedule.movieName}</td>
                                <td><span class="status-badge status-active">${schedule.auditoriumName}</span></td>
                                <td><fmt:formatDate value="${schedule.startTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td><fmt:formatDate value="${schedule.endTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                                <td><strong><fmt:formatNumber value="${schedule.price}" type="currency" currencyCode="VND"/></strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${schedule.status == 'active'}">
                                            <span class="status-badge status-active">
                                                <i class="fas fa-check-circle"></i> Hoạt động
                                            </span>
                                        </c:when>
                                        <c:when test="${schedule.status == 'cancelled'}">
                                            <span class="status-badge status-inactive">
                                                <i class="fas fa-times-circle"></i> Đã hủy
                                            </span>
                                        </c:when>
                                        <c:when test="${schedule.status == 'completed'}">
                                            <span class="status-badge status-completed">
                                                <i class="fas fa-check-double"></i> Hoàn thành
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-active">
                                                <i class="fas fa-check-circle"></i> Hoạt động
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${schedule.status == 'active'}">
                                            <button class="btn btn-small btn-primary" onclick="toggleEditForm('edit-${schedule.showtimeId}')">
                                                <i class="fas fa-edit"></i> Sửa
                                            </button>
                                            <form action="manageSchedule" method="post" style="display:inline-block;">
                                                <input type="hidden" name="action" value="cancel"/>
                                                <input type="hidden" name="showtimeId" value="${schedule.showtimeId}"/>
                                                <button type="submit" class="btn btn-small btn-warning">
                                                    <i class="fas fa-ban"></i> Hủy
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:when test="${schedule.status == 'cancelled'}">
                                            <form action="manageSchedule" method="post" style="display:inline-block;">
                                                <input type="hidden" name="action" value="restore"/>
                                                <input type="hidden" name="showtimeId" value="${schedule.showtimeId}"/>
                                                <button type="submit" class="btn btn-small btn-success">
                                                    <i class="fas fa-undo"></i> Khôi phục
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="btn btn-small btn-secondary" disabled>
                                                <i class="fas fa-lock"></i> Không thể chỉnh sửa
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr id="edit-${schedule.showtimeId}" class="edit-form" style="display: none;">
                                <td colspan="8">
                                    <h3><i class="fas fa-edit"></i> Chỉnh sửa lịch chiếu #${schedule.showtimeId}</h3>
                                    <form action="manageSchedule" method="post">
                                        <input type="hidden" name="action" value="update"/>
                                        <input type="hidden" name="showtimeId" value="${schedule.showtimeId}"/>
                                        <div class="edit-form-grid">
                                            <div class="form-group">
                                                <label><i class="fas fa-film"></i> Phim:</label>
                                                <select name="movieId" required>
                                                    <c:forEach var="movie" items="${upcomingMovies}">
                                                        <option value="${movie.movieId}" <c:if test="${movie.movieId == schedule.movieId}">selected</c:if>>${movie.movieName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label><i class="fas fa-door-open"></i> Phòng:</label>
                                                <select name="auditoriumId" required>
                                                    <c:forEach var="auditorium" items="${activeAuditoriums}">
                                                        <option value="${auditorium.auditoriumId}" <c:if test="${auditorium.auditoriumId == schedule.auditoriumId}">selected</c:if>>${auditorium.auditoriumName}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label><i class="fas fa-calendar-day"></i> Ngày chiếu:</label>
                                                <fmt:formatDate value="${schedule.startTime}" pattern="yyyy-MM-dd" var="_showDate"/>
                                                <input type="date" name="showDate" value="${_showDate}" required/>
                                            </div>
                                            <div class="form-group">
                                                <label><i class="fas fa-clock"></i> Bắt đầu:</label>
                                                <fmt:formatDate value="${schedule.startTime}" pattern="HH:mm" var="_startTime"/>
                                                <input type="time" name="startTime" value="${_startTime}" required/>
                                            </div>
                                            <div class="form-group">
                                                <label><i class="fas fa-clock"></i> Kết thúc:</label>
                                                <fmt:formatDate value="${schedule.endTime}" pattern="HH:mm" var="_endTime"/>
                                                <input type="time" name="endTime" value="${_endTime}" required/>
                                            </div>
                                            <div class="form-group">
                                                <label><i class="fas fa-money-bill-wave"></i> Giá:</label>
                                                <input type="number" name="basePrice" step="1000" value="${schedule.price}" required/>
                                            </div>
                                        </div>
                                        <div class="edit-form-buttons">
                                            <button type="submit" class="btn btn-success">
                                                <i class="fas fa-save"></i> Lưu thay đổi
                                            </button>
                                            <button type="button" class="btn btn-danger" onclick="toggleEditForm('edit-${schedule.showtimeId}')">
                                                <i class="fas fa-times"></i> Hủy
                                            </button>
                                        </div>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty scheduleList}">
                            <tr>
                                <td colspan="8" style="text-align: center; padding: 40px; color: #666;">
                                    <i class="fas fa-calendar-times" style="font-size: 3rem; margin-bottom: 20px; display: block;"></i>
                                    <h3>Chưa có lịch chiếu nào</h3>
                                    <p>Hãy thêm lịch chiếu đầu tiên bằng form phía trên.</p>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <footer>
        <p><i class="fas fa-heart"></i> &copy; 2025 Hola Cinema - Hệ thống quản lý rạp chiếu phim</p>
        <p><small>Phiên bản 1.0 - <%= new java.util.Date() %></small></p>
    </footer>


    <!-- JavaScript for Enhanced UX -->
    <script>

        // Toggle edit form visibility
        function toggleEditForm(formId) {
            const form = document.getElementById(formId);
            if (form.style.display === 'none' || form.style.display === '') {
                form.style.display = 'table-row';
                form.scrollIntoView({ behavior: 'smooth', block: 'center' });
            } else {
                form.style.display = 'none';
            }
        }

        // Auto-hide alerts after 5 seconds
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

            // Add loading state to buttons
            const forms = document.querySelectorAll('form');
            forms.forEach(function(form) {
                form.addEventListener('submit', function() {
                    const submitBtn = form.querySelector('button[type="submit"]');
                    if (submitBtn) {
                        const originalText = submitBtn.innerHTML;
                        submitBtn.innerHTML = '<span class="loading"></span> Đang xử lý...';
                        submitBtn.disabled = true;
                        
                        // Re-enable after 10 seconds as fallback
                        setTimeout(function() {
                            submitBtn.innerHTML = originalText;
                            submitBtn.disabled = false;
                        }, 10000);
                    }
                });
            });

        });

        // Form validation enhancement
        async function validateDateTime() {
            const showDate = document.querySelector('input[name="showDate"]');
            const startTime = document.querySelector('input[name="startTime"]');
            const endTime = document.querySelector('input[name="endTime"]');
            
            // Kiểm tra ngày chiếu không được là ngày quá khứ
            if (showDate && showDate.value) {
                const today = new Date();
                const selectedDate = new Date(showDate.value);
                today.setHours(0, 0, 0, 0);
                selectedDate.setHours(0, 0, 0, 0);
                
                if (selectedDate < today) {
                    await customConfirm('Ngày chiếu không thể là ngày quá khứ!\n\nVui lòng chọn ngày hiện tại hoặc tương lai.', 'warning');
                    return false;
                }
            }
            
            // Kiểm tra thời gian kết thúc phải sau thời gian bắt đầu
            if (startTime && endTime && startTime.value && endTime.value) {
                const start = startTime.value.split(':');
                const end = endTime.value.split(':');
                const startMinutes = parseInt(start[0]) * 60 + parseInt(start[1]);
                const endMinutes = parseInt(end[0]) * 60 + parseInt(end[1]);
                
                if (startMinutes >= endMinutes) {
                    await customConfirm('Thời gian kết thúc phải sau thời gian bắt đầu!\n\nVui lòng kiểm tra lại thời gian.', 'warning');
                    return false;
                }
                
                // Kiểm tra thời gian bắt đầu không quá sớm (trước 6h sáng)
                if (startMinutes < 360) { // 6:00 AM = 360 minutes
                    const confirmed = await customConfirm('Thời gian bắt đầu trước 6:00 sáng.\n\nBạn có chắc chắn muốn tiếp tục?', 'warning');
                    if (!confirmed) {
                        return false;
                    }
                }
                
                // Kiểm tra thời gian kết thúc không quá muộn (sau 11h tối)
                if (endMinutes > 1380) { // 11:00 PM = 1380 minutes
                    const confirmed = await customConfirm('Thời gian kết thúc sau 11:00 tối.\n\nBạn có chắc chắn muốn tiếp tục?', 'warning');
                    if (!confirmed) {
                        return false;
                    }
                }
            }
            return true;
        }

        // Add validation to all forms
        document.addEventListener('DOMContentLoaded', function() {
            const forms = document.querySelectorAll('form');
            forms.forEach(function(form) {
                form.addEventListener('submit', async function(e) {
                    const isValid = await validateDateTime();
                    if (!isValid) {
                        e.preventDefault();
                    }
                });
            });
            
            // Set default values for better UX
            const showDateInput = document.getElementById('showDate');
            const startTimeInput = document.getElementById('startTime');
            const endTimeInput = document.getElementById('endTime');
            
            // Set default date to today
            if (showDateInput && !showDateInput.value) {
                const today = new Date();
                const dateString = today.toISOString().split('T')[0];
                showDateInput.value = dateString;
            }
            
            // Set default start time to 19:00 (7 PM)
            if (startTimeInput && !startTimeInput.value) {
                startTimeInput.value = '19:00';
            }
            
            // Set default end time to 21:30 (9:30 PM)
            if (endTimeInput && !endTimeInput.value) {
                endTimeInput.value = '21:30';
            }
            
            // Auto-calculate end time when start time changes
            if (startTimeInput && endTimeInput) {
                startTimeInput.addEventListener('change', function() {
                    if (this.value && !endTimeInput.value) {
                        const startTime = new Date('2000-01-01T' + this.value);
                        const endTime = new Date(startTime.getTime() + (2.5 * 60 * 60 * 1000)); // Add 2.5 hours
                        const endTimeString = endTime.toTimeString().substring(0, 5);
                        endTimeInput.value = endTimeString;
                    }
                });
            }
        });
    </script>
</body>
</html>

