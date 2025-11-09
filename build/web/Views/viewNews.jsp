<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tin Tức & Khuyến Mãi - Hola Cinema</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Views/css/schedule.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .news-container {
            margin-left: 250px;
            padding: 32px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .news-content {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
        }
        .page-header {
            text-align: center;
            margin-bottom: 40px;
        }
        .page-header h1 {
            color: #2c3e50;
            font-size: 2.5rem;
            margin-bottom: 10px;
        }
        .filter-tabs {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        .filter-tab {
            padding: 12px 30px;
            border: none;
            border-radius: 25px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-block;
            background: #f1f1f1;
            color: #333;
        }
        .filter-tab:hover {
            background: #e0e0e0;
            transform: translateY(-2px);
        }
        .filter-tab.active {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        .section-title {
            font-size: 1.8rem;
            color: #2c3e50;
            margin: 40px 0 20px 0;
            padding-bottom: 10px;
            border-bottom: 3px solid #667eea;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .news-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        .news-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            cursor: pointer;
            display: flex;
            flex-direction: column;
        }
        .news-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
        }
        .news-card-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
        }
        .news-card-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .news-card-body {
            padding: 20px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }
        .news-card-type {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
            margin-bottom: 10px;
            text-transform: uppercase;
        }
        .news-card-type.news {
            background: #e3f2fd;
            color: #1976d2;
        }
        .news-card-type.promotion {
            background: #fff3e0;
            color: #f57c00;
        }
        .news-card-title {
            font-size: 1.3rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 10px;
            line-height: 1.4;
        }
        .news-card-content {
            color: #666;
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: 15px;
            flex-grow: 1;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .news-card-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
        .news-card-date {
            font-size: 0.85rem;
            color: #999;
        }
        .news-card-link {
            color: #667eea;
            font-weight: 600;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 5px;
            transition: color 0.3s;
        }
        .news-card-link:hover {
            color: #764ba2;
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
        @media (max-width: 768px) {
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
    <div class="container">
        <div class="sidebar">
            <h2>Menu</h2>
            <nav>
                <a href="${pageContext.request.contextPath}/agenda">
                    <i class="fas fa-calendar-alt" style="margin-right:8px;"></i> Lịch Chiếu Phim
                </a>
                <a href="${pageContext.request.contextPath}/viewNews" class="active">
                    <i class="fas fa-newspaper" style="margin-right:8px;"></i> Tin Tức & Khuyến Mãi
                </a>
            </nav>
        </div>
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
        <p><i class="fas fa-heart"></i> &copy; 2025 Hola Cinema - Hệ thống quản lý rạp chiếu phim</p>
    </footer>
</body>
</html>

