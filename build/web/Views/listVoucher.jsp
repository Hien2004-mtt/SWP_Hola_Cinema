<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<h2>Danh sách Voucher</h2>
<a href="voucher?action=add">Thêm voucher mới</a>
<table border="1">
<tr><th>ID</th><th>Code</th><th>Loại</th><th>Giá trị</th><th>Ngày bắt đầu</th><th>Ngày kết thúc</th><th>Action</th></tr>
<c:forEach var="v" items="${list}">
<tr>
  <td>${v.voucherId}</td>
  <td>${v.code}</td>
  <td>${v.type}</td>
  <td>${v.value}</td>
  <td>${v.validFrom}</td>
  <td>${v.validTo}</td>
  <td><a href="${pageContext.request.contextPath}/voucher?action=delete&id=${v.voucherId}">
    Delete
</a>

</tr>
</c:forEach>
</table>
