<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Thêm Voucher</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/Views/css/voucherForm.css">
    <script src="${pageContext.request.contextPath}/Views/js/addVoucher.js" defer></script>
</head>
<body>
<div class="container">
    

    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>
    <c:if test="${not empty message}">
        <p class="message">${message}</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/voucher" method="post">
        <input type="hidden" name="action" value="add" />

        <label>Type:</label>
        <select name="type" required>
            <option value="percent">Percent (%)</option>
            <option value="fixed">Fixed (VND)</option>
            <option value="gift">Gift</option>
        </select>

        <label>Code (tùy chọn):</label>
        <input type="text" name="code" placeholder="Để trống để hệ thống tự sinh"/>

        <label>Value:</label>
        <input type="number" step="0.01" name="value" required/>

        <label>Valid From:</label>
        <input type="date" name="valid_from" required/>

        <label>Valid To:</label>
        <input type="date" name="valid_to" required/>

        <label>Usage Limit:</label>
        <input type="number" name="usage_limit" value="1"/>

        <label>Per User Limit:</label>
        <input type="number" name="per_user_limit" value="1"/>

        <input type="hidden" name="isActive" value="1"/>

        <button type="submit">Thêm</button>
    </form>
</div>
</body>
</html>
