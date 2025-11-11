<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:useBean id="now" class="java.util.Date" />
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Danh sách Voucher</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/listVoucher.css">
    <script src="${pageContext.request.contextPath}/Views/js/listVoucher.js" defer></script>
</head>
<body>
    <jsp:include page="/Inculude/Header.jsp" />

    <div class="voucher-page container mt-4">
        <div class="top-bar">
           <c:if test="${sessionScope.user.role != 2}">
                <a href="${pageContext.request.contextPath}/voucher?action=add" class="btn-add">+ Thêm Voucher</a>
            </c:if>
        </div>

        <div id="msg" data-message="${message}" data-error="${error}" hidden></div>

        <div class="filter-bar">
            🔍 Tìm kiếm:
            <input type="text" id="searchInput" placeholder="Nhập từ khóa...">
            <label for="sortColumn" hidden>Sắp xếp theo:</label>
            <select id="sortColumn" >
                <option value="0">ID</option>
                <option value="1">Code</option>
                <option value="2">Loại</option>
                <option value="3">Giá trị</option>
                <option value="4">Ngày bắt đầu</option>
                <option value="5">Ngày kết thúc</option>
            </select>
            <select id="sortOrder" >
                <option value="asc">️Tăng dần</option>
                <option value="desc">️Giảm dần</option>
            </select>
        </div>

        <table id="voucherTable">
            <thead>
  <tr>
    <th data-index="0">ID</th>
    <th data-index="1">Code</th>
    <th data-index="2">Loại</th>
    <th data-index="3">Giá trị</th>
    <th data-index="4">Bắt đầu</th>
    <th data-index="5">Kết thúc</th>
    <th data-index="6">Usage</th>
    <th data-index="7">Per User</th>
    <th data-index="8">Trạng thái</th>
    <c:if test="${sessionScope.user.role != 2}">
      <th data-index="9">Hành động</th>
    </c:if>
  </tr>
</thead>
            <tbody>
                <c:forEach var="v" items="${list}">
                    <tr>
                        <td>${v.voucherId}</td>
                        <td>${v.code}</td>
                        <td>
                            <c:choose>
                                <c:when test="${v.type == 'percent'}">%</c:when>
                                <c:when test="${v.type == 'fixed'}">VNĐ</c:when>
                                <c:otherwise>${v.type}</c:otherwise>
                            </c:choose>
                        </td>
                        <td>${v.value}</td>
                        <td>${v.validFrom}</td>
                        <td>${v.validTo}</td>
                        <td>${v.usageLimit}</td>
                        <td>${v.perUserLimit}</td>
                        <td>
                            <c:choose>
                                <c:when test="${v.isActive}">
                                    <span style="color:green; font-weight:bold;">Kích hoạt</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="color:red; font-weight:bold;">Vô hiệu</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:if test="${sessionScope.user.role != 2}">
                                <a href="${pageContext.request.contextPath}/voucher?action=edit&id=${v.voucherId}" class="btn btn-edit">✏️ Sửa</a>
                                <c:if test="${v.isActive}">
                                    <a href="${pageContext.request.contextPath}/voucher?action=delete&id=${v.voucherId}" class="btn btn-disable">Vô hiệu</a>
                                </c:if>
                                <c:if test="${!v.isActive}">
                    <c:if test="${v.validTo.time > now.time and v.usageLimit > 0 and v.perUserLimit > 0}">
                    <a href="${pageContext.request.contextPath}/voucher?action=activate&id=${v.voucherId}"
                        class="btn btn-activate">Kích hoạt</a>
                        </c:if>
                                </c:if>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <div class="pagination">
    <c:forEach begin="1" end="${totalPages}" var="i">
        <c:choose>
            <c:when test="${i == currentPage}">
                <span class="page active">${i}</span>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/voucher?action=list&page=${i}" class="page">${i}</a>
            </c:otherwise>
        </c:choose>
    </c:forEach>
</div>
    </div>

    <jsp:include page="/Inculude/Footer.jsp" />
</body>
</html>

