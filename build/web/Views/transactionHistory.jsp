<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/TransactionHistory.css" />
<jsp:include page="/Inculude/Header.jsp" />

<div class="container mt-5 mb-5">
    <h2 class="mb-4 text-center"> Lịch sử giao dịch</h2>

    <!-- Bộ lọc -->
    <form method="get" action="${pageContext.request.contextPath}/transactionHistory" class="filter-bar mb-3">
        <label><b>Lọc theo thời gian:</b></label>
        <select name="timeFilter">
            <option value="all" ${timeFilter == 'all' ? 'selected' : ''}>Tất cả</option>
            <option value="today" ${timeFilter == 'today' ? 'selected' : ''}>Hôm nay</option>
            <option value="week" ${timeFilter == 'week' ? 'selected' : ''}>7 ngày qua</option>
            <option value="month" ${timeFilter == 'month' ? 'selected' : ''}>30 ngày qua</option>
        </select>

        <label><b>Sắp xếp:</b></label>
        <select name="sortOrder">
            <option value="desc" ${sortOrder == 'desc' ? 'selected' : ''}>Mới nhất</option>
            <option value="asc" ${sortOrder == 'asc' ? 'selected' : ''}>Cũ nhất</option>
        </select>

        <button type="submit" class="btn btn-primary">Lọc</button>
    </form>

    <!-- Bảng -->
    <table class="table table-striped text-center align-middle">
        <thead class="table-dark">
            <tr>
                <th>Booking ID</th>
                <th>Phim</th>
                <th>Suất chiếu</th>
                <th>Số tiền (VND)</th>
                <th>Phương thức</th>
                <th>Trạng thái</th>
                <th>Thanh toán</th>
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

    <!-- Phân trang -->
    <div class="pagination">
        <c:forEach begin="1" end="${totalPages}" var="i">
            <c:choose>
                <c:when test="${i == currentPage}">
                    <span class="page active">${i}</span>
                </c:when>
                <c:otherwise>
                    <a href="transaction-history?page=${i}&timeFilter=${timeFilter}&sortOrder=${sortOrder}" class="page">${i}</a>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </div>
</div>

<jsp:include page="/Inculude/Footer.jsp" />
