<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Danh sách Voucher</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Views/css/listVoucher.css">
    <script src="${pageContext.request.contextPath}/Views/listVoucher.js" defer></script>
</head>
<body>

<div class="top-bar">
    <h2>️ Danh sách Voucher</h2>
    <a href="${pageContext.request.contextPath}/voucher?action=add" class="btn-add">+ Thêm Voucher</a>
</div>

<!-- Container lưu message để JS đọc -->
<div id="msg" data-message="${message}" data-error="${error}" hidden></div>

<table>
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
        <th>Hành động</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="v" items="${list}">
        <tr>
            <td>${v.voucherId}</td>
            <td>${v.code}</td>
            <td>${v.type}</td>
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
                <a href="${pageContext.request.contextPath}/voucher?action=edit&id=${v.voucherId}" class="btn btn-edit">✏️ Sửa</a>
                <c:choose>
                    <c:when test="${v.isActive}">
                        <a href="${pageContext.request.contextPath}/voucher?action=delete&id=${v.voucherId}" class="btn btn-disable">⛔ Vô hiệu</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/voucher?action=activate&id=${v.voucherId}" class="btn btn-activate">✅ Kích hoạt</a>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

</body>
</html>
