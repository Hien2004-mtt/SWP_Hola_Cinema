<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<h2>Cập nhật Voucher</h2>
<script src="${pageContext.request.contextPath}/Views/js/addVoucher.js" defer></script>

<form action="${pageContext.request.contextPath}/voucher" method="post">
    <input type="hidden" name="action" value="update" />
    <input type="hidden" name="voucher_id" value="${voucher.voucherId}" />

    Code: <b>${voucher.code}</b><br/>
    Type:
    <select name="type">
        <option value="percent" ${voucher.type == 'percent' ? 'selected' : ''}>Percent (%)</option>
        <option value="fixed" ${voucher.type == 'fixed' ? 'selected' : ''}>Fixed (VND)</option>
        <option value="gift" ${voucher.type == 'gift' ? 'selected' : ''}>Gift</option>
    </select><br/>

    Value: <input type="number" step="0.01" name="value" value="${voucher.value}" /><br/>
    Valid From: <input type="date" name="valid_from" value="${voucher.validFrom}" /><br/>
    Valid To: <input type="date" name="valid_to" value="${voucher.validTo}" /><br/>
    Usage Limit: <input type="number" name="usage_limit" value="${voucher.usageLimit}" /><br/>
    Per User Limit: <input type="number" name="per_user_limit" value="${voucher.perUserLimit}" /><br/>

    <button type="submit">Lưu cập nhật</button>
</form>
