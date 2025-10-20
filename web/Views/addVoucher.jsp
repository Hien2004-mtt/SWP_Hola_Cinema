<%-- 
    Document   : addVoucher
    Created on : Sep 29, 2025, 11:07:44 AM
    Author     : dhnga
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <h2>Thêm Voucher mới</h2>
    <c:if test="${not empty error}">
    <p style="color:red; font-weight:bold;">${error}</p>
    <c:if test="${not empty message}">
    <p style="color:green; font-weight:bold;">${message}</p>
</c:if>
    
</c:if>
    <script src="${pageContext.request.contextPath}/Views/js/addVoucher.js" defer></script>
<form action="${pageContext.request.contextPath}/voucher" method="post">
    <input type="hidden" name="action" value="add" />

    Type:
    <select name="type" required>
        <option value="percent">Percent (%)</option>
        <option value="fixed">Fixed (VND)</option>
        <option value="gift">Gift</option>
    </select><br/>
     Code (tùy chọn): <input type="text" name="code" placeholder="Để trống để hệ thống tự sinh"/><br/>

    Value: <input type="number" step="0.01" name="value" required/><br/>
    Valid From: <input type="date" name="valid_from" required/><br/>
    Valid To: <input type="date" name="valid_to" required/><br/>
    Usage Limit: <input type="number" name="usage_limit" value="1"/><br/>
    Per User Limit: <input type="number" name="per_user_limit" value="1"/><br/>
     <input type = "hidden" name ="isActive" value ="1"/><br/>

    <button type="submit">Thêm</button>
    

</form>


</html>
