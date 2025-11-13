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
        .detail-container {
            margin-left: 0;
            padding: 40px 60px;
            background: #f5f5f5;
            min-height: calc(100vh - 200px);
        }
        .detail-content {
            background: rgba(255, 255, 255, 0.98);
            border-radius: 24px;
            padding: 50px;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.15);
            backdrop-filter: blur(10px);
            max-width: 950px;
            margin: 0 auto;
            border: 1px solid rgba(90, 47, 194, 0.1);
        }
        .detail-header {
            margin-bottom: 35px;
            padding-bottom: 25px;
            border-bottom: 3px solid #f0f0f0;
        }
        .detail-type {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 20px;
            border-radius: 25px;
            font-size: 0.85rem;
            font-weight: 700;
            margin-bottom: 20px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        .detail-type.news {
            background: #e3f2fd;
            color: #1565c0;
            border: 2px solid rgba(21, 101, 192, 0.2);
        }
        .detail-type.promotion {
            background: #fff3e0;
            color: #e65100;
            border: 2px solid rgba(230, 81, 0, 0.2);
        }
        .detail-title {
            font-size: 2.8rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 20px;
            line-height: 1.3;
        }
        .detail-meta {
            display: flex;
            gap: 25px;
            flex-wrap: wrap;
            color: #666;
            font-size: 0.95rem;
            margin-bottom: 30px;
            padding: 20px;
            background: rgba(90, 47, 194, 0.05);
            border-radius: 12px;
            border-left: 4px solid var(--primary-color);
        }
        .detail-meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .detail-meta-item i {
            color: var(--accent-color);
        }
        .detail-image {
            width: 100%;
            max-height: 550px;
            object-fit: cover;
            border-radius: 20px;
            margin-bottom: 35px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
            border: 3px solid rgba(90, 47, 194, 0.1);
        }
        .detail-image-placeholder {
            width: 100%;
            height: 450px;
            background: var(--primary-color);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 5.5rem;
            margin-bottom: 35px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }
        .detail-body {
            font-size: 1.15rem;
            line-height: 1.9;
            color: #444;
            white-space: pre-wrap;
            word-wrap: break-word;
            padding: 25px;
            background: white;
            border-radius: 15px;
            border-left: 4px solid var(--primary-color);
        }
        .detail-footer {
            margin-top: 45px;
            padding-top: 30px;
            border-top: 3px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 25px;
        }
        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 14px 28px;
            background: var(--primary-color);
            color: white;
            text-decoration: none;
            border-radius: 30px;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 6px 20px rgba(90, 47, 194, 0.3);
        }
        .back-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(90, 47, 194, 0.4);
        }
        .back-button i {
            transition: transform 0.3s ease;
        }
        .back-button:hover i {
            transform: translateX(-3px);
        }
        .date-range {
            background: rgba(90, 47, 194, 0.08);
            padding: 20px 25px;
            border-radius: 15px;
            border-left: 5px solid var(--primary-color);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }
        .date-range strong {
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 8px;
        }
        .date-range strong i {
            color: var(--accent-color);
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

