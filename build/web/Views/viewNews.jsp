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
    <style>
        :root {
            --primary-color: #5a2fc2;
            --accent-color: #ff6f61;
            --bg-light: #fafafa;
            --text-dark: #222;
            --card-bg: #fff;
        }
        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background-color: var(--bg-light);
            color: var(--text-dark);
        }
        header {
            background: var(--card-bg);
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            padding: 10px 60px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: sticky;
            top: 0;
            z-index: 1000;
        }
        .logo {
            font-size: 24px;
            font-weight: 700;
            color: var(--primary-color);
        }
        nav ul {
            list-style: none;
            display: flex;
            gap: 30px;
            margin: 0;
            padding: 0;
        }
        nav ul li a {
            text-decoration: none;
            color: #444;
            font-weight: 500;
        }
        nav ul li a:hover, nav ul li a.active {
            color: var(--accent-color);
        }
        .nav-right {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .search-box input {
            padding: 6px 12px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        .btn {
            background: var(--accent-color);
            color: #fff;
            border: none;
            padding: 8px 16px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
        }
        .btn:hover {
            background: #e55b50;
        }
        .btn.btn-outline-primary.btn-sm {
            border-radius: 20px;
            padding: 6px 14px;
            font-weight: 500;
        }
        .news-container {
            margin-left: 0;
            padding: 40px 60px;
            background: #f5f5f5;
            min-height: calc(100vh - 200px);
        }
        .news-content {
            background: rgba(255, 255, 255, 0.98);
            border-radius: 24px;
            padding: 50px;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.15);
            backdrop-filter: blur(10px);
        }
        .page-header {
            text-align: center;
            margin-bottom: 50px;
            padding: 30px 0;
            background: var(--primary-color);
            border-radius: 20px;
            color: white;
            box-shadow: 0 10px 30px rgba(90, 47, 194, 0.2);
        }
        .page-header h1 {
            color: white;
            font-size: 2.8rem;
            margin-bottom: 15px;
        }
        .page-header p {
            color: rgba(255, 255, 255, 0.95);
            font-size: 1.2rem;
            margin: 0;
        }
        .filter-tabs {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-bottom: 40px;
            flex-wrap: wrap;
        }
        .filter-tab {
            padding: 14px 35px;
            border: none;
            border-radius: 30px;
            font-size: 1.05rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #e9ecef;
            color: #495057;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }
        .filter-tab:hover {
            background: #dee2e6;
            transform: translateY(-3px);
            box-shadow: 0 6px 18px rgba(0, 0, 0, 0.12);
        }
        .filter-tab.active {
            background: var(--primary-color);
            color: white;
            box-shadow: 0 8px 25px rgba(90, 47, 194, 0.4);
            transform: translateY(-2px);
        }
        .section-title {
            font-size: 2rem;
            color: var(--text-dark);
            margin: 50px 0 30px 0;
            padding: 20px 25px;
            background: rgba(90, 47, 194, 0.08);
            border-left: 6px solid var(--primary-color);
            border-radius: 12px;
            display: flex;
            align-items: center;
            gap: 15px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }
        .section-title i {
            color: var(--primary-color);
            font-size: 1.8rem;
        }
        .news-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
            gap: 30px;
            margin-bottom: 50px;
        }
        .news-card {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            cursor: pointer;
            display: flex;
            flex-direction: column;
            border: 1px solid rgba(90, 47, 194, 0.1);
            position: relative;
        }
        .news-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: var(--primary-color);
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }
        .news-card:hover::before {
            transform: scaleX(1);
        }
        .news-card:hover {
            transform: translateY(-10px) scale(1.02);
            box-shadow: 0 20px 50px rgba(90, 47, 194, 0.25);
            border-color: rgba(90, 47, 194, 0.3);
        }
        .news-card-image {
            width: 100%;
            height: 220px;
            object-fit: cover;
            background: var(--primary-color);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3.5rem;
            position: relative;
            overflow: hidden;
        }
        .news-card-image::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(to bottom, transparent 0%, rgba(0, 0, 0, 0.1) 100%);
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        .news-card:hover .news-card-image::after {
            opacity: 1;
        }
        .news-card-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.4s ease;
        }
        .news-card:hover .news-card-image img {
            transform: scale(1.1);
        }
        .news-card-body {
            padding: 25px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            background: white;
        }
        .news-card-type {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 25px;
            font-size: 0.75rem;
            font-weight: 700;
            margin-bottom: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }
        .news-card-type.news {
            background: #e3f2fd;
            color: #1565c0;
            border: 1px solid rgba(21, 101, 192, 0.2);
        }
        .news-card-type.promotion {
            background: #fff3e0;
            color: #e65100;
            border: 1px solid rgba(230, 81, 0, 0.2);
        }
        .news-card-title {
            font-size: 1.4rem;
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 12px;
            line-height: 1.4;
            transition: color 0.3s ease;
        }
        .news-card:hover .news-card-title {
            color: var(--primary-color);
        }
        .news-card-content {
            color: #666;
            font-size: 0.95rem;
            line-height: 1.7;
            margin-bottom: 18px;
            flex-grow: 1;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .news-card-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 18px;
            margin-top: auto;
            border-top: 2px solid #f0f0f0;
        }
        .news-card-date {
            font-size: 0.85rem;
            color: #666;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .news-card-date i {
            color: var(--accent-color);
        }
        .news-card-link {
            color: var(--primary-color);
            font-weight: 600;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: all 0.3s ease;
            padding: 6px 14px;
            border-radius: 20px;
            background: rgba(90, 47, 194, 0.05);
        }
        .news-card-link:hover {
            color: white;
            background: var(--primary-color);
            transform: translateX(5px);
        }
        .news-card-link i {
            transition: transform 0.3s ease;
        }
        .news-card-link:hover i {
            transform: translateX(3px);
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 20px;
            color: #ddd;
        }
        .empty-state h3 {
            font-size: 1.5rem;
            margin-bottom: 10px;
            color: #666;
        }
        footer {
            text-align: center;
            background: var(--text-dark);
            color: #aaa;
            padding: 20px;
            font-size: 14px;
            margin-top: 60px;
        }
        @media (max-width: 768px) {
            header {
                padding: 10px 30px;
                flex-wrap: wrap;
            }
            .news-container {
                margin-left: 0;
                padding: 20px;
            }
            .news-content {
                padding: 20px;
            }
            .page-header h1 {
                font-size: 2rem;
            }
            .news-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            .filter-tabs {
                flex-direction: column;
                align-items: stretch;
            }
            .filter-tab {
                text-align: center;
            }
        }
    </style>
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
                    <p style="color: #666; font-size: 1.1rem;">Cập nhật những thông tin mới nhất và ưu đãi hấp dẫn</p>
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

