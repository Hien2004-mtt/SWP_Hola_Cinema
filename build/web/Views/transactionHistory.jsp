<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/TransactionHistory.css" />
<jsp:include page="/Inculude/Header.jsp" />

<div class="container mt-5 mb-5">
    <h2 class="mb-4 text-center">Lịch sử giao dịch</h2>

    <!-- 🔍 Bộ lọc tìm kiếm & sắp xếp -->
    <div class="filter-bar mb-3">
        🔍 <b>Tìm kiếm:</b>
        <input type="text" id="searchInput" placeholder="Nhập từ khóa...">

        <label for="sortColumn">Sắp xếp theo:</label>
        <select id="sortColumn">
            <option value="0">Booking ID</option>
            <option value="1">Phim</option>
            <option value="2">Suất chiếu</option>
            <option value="3">Số tiền</option>
            <option value="4">Phương thức</option>
            <option value="5">Trạng thái</option>
            <option value="6">Thời gian thanh toán</option>
        </select>

        <select id="sortOrder">
            <option value="asc">Tăng dần</option>
            <option value="desc">Giảm dần</option>
        </select>
    </div>

    <table id="transactionTable" class="table table-striped table-hover text-center align-middle">
        <thead class="table-dark">
            <tr>
                <th data-index="0">Booking ID</th>
                <th data-index="1">Movie</th>
                <th data-index="2">Showtime</th>
                <th data-index="3">Amount (VND)</th>
                <th data-index="4">Method</th>
                <th data-index="5">Status</th>
                <th data-index="6">Paid At</th>
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

    <!-- 📄 Phân trang -->
    <div class="pagination"></div>
</div>

<jsp:include page="/Inculude/Footer.jsp" />
<script src="${pageContext.request.contextPath}/Views/js/transactionHistory.js" defer></script>
