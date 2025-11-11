<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/TransactionHistory.css" />
<jsp:include page="/Inculude/Header.jsp" />

<div class="container mt-5 mb-5">
    <h2 class="mb-4 text-center">Lịch sử giao dịch</h2>
    <table class="table table-striped table-hover text-center align-middle">
        <thead class="table-dark">
            <tr>
                <th>Booking ID</th>
                <th>Movie</th>
                <th>Showtime</th>
                <th>Amount (VND)</th>
                <th>Method</th>
                <th>Status</th>
                <th>Paid At</th>
            </tr>
        </thead>
        <tbody>
        <c:forEach var="t" items="${transactions}">
            <tr>
                <td>${t.bookingId}</td>
                <td>${t.movieTitle}</td>
                <td><fmt:formatDate value="${t.startTime}" pattern="HH:mm dd/MM/yyyy"/></td>
                <td><fmt:formatNumber value="${t.amount}" type="number"/></td>
                <td>${t.method}</td>
                <td>
                    <c:choose>
                        <c:when test="${t.status eq 'success'}">
                            <span class="badge bg-success">Thành công</span>
                        </c:when>
                        <c:when test="${t.status eq 'failed'}">
                            <span class="badge bg-danger">Thất bại</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-warning text-dark">Đang xử lý</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td><fmt:formatDate value="${t.paidAt}" pattern="HH:mm dd/MM/yyyy"/></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<jsp:include page="/Inculude/Footer.jsp" />
