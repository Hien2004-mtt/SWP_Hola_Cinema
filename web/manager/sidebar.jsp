<%@ page pageEncoding="UTF-8" %><%@ page  %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css"/>

<div class="sidebar" id="sidebar">
    <h4>🎬 Manager</h4>
    <a href="${pageContext.request.contextPath}/manager/dashboard.jsp" class="nav-link"><i>📊</i> <span>Overview</span></a>
    <a href="${pageContext.request.contextPath}/movie_management" class="nav-link"><i>🎥</i> <span>Movie Management</span></a>
    <a href="${pageContext.request.contextPath}/manageSchedule" class="nav-link"><i>🕒</i> <span>Showtime Management</span></a>
    <a href="${pageContext.request.contextPath}/agenda" class="nav-link"><i>𝄜</i> <span>Agenda</span></a>
    <a href="${pageContext.request.contextPath}/voucher?action=list" class="nav-link"><i>👤</i> <span>Voucher Management</span></a>
    <a href="${pageContext.request.contextPath}/listAuditorium" class="nav-link"><i>💺</i> <span>Auditorium Management</span></a>
    <a href="${pageContext.request.contextPath}/manageNewsAndPromotion" class="nav-link"><i>📅</i> <span>News and Promotion Management</span></a>
</div>

