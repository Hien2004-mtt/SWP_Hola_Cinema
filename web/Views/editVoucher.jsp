<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Cập nhật Voucher</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/voucherForm.css">
    <script src="${pageContext.request.contextPath}/Views/js/addVoucher.js" defer></script>
</head>

<body>

    <!-- Sidebar trái -->
    <div class="sidebar">
        <%@ include file="../manager/sidebar.jsp" %>
    </div>

    <!-- Panel phải -->
    <div class="main-panel">

        <!-- Header -->
        <div class="header">
            <%@ include file="/Inculude/Header.jsp" %>
        </div>

        <!-- Content -->
        <div class="content-wrapper">

            <div class="voucher-form-box">
                <h2>Cập nhật Voucher</h2>

                <form action="${pageContext.request.contextPath}/voucher" method="post">

                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="voucher_id" value="${voucher.voucherId}">

                    <label>Code:</label>
                    <p style="font-weight:bold; color:#d81b60;">${voucher.code}</p>

                    <label>Type:</label>
                    <select name="type">
                        <option value="percent" ${voucher.type == 'percent' ? 'selected' : ''}>Percent (%)</option>
                        <option value="fixed" ${voucher.type == 'fixed' ? 'selected' : ''}>Fixed (VND)</option>
                        <option value="gift" ${voucher.type == 'gift' ? 'selected' : ''}>Gift</option>
                    </select>

                    <label>Value:</label>
                    <input type="number" step="0.01" name="value" value="${voucher.value}">

                    <label>Valid From:</label>
                    <input type="date" name="valid_from" value="${voucher.validFrom}">

                    <label>Valid To:</label>
                    <input type="date" name="valid_to" value="${voucher.validTo}">

                    <label>Usage Limit:</label>
                    <input type="number" name="usage_limit" value="${voucher.usageLimit}">

                    <label>Per User Limit:</label>
                    <input type="number" name="per_user_limit" value="${voucher.perUserLimit}">

                    <button type="submit">Lưu thay đổi</button>
                </form>

            </div>

        </div>

        <!-- Footer -->
        <div class="footer">
            <%@ include file="/Inculude/Footer.jsp" %>
        </div>

    </div>

</body>
</html>
