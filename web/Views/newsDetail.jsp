<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="Models.User" %>
<%
    User user = (User) session.getAttribute("user");
%>
<c:set var="loggedUser" value="${sessionScope.user}" />
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${item.title} - Hola Cinema</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Views/css/schedule.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/newsDetail.css">
</head>
<body>

<header>
    <div class="logo">🎬 Hola Cinema Center</div>

    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/movies">Movies</a></li>
            <li><a href="#">Booking</a></li>
            <li><a href="${pageContext.request.contextPath}/viewNews" class="active">News & Promotions</a></li>
            <li><a href="#">Contact</a></li>
        </ul>
    </nav>

    <div class="nav-right">
        <form action="${pageContext.request.contextPath}/home" method="get" class="search-box">
            <input type="text" name="q" placeholder="Search..." 
                   value="${param.q}" style="padding:6px 12px;border:1px solid #ccc;border-radius:5px;">
        </form>

        <c:choose>
            <c:when test="${not empty loggedUser}">
                <span>Xin chào, <strong>${loggedUser.name}</strong></span>

                <!--  PROFILE DROPDOWN -->
                <div class="dropdown">
            <button class="btn btn-outline-primary btn-sm dropdown-toggle"
                    type="button" id="profileMenu"
                    data-bs-toggle="dropdown" aria-expanded="false">
                Profile
            </button>
            <ul class="dropdown-menu dropdown-menu-end shadow-sm" aria-labelledby="profileMenu">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/updateProfile"> Update Profile</a></li>
                <% if (user != null && user.getRole() == 2) { %>
                            <li>
                                <a class="dropdown-item" href="${pageContext.request.contextPath}/transactionHistory">
                                    Lịch sử giao dịch
                                </a>
                            </li>
                            <% } %>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/voucher?action=list">️ Voucher</a></li>
            </ul>
        </div>

                <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">Đăng xuất</a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-success">Sign in</a>
                <a href="${pageContext.request.contextPath}/register" class="btn btn-secondary">Register</a>
            </c:otherwise>
        </c:choose>
    </div>
</header>

    <div class="container">
        <div class="detail-container">
            <div class="detail-content fade-in">
                <div class="detail-header">
                    <span class="detail-type ${item.type}">
                        <i class="fas fa-${item.type == 'news' ? 'newspaper' : 'tags'}"></i>
                        ${item.type == 'news' ? 'Tin Tức' : 'Khuyến Mãi'}
                    </span>
                    <h1 class="detail-title">${item.title}</h1>
                    <div class="detail-meta">
                        <div class="detail-meta-item">
                            <i class="fas fa-calendar"></i>
                            <span>Ngày đăng: <fmt:formatDate value="${item.createdAt}" pattern="dd/MM/yyyy HH:mm"/></span>
                        </div>
                        <c:if test="${not empty item.startDate || not empty item.endDate}">
                            <div class="detail-meta-item">
                                <i class="fas fa-calendar-alt"></i>
                                <span>
                                    <c:if test="${not empty item.startDate}">
                                        Từ: <fmt:formatDate value="${item.startDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </c:if>
                                    <c:if test="${not empty item.startDate && not empty item.endDate}"> - </c:if>
                                    <c:if test="${not empty item.endDate}">
                                        Đến: <fmt:formatDate value="${item.endDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </c:if>
                                </span>
                            </div>
                        </c:if>
                    </div>
                </div>

                <c:choose>
                    <c:when test="${not empty item.imageUrl}">
                        <img src="${item.imageUrl}" alt="${item.title}" class="detail-image" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                        <div class="detail-image-placeholder" style="display: none;">
                            <i class="fas fa-${item.type == 'news' ? 'newspaper' : 'tags'}"></i>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="detail-image-placeholder">
                            <i class="fas fa-${item.type == 'news' ? 'newspaper' : 'tags'}"></i>
                        </div>
                    </c:otherwise>
                </c:choose>

                <div class="detail-body">
                    ${item.content}
                </div>

                <div class="detail-footer">
                    <a href="${pageContext.request.contextPath}/viewNews" class="back-button">
                        <i class="fas fa-arrow-left"></i>
                        Quay lại danh sách
                    </a>
                    <c:if test="${not empty item.startDate || not empty item.endDate}">
                        <div class="date-range">
                            <strong><i class="fas fa-info-circle"></i> Thời gian hiệu lực:</strong><br>
                            <c:if test="${not empty item.startDate}">
                                <fmt:formatDate value="${item.startDate}" pattern="dd/MM/yyyy HH:mm"/>
                            </c:if>
                            <c:if test="${not empty item.startDate && not empty item.endDate}"> - </c:if>
                            <c:if test="${not empty item.endDate}">
                                <fmt:formatDate value="${item.endDate}" pattern="dd/MM/yyyy HH:mm"/>
                            </c:if>
                            <c:if test="${empty item.startDate && empty item.endDate}">
                                Không giới hạn thời gian
                            </c:if>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    <footer>
        © 2025 Hola Cinema Center — Designed by your team.
    </footer>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

