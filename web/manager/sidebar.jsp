<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css"/>

<div class="sidebar" id="sidebar">
    <h4>🎬 Manager</h4>
    <a href="${pageContext.request.contextPath}/manager/dashboard.jsp" class="nav-link"><i>📊</i> <span>Overview</span></a>
    <a href="${pageContext.request.contextPath}/manager/movie_management" class="nav-link"><i>🎥</i> <span>Movie Management</span></a>
    <a href="${pageContext.request.contextPath}/manager/showtime_management.jsp" class="nav-link"><i>🕒</i> <span>Showtime</span></a>
    <a href="${pageContext.request.contextPath}/manager/ticket_management.jsp" class="nav-link"><i>🎟️</i> <span>Ticket</span></a>
    <a href="${pageContext.request.contextPath}/listAuditorium" class="nav-link"><i>💺</i> <span>Auditorium Management</span></a>
    <a href="${pageContext.request.contextPath}/manager/revenue_management.jsp" class="nav-link"><i>💰</i> <span>Revenue</span></a>
    <a href="${pageContext.request.contextPath}/manager/staff_management.jsp" class="nav-link"><i>👥</i> <span>Staff</span></a>
    <a href="${pageContext.request.contextPath}/manager/user_management.jsp" class="nav-link"><i>👤</i> <span>User</span></a>
</div>

