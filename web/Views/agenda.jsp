<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Lịch Chiếu Phim - Hola Cinema</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/agenda.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>

    </style>
</head>
<body>
        <%@ include file="../manager/sidebar.jsp" %>
        <jsp:include page="/Inculude/Header.jsp" />

    <div class="agenda-wrapper">
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
                <form method="get" action="agenda" style="margin:0;">
                    <input type="hidden" name="startDate" value="${prevStartDate}" />
                    <button type="submit" style="background:none;border:none;font-size:22px;cursor:pointer;">
                        <i class="fas fa-chevron-left"></i>
                    </button>
                </form>
                <div style="font-weight:bold; font-size:18px; margin: 0 18px;">
                    <c:out value="${dates[0]}"/> - <c:out value="${dates[6]}"/>
                </div>
                <form method="get" action="agenda" style="margin:0;">
                    <input type="hidden" name="startDate" value="${nextStartDate}" />
                    <button type="submit" style="background:none;border:none;font-size:22px;cursor:pointer;">
                        <i class="fas fa-chevron-right"></i>
                    </button>
                </form>
            </div>
            <div style="overflow-x:auto;">
                <table class="cinema-table">
                    <thead>
                        <tr>
                            <c:forEach var="date" items="${dates}">
                                <th><c:out value="${date}"/></th>
                            </c:forEach>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="time" items="${times}">
                            <tr>
                                <c:forEach var="date" items="${dates}">
                                    <td>
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
