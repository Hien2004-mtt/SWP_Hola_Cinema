<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>



<html>
<head>
  <meta charset="UTF-8">
  <title>Thanh toán</title>
</head>
<body>
  <h2>Thanh toán đơn hàng</h2>
  <form action="checkout" method="post">
      <input type="hidden" name="orderId" value="<%=System.currentTimeMillis()%>" />
      <input type="hidden" name="orderInfo" value="Thanh toán đơn hàng HolaCinema" />
      <input type="hidden" name="amount" value="10000" />
      <input type="hidden" name="redirectUrl" value="http://localhost:9999/SWP_Hola_Cinema/return" />
      <input type="hidden" name="ipnUrl" value="http://localhost:9999/SWP_Hola_Cinema/ipn" />
      <input type="hidden" name="extraData" value="" />

      
      <button type="submit" name="method" value="momo">Thanh toán MoMo</button>
      <button type="submit" name="method" value="vnpay">Thanh toán VNPay</button>
  </form>
</body>
</html>



