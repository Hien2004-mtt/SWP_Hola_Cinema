<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<jsp:useBean id="now" class="java.util.Date" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách Voucher</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/listVoucher.css">
    <script src="${pageContext.request.contextPath}/Views/js/listVoucher.js" defer></script>
</head>

<body>
<div class="header">
            <%@ include file="/Inculude/Header.jsp" %>
        </div>
    <!-- ============================
         1. SIDEBAR CỐ ĐỊNH BÊN TRÁI
         ============================ -->
    <div class="sidebar">
        <c:if test="${sessionScope.user.role != 2}">
            <%@ include file="../manager/sidebar.jsp" %>
        </c:if>
    </div>

    <!-- ============================
         2. KHỐI BÊN PHẢI (Header + Content + Footer)
         ============================ -->
    <div class="main-panel">

        <!-- 🔹 HEADER -->
        

        <!-- 🔹 CONTENT -->
        <div class="content-wrapper">

            <div class="voucher-page">

                <!-- Top bar -->
                <div class="top-bar">
                    <c:if test="${sessionScope.user.role != 2}">
                        <a href="${pageContext.request.contextPath}/voucher?action=add" class="btn-add">+ Thêm Voucher</a>
                    </c:if>
                </div>

                <!-- Filter -->
                <div class="filter-bar">

                    <form id="searchForm" method="get" action="voucher" style="display:flex; align-items:center; gap:10px;">
                        <input type="hidden" name="action" value="list">
                        🔍 Tìm kiếm:
                        <input type="text" name="q" id="searchInput" placeholder="Nhập từ khóa..." value="${param.q}">
                        <button type="submit">Tìm</button>
                    </form>

                    <label>Sắp xếp theo:</label>
                    <form id="sortForm" method="get" action="voucher">
                        <input type="hidden" name="action" value="list">

                        <select name="sortColumn" id="sortColumn">
                            <option value="voucher_id" ${sortColumn == 'voucher_id' ? 'selected' : ''}>ID</option>
                            <option value="code" ${sortColumn == 'code' ? 'selected' : ''}>Code</option>
                            <option value="type" ${sortColumn == 'type' ? 'selected' : ''}>Loại</option>
                            <option value="value" ${sortColumn == 'value' ? 'selected' : ''}>Giá trị</option>
                            <option value="valid_from" ${sortColumn == 'valid_from' ? 'selected' : ''}>Bắt đầu</option>
                            <option value="valid_to" ${sortColumn == 'valid_to' ? 'selected' : ''}>Kết thúc</option>
                        </select>

                        <select name="sortOrder" id="sortOrder">
                            <option value="asc" ${sortOrder == 'asc' ? 'selected' : ''}>Tăng dần</option>
                            <option value="desc" ${sortOrder == 'desc' ? 'selected' : ''}>Giảm dần</option>
                        </select>

                        <button type="submit">Sắp xếp</button>
                    </form>
                </div>

                <!-- Table -->
                <table id="voucherTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Code</th>
                            <th>Loại</th>
                            <th>Giá trị</th>
                            <th>Bắt đầu</th>
                            <th>Kết thúc</th>
                            <th>Usage</th>
                            <th>Per User</th>
                            <th>Trạng thái</th>
                            <c:if test="${sessionScope.user.role != 2}">
                                <th>Hành động</th>
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
                                            <span class="status-active">Kích hoạt</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-inactive">Vô hiệu</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <c:if test="${sessionScope.user.role != 2}">
                                        <a href="voucher?action=edit&id=${v.voucherId}" class="btn btn-edit">Sửa</a>
                                        <c:if test="${v.isActive}">
                                            <a href="voucher?action=delete&id=${v.voucherId}" class="btn btn-disable">Vô hiệu</a>
                                        </c:if>

                                        <c:if test="${!v.isActive && v.validTo.time > now.time && v.usageLimit > 0 && v.perUserLimit > 0}">
                                            <a href="voucher?action=activate&id=${v.voucherId}" class="btn btn-activate">Kích hoạt</a>
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
                                <a href="${pageContext.request.contextPath}/voucher?action=list&page=${i}&sortColumn=${sortColumn}&sortOrder=${sortOrder}" class="page">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>

            </div> <!-- end voucher-page -->

        </div> <!-- end content-wrapper -->

        <!-- 🔹 FOOTER -->
        <div class="footer">
            <%@ include file="/Inculude/Footer.jsp" %>
        </div>

    </div> <!-- end main-panel -->

</body>
</html>
