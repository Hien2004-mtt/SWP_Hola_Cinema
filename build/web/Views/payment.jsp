<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<html>
<head>
    <title>Thanh toán - HolaCinema</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/Views/css/payment.css" />
    <script src="${pageContext.request.contextPath}/Views/js/payment.js" defer></script>
</head>

<body>
<div class="container">
    <h2>💳 Thanh toán đơn hàng</h2>

    <!--  Thông tin vé -->
    <div class="ticket-box">
        <h3>️ Thông tin vé</h3>
        <table class="ticket-table">
            <tr><th>Mã đặt vé:</th><td>${booking_id}</td></tr>
<tr><th>Khách hàng:</th><td>${customer_name}</td></tr>
<tr><th>Phim:</th><td>${movie_title}</td></tr>
<tr><th>Phòng chiếu:</th><td>${auditorium_name}</td></tr>
<tr><th>Ghế:</th>
  <td>
    <c:forEach var="s" items="${seat_code}" varStatus="loop">
    ${s}<c:if test="${!loop.last}">, </c:if>
</c:forEach>
  </td>
</tr>
<tr><th>Suất chiếu:</th>
  <td><fmt:formatDate value="${start_time}" pattern="HH:mm dd/MM/yyyy"/></td>
</tr>

        </table>
    </div>

    <!-- ✅ Form áp dụng voucher -->
    <form id="voucherForm" action="${pageContext.request.contextPath}/applyVoucher" method="post" style="margin-top:20px;">
        <input type="hidden" name="bookingId" value="${bookingInfo.booking_id}" />
        <label for="voucherCode"><b>🎁 Mã giảm giá:</b></label>
        <input type="text" id="voucherCode" name="voucherCode" placeholder="Nhập mã voucher..." />
        <button type="submit" class="btn-apply">Áp dụng</button>
    </form>

    <!-- ✅ Hiển thị tổng tiền -->
    <div class="total-box">
        <p><b>Tổng gốc:</b> <fmt:formatNumber value="${total_price}" type="number"/> VND</p>
        <p><b>Sau giảm:</b>
            <fmt:formatNumber value="${discountedTotal != null ? discountedTotal : total_price}" type="number" /> VND
        </p>
        <c:if test="${not empty msg}">
    <div class="alert ${msgType == 'error' ? 'alert-error' : 'alert-success'}">
        ${msg}
    </div>
</c:if>
    </div>

    <!-- ✅ Form chọn phương thức thanh toán -->
    <form action="${pageContext.request.contextPath}/checkout" method="post" class="pay-form">
        <input type="hidden" name="bookingId" value="${bookingInfo.booking_id}" />
        <%
    // Tạo mã đặt vé ngắn gọn, 9 chữ số ngẫu nhiên
    String orderId = String.valueOf((int)(Math.random() * 900000000) + 100000000);
%>
<input type="hidden" name="orderId" value="<%=orderId%>" />
        <input type="hidden" name="orderInfo" value="Thanh toán vé HolaCinema - Booking #${bookingInfo.booking_id}" />
        <input type="hidden" name="amount"
       value="${discountedTotal != null ? discountedTotal : total_price}" />
        <input type="hidden" name="redirectUrl" value="http://localhost:9999/SWP_Hola_Cinema_1/return" />
        <input type="hidden" name="extraData" value="" />

        <h3>🔰 Chọn phương thức thanh toán:</h3>
        <button type="submit" name="method" value="momo" class="btn">
            <img src="${pageContext.request.contextPath}/folder/momo.png" alt="MoMo"
                 style="height:20px; vertical-align:middle; margin-right:6px;">
            Thanh toán MoMo
        </button>
        <button type="submit" name="method" value="vnpay" class="btn">
            <img src="${pageContext.request.contextPath}/folder/vnpay.png" alt="VNPay"
                 style="height:20px; vertical-align:middle; margin-right:6px;">
            Thanh toán VNPay
        </button>
    </form>

    <!-- ✅ Hiển thị kết quả QR -->
    <div id="resultBox" style="display:none; margin-top:20px;">
        <h3 id="statusMsg"></h3>
        <img id="qrImg" src="" alt="QR Code" style="display:none; width:250px; margin-top:10px;">
    </div>
</div>

</body>
</html>
