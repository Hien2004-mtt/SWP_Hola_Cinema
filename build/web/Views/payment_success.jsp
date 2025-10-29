<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
  <title>Thanh toán thành công</title>
</head>
<body>
  <h2 style="color:green;">🎉 Thanh toán thành công!</h2>
  <p>Cảm ơn bạn đã đặt vé tại HolaCinema.</p>
  <p>Quét mã QR dưới đây để nhận vé tại quầy.</p>
  <img src="${pageContext.request.contextPath}/uploads/qrcode/${param.file}" width="300" alt="QR Code Vé" />
  <br><br>
  <a href="${pageContext.request.contextPath}/home">Về trang chủ</a>
</body>
</html>
