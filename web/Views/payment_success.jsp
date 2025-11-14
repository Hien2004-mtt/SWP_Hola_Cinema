<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thanh toán thành công</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <<link rel="stylesheet" href="../css/payment_success.css"/>
   
    
</head>

<body>
   
    <jsp:include page="/Inculude/Header.jsp" />

    <main>
        <div class="success-container">
            <div class="emoji">🎉</div>
            <h2>Thanh toán thành công!</h2>
            <p>Cảm ơn bạn đã đặt vé tại <b>Hola Cinema</b>.</p>
            <p>Vui lòng quét mã QR dưới đây để nhận vé tại quầy 🎟️</p>

            <img src="${pageContext.request.contextPath}/uploads/qrcode/${param.file}" alt="QR Code Vé" />

            <br>
            <a href="${pageContext.request.contextPath}/home" class="btn-home">🏠 Về trang chủ</a>
        </div>
    </main>

    <jsp:include page="/Inculude/Footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
