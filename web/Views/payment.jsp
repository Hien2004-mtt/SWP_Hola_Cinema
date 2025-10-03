<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>



<html>
<head>
    <title>Thanh toán</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Views/payment.css" />
    <script src="${pageContext.request.contextPath}/Views/payment.js" defer></script>
</head>
<body>
<div class="container">
    <h2>Thanh toán đơn hàng</h2>

    <!-- Form apply voucher -->
    <form action="applyVoucher" method="post">

        <input type="hidden" name="bookingId" value="${bookingId}" />
        <input type="text" name="voucherCode" placeholder="Nhập mã voucher" />
        <button type="submit" class="btn-apply">Áp dụng voucher</button>
    </form>

    <!-- Tổng tiền -->
    <div class="total-box">
        <p><b>Tổng gốc:</b> ${originalTotal} VND</p>
        <p><b>Sau giảm:</b> ${discountedTotal} VND</p>
    </div>

    <!-- Form thanh toán -->
    <form action="checkout" method="post">

        <input type="hidden" name="orderId" value="<%=System.currentTimeMillis()%>" />
        <input type="hidden" name="orderInfo" value="Thanh toán đơn hàng HolaCinema" />
        <input type="hidden" name="amount" value="20000" />
        <input type="hidden" name="redirectUrl" value="http://localhost:9999/SWP_Hola_Cinema_1/return" />
        <input type="hidden" name="extraData" value="" />

        <button type="submit" name="method" value="momo" class="btn">
            <img src="${pageContext.request.contextPath}/folder/momo.png" alt="MoMo" style="height:20px; vertical-align:middle; margin-right:6px;">
            Thanh toán MoMo
        </button>

        <button type="submit" name="method" value="vnpay" class="btn">
            <img src="${pageContext.request.contextPath}/folder/vnpay.png" alt="VNPay" style="height:20px; vertical-align:middle; margin-right:6px;">
            Thanh toán VNPay
        </button>
    </form>

    <!-- Kết quả -->
    <c:if test="${page eq 'success'}">
        <h2 style="color:green;">${msg}</h2>
        <c:if test="${not empty qrText}">
            <p>Quét QR để xác nhận đơn hàng:</p>
            <img src="${pageContext.request.contextPath}/qrcode?text=${fn:escapeXml(qrText)}&size=260" alt="QR Code"/>
        </c:if>
    </c:if>

    <c:if test="${page eq 'fail'}">
        <h2 style="color:red;">${msg}</h2>
    </c:if>
</div>
</body>
</html>




