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
<form action="${pageContext.request.contextPath}/voucher" method="post">
    <input type="hidden" name="action" value="add" />
    Code: <input type="text" name="code" required/><br/>
    Type: 
    <select name="type">
        <option value="percent">Percent (%)</option>
        <option value="fixed">Fixed (VND)</option>
        <option value="gift">Gift</option>
    </select><br/>
    Value: <input type="number" step="0.01" name="value" required/><br/>
    Valid From: <input type="date" name="validFrom" required/><br/>
    Valid To: <input type="date" name="validTo" required/><br/>
    Usage Limit: <input type="number" name="usageLimit" value="1"/><br/>
    Per User Limit: <input type="number" name="perUserLimit" value="1"/><br/>
    <button type="submit">Thêm</button>
</form>


</html>
