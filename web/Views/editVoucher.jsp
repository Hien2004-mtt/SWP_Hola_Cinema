<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
<h2>Cập nhật Voucher</h2>
<script src="${pageContext.request.contextPath}/Views/js/addVoucher.js" defer></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/voucherForm.css">
</head>
<body>
    <jsp:include page="/Inculude/Header.jsp" />
<div class="container">
    

    <form action="${pageContext.request.contextPath}/voucher" method="post">
        <input type="hidden" name="action" value="update" />
        <input type="hidden" name="voucher_id" value="${voucher.voucherId}" />

        <label>Code:</label>
        <b style="color:#ff80ab">${voucher.code}</b><br/><br/>

        <label>Type:</label>
        <select name="type">
            <option value="percent" ${voucher.type == 'percent' ? 'selected' : ''}>Percent (%)</option>
            <option value="fixed" ${voucher.type == 'fixed' ? 'selected' : ''}>Fixed (VND)</option>
            <option value="gift" ${voucher.type == 'gift' ? 'selected' : ''}>Gift</option>
        </select>

        <label>Value:</label>
        <input type="number" step="0.01" name="value" value="${voucher.value}" />

        <label>Valid From:</label>
        <input type="date" name="valid_from" value="${voucher.validFrom}" />

        <label>Valid To:</label>
        <input type="date" name="valid_to" value="${voucher.validTo}" />

        <label>Usage Limit:</label>
        <input type="number" name="usage_limit" value="${voucher.usageLimit}" />

        <label>Per User Limit:</label>
        <input type="number" name="per_user_limit" value="${voucher.perUserLimit}" />

        <button type="submit">Lưu cập nhật</button>
    </form>
</div>
        <jsp:include page="/Inculude/Footer.jsp" />
</body>
</html>