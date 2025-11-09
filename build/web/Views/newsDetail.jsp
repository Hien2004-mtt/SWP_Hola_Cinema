<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${item.title} - Hola Cinema</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Views/css/schedule.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .detail-container {
            margin-left: 250px;
            padding: 32px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .detail-content {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(10px);
            max-width: 900px;
            margin: 0 auto;
        }
        .detail-header {
            margin-bottom: 30px;
        }
        .detail-type {
            display: inline-block;
            padding: 8px 16px;
            border-radius: 25px;
            font-size: 0.9rem;
            font-weight: 600;
            margin-bottom: 15px;
            text-transform: uppercase;
        }
        .detail-type.news {
            background: #e3f2fd;
            color: #1976d2;
        }
        .detail-type.promotion {
            background: #fff3e0;
            color: #f57c00;
        }
        .detail-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 20px;
            line-height: 1.3;
        }
        .detail-meta {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            color: #666;
            font-size: 0.95rem;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #eee;
        }
        .detail-meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .detail-image {
            width: 100%;
            max-height: 500px;
            object-fit: cover;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }
        .detail-image-placeholder {
            width: 100%;
            height: 400px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 5rem;
            margin-bottom: 30px;
        }
        .detail-body {
            font-size: 1.1rem;
            line-height: 1.8;
            color: #444;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        .detail-footer {
            margin-top: 40px;
            padding-top: 30px;
            border-top: 2px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }
        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 12px 24px;
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        .back-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }
        .date-range {
            background: #f8f9fa;
            padding: 15px 20px;
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }
        @media (max-width: 768px) {
            .detail-container {
                margin-left: 0;
                padding: 20px;
            }
            .detail-content {
                padding: 20px;
            }
            .detail-title {
                font-size: 1.8rem;
            }
            .detail-meta {
                flex-direction: column;
                gap: 10px;
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
        <p><i class="fas fa-heart"></i> &copy; 2025 Hola Cinema - Hệ thống quản lý rạp chiếu phim</p>
    </footer>
</body>
</html>

