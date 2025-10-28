<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch Chiếu Phim - Hola Cinema</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Views/css/schedule.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .agenda-content {
            margin-left: 250px;
            padding: 32px;
            background: #fff;
            border-radius: 16px;
            box-shadow: 0 4px 24px rgba(0,0,0,0.07);
        }
        .cinema-table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 14px;
            font-family: 'Segoe UI', Arial, sans-serif;
            font-size: 15px;
            overflow: hidden;
        }
        .cinema-table th {
            background: linear-gradient(90deg,#e0eafc 0%,#cfdef3 100%);
            color: #222;
            font-weight: 700;
            padding: 14px 0;
            border: 1px solid #eaeaea;
            font-size: 17px;
            text-align: center;
            border-radius: 0 0 10px 10px;
            box-shadow: 0 2px 8px rgba(120,160,255,0.08);
            letter-spacing: 1px;
        }
        .cinema-table td {
            padding: 12px 8px;
            border: 1px solid #eaeaea;
            vertical-align: top;
            background: #fcfcfc;
            border-radius: 6px;
            transition: background 0.2s, box-shadow 0.2s;
            text-align: center;
        }
        .cinema-table tr:last-child td {
            border-bottom: 1px solid #eaeaea;
        }
        .cinema-table td:hover {
            background: #eaf4ff;
            box-shadow: 0 2px 12px rgba(76,110,245,0.10);
        }
        .show-block {
            color: #222;
            margin-bottom: 4px;
            border-radius: 8px;
            padding: 7px 12px;
            font-size: 15px;
            font-family: 'Segoe UI', Arial, sans-serif;
            box-shadow: 0 1px 6px rgba(120,160,255,0.07);
        }
        .show-block.upcoming {
            background: #ffe066; /* vàng */
        }
        .show-block.past {
            background: #b6fcb6; /* xanh lá nhạt */
        }
        .show-block b {
            color: #1a202c;
            font-size: 15px;
        }
        .show-block span {
            color: #555;
            font-size: 13px;
        }
        @media (max-width: 900px) {
            .agenda-content { margin-left: 0; padding: 8px; }
            .cinema-table { font-size: 13px; }
            .cinema-table th { font-size: 13px; }
            .show-block { font-size: 12px; padding: 5px 6px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="sidebar">
            <h2>Menu</h2>
            <nav>
                <a href="${pageContext.request.contextPath}/agenda" class="active">
                    <i class="fas fa-calendar-alt" style="margin-right:8px;"></i> Lịch Chiếu Phim
                </a>
                <a href="${pageContext.request.contextPath}/manageSchedule">
                    <i class="fas fa-cogs" style="margin-right:8px;"></i> Quản Lý Lịch Chiếu
                </a>
            </nav>
        </div>
        <div class="agenda-content">
            <h1><i class="fas fa-calendar-alt"></i> Lịch Chiếu Phim</h1>
            <div style="text-align:center; margin-bottom:8px;">
                <span style="font-weight:bold; display:inline-block; background:#b6fcb6; color:#222; border-radius:12px; padding:4px 14px; font-size:14px; border:1px solid #98fb98;">
                    <i class="fas fa-history"></i> Xanh lá: Đã chiếu
                </span>
                <span style="font-weight:bold; display:inline-block; background:#ffe066; color:#222; border-radius:12px; padding:4px 14px; margin-right:10px; font-size:14px; border:1px solid #ffe58f;">
                    <i class="fas fa-clock"></i> Màu vàng: Sắp chiếu
                </span>
            </div>
            <div style="display: flex; align-items: center; justify-content: center; margin-bottom: 16px;">
                    <div style="width:100%; display:flex; flex-direction:column; align-items:center; gap:8px;">
                        <form method="get" action="agenda" style="margin:0; display:flex; align-items:center; gap:12px;">
                            <button type="submit" name="startDate" value="${prevStartDate}" style="background:none;border:none;font-size:22px;cursor:pointer;">
                                <i class="fas fa-chevron-left"></i>
                            </button>
                            <div style="font-weight:bold; font-size:18px; margin: 0 18px;">
                                <c:out value="${dates[0]}"/> - <c:out value="${dates[6]}"/>
                            </div>
                            <button type="submit" name="startDate" value="${nextStartDate}" style="background:none;border:none;font-size:22px;cursor:pointer;">
                                <i class="fas fa-chevron-right"></i>
                            </button>
                        </form>
                        <form method="get" action="agenda" style="margin:0; display:flex; align-items:center; gap:12px;">
                            <span style="font-size:15px;">Chọn ngày cụ thể:</span>
                            <input type="date" name="specificDate" value="${param.specificDate}" style="padding:4px 10px; border-radius:8px; border:1px solid #ccc; font-size:15px;" />
                            <button type="submit" style="border-radius:8px; padding:4px 14px; font-weight:600; background:#007bff; color:#fff; border:none;">Xem lịch</button>
                            <c:if test="${not empty param.specificDate}">
                                <button type="button" onclick="window.location.href='agenda'" style="border-radius:8px; padding:4px 14px; font-weight:600; background:#e74c3c; color:#fff; border:none;">Xóa tìm kiếm</button>
                            </c:if>
                        </form>
                    </div>
            </div>
            <div style="overflow-x:auto;">
                <table class="cinema-table">
                    <thead>
                            <tr>
                                <c:forEach var="date" items="${dates}">
                                    <th
                                        <c:if test="${not empty param.specificDate && date == param.specificDate}">
                                            style="background:#007bff; color:#fff; font-weight:bold; border:2px solid #007bff;"
                                        </c:if>
                                    >
                                        <c:out value="${date}"/>
                                    </th>
                                </c:forEach>
                            </tr>
                    </thead>
                    <tbody>
                            <c:forEach var="time" items="${times}">
                                <tr>
                                    <c:forEach var="date" items="${dates}">
                                        <td
                                            <c:if test="${not empty param.specificDate && date == param.specificDate}">
                                                style="background:#007bff; color:#fff; font-weight:bold; border:2px solid #007bff;"
                                            </c:if>
                                        >
                                            <c:forEach var="show" items="${scheduleMap[date][time]}">
                                                <c:set var="endMillis" value="${show.endTime.time}" />
                                                <c:choose>
                                                    <c:when test="${endMillis > now}">
                                                        <div class="show-block upcoming">
                                                            <b>${show.movieName}</b> <br> <span>(${show.auditoriumName})</span>
                                                            <span>${show.startTime.toLocalDateTime().toLocalTime()} - ${show.endTime.toLocalDateTime().toLocalTime()}</span>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="show-block past">
                                                            <b>${show.movieName}</b> <br> <span>(${show.auditoriumName})</span>
                                                            <span>${show.startTime.toLocalDateTime().toLocalTime()} - ${show.endTime.toLocalDateTime().toLocalTime()}</span>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </td>
                                    </c:forEach>
                                </tr>
                            </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
