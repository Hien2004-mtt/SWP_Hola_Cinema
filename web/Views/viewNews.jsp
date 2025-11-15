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
    <title>Tin Tức & Khuyến Mãi - Hola Cinema</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Views/css/schedule.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/viewNews.css">
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
        <div class="news-container">
            <div class="news-content fade-in">
                <div class="page-header">
                    <h1><i class="fas fa-newspaper"></i> Tin Tức & Khuyến Mãi</h1>
                    <p style="color: #FFFFFF; font-size: 1.1rem;">Cập nhật những thông tin mới nhất và ưu đãi hấp dẫn</p>
                </div>

                <!-- Filter Tabs -->
                <div class="filter-tabs">
                    <a href="${pageContext.request.contextPath}/viewNews" class="filter-tab ${currentType == 'all' ? 'active' : ''}">
                        <i class="fas fa-th"></i> Tất cả
                    </a>
                    <a href="${pageContext.request.contextPath}/viewNews?type=news" class="filter-tab ${currentType == 'news' ? 'active' : ''}">
                        <i class="fas fa-newspaper"></i> Tin Tức
                    </a>
                    <a href="${pageContext.request.contextPath}/viewNews?type=promotion" class="filter-tab ${currentType == 'promotion' ? 'active' : ''}">
                        <i class="fas fa-tags"></i> Khuyến Mãi
                    </a>
                </div>

                <!-- News Section -->
                <c:if test="${not empty newsList || currentType == 'all' || currentType == 'news'}">
                    <div class="section-title">
                        <i class="fas fa-newspaper"></i>
                        <span>Tin Tức</span>
                    </div>
                    <c:choose>
                        <c:when test="${not empty newsList}">
                            <div class="news-grid">
                                <c:forEach var="item" items="${newsList}">
                                    <div class="news-card" onclick="window.location.href='${pageContext.request.contextPath}/viewNews?id=${item.id}'">
                                        <div class="news-card-image">
                                            <c:choose>
                                                <c:when test="${not empty item.imageUrl}">
                                                    <img src="${item.imageUrl}" alt="${item.title}" onerror="this.parentElement.innerHTML='<i class=\'fas fa-newspaper\'></i>'">
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-newspaper"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="news-card-body">
                                            <span class="news-card-type news">Tin Tức</span>
                                            <h3 class="news-card-title">${item.title}</h3>
                                            <p class="news-card-content">${item.content}</p>
                                            <div class="news-card-footer">
                                                <span class="news-card-date">
                                                    <i class="fas fa-calendar"></i>
                                                    <fmt:formatDate value="${item.createdAt}" pattern="dd/MM/yyyy"/>
                                                </span>
                                                <span class="news-card-link">
                                                    Xem thêm <i class="fas fa-arrow-right"></i>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fas fa-newspaper"></i>
                                <h3>Chưa có tin tức nào</h3>
                                <p>Vui lòng quay lại sau để xem các tin tức mới nhất</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:if>

                <!-- Promotion Section -->
                <c:if test="${not empty promotionList || currentType == 'all' || currentType == 'promotion'}">
                    <div class="section-title">
                        <i class="fas fa-tags"></i>
                        <span>Khuyến Mãi</span>
                    </div>
                    <c:choose>
                        <c:when test="${not empty promotionList}">
                            <div class="news-grid">
                                <c:forEach var="item" items="${promotionList}">
                                    <div class="news-card" onclick="window.location.href='${pageContext.request.contextPath}/viewNews?id=${item.id}'">
                                        <div class="news-card-image">
                                            <c:choose>
                                                <c:when test="${not empty item.imageUrl}">
                                                    <img src="${item.imageUrl}" alt="${item.title}" onerror="this.parentElement.innerHTML='<i class=\'fas fa-tags\'></i>'">
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-tags"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="news-card-body">
                                            <span class="news-card-type promotion">Khuyến Mãi</span>
                                            <h3 class="news-card-title">${item.title}</h3>
                                            <p class="news-card-content">${item.content}</p>
                                            <div class="news-card-footer">
                                                <span class="news-card-date">
                                                    <c:if test="${not empty item.startDate || not empty item.endDate}">
                                                        <i class="fas fa-calendar-alt"></i>
                                                        <c:if test="${not empty item.startDate}">
                                                            <fmt:formatDate value="${item.startDate}" pattern="dd/MM/yyyy"/>
                                                        </c:if>
                                                        <c:if test="${not empty item.startDate && not empty item.endDate}"> - </c:if>
                                                        <c:if test="${not empty item.endDate}">
                                                            <fmt:formatDate value="${item.endDate}" pattern="dd/MM/yyyy"/>
                                                        </c:if>
                                                    </c:if>
                                                    <c:if test="${empty item.startDate && empty item.endDate}">
                                                        <i class="fas fa-infinity"></i> Không giới hạn
                                                    </c:if>
                                                </span>
                                                <span class="news-card-link">
                                                    Xem thêm <i class="fas fa-arrow-right"></i>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="empty-state">
                                <i class="fas fa-tags"></i>
                                <h3>Chưa có khuyến mãi nào</h3>
                                <p>Vui lòng quay lại sau để xem các ưu đãi hấp dẫn</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:if>

                <!-- Empty State for All -->
                <c:if test="${empty newsList && empty promotionList}">
                    <div class="empty-state">
                        <i class="fas fa-inbox"></i>
                        <h3>Chưa có nội dung nào</h3>
                        <p>Hiện tại chưa có tin tức hoặc khuyến mãi nào. Vui lòng quay lại sau!</p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
    <footer>
        © 2025 Hola Cinema Center — Designed by your team.
    </footer>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

