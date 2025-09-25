<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Profile</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f4; padding: 30px; }
        .container { background: #fff; max-width: 700px; margin: auto; padding: 25px;
                     border-radius: 6px; box-shadow: 0 0 5px rgba(0,0,0,0.1); }
        h2 { text-align: center; margin-bottom: 20px; }
        .row { margin-bottom: 15px; }
        .row label { display: block; font-weight: bold; margin-bottom: 5px; }
        .row input, .row select { width: 100%; padding: 6px; border: 1px solid #ccc; border-radius: 4px; }
        .row input[readonly] { background: #eee; }
        .actions { text-align: center; margin-top: 20px; }
        .actions input, .actions a { padding: 8px 16px; border: none; border-radius: 4px; text-decoration: none; }
        .btn-save { background: #007bff; color: white; }
        .btn-cancel { background: #ccc; color: black; margin-left: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Thông tin cá nhân</h2>
        <c:set var="po" value="${requestScope.user != null ? requestScope.user : sessionScope.user}"/>

        <!-- Nếu fix == null => chỉ xem -->
        <c:if test="${requestScope.fix == null}">
            <div class="row"><label>Họ tên:</label><p>${po.name}</p></div>
            <div class="row"><label>Email:</label><p>${po.email}</p></div>
            <div class="row"><label>Số điện thoại:</label><p>${po.phone}</p></div>
            <div class="row"><label>Giới tính:</label><p><c:out value="${po.gender ? 'Nam' : 'Nữ'}"/></p></div>
            <div class="row"><label>Username:</label><p>${po.username}</p></div>
            <div class="row"><label>Địa chỉ:</label><p>${po.address}</p></div>
            <div class="row"><label>Vai trò:</label><p>${po.role}</p></div>

            <div class="actions">
                <a href="updateUser?id=${po.userId}&fix=1" class="btn-save">Chỉnh sửa</a>
            </div>
        </c:if>

        <!-- Nếu fix != null => form edit -->
        <c:if test="${requestScope.fix != null}">
            <form action="updateUser" method="post">
                <input type="hidden" name="id" value="${po.userId}">

                <div class="row"><label>Họ tên:</label>
                    <input type="text" name="name" value="${po.name}">
                </div>

                <div class="row"><label>Email:</label>
                    <input type="text" name="email" value="${po.email}" readonly>
                </div>

                <div class="row"><label>Số điện thoại:</label>
                    <input type="text" name="phone" value="${po.phone}">
                </div>

                <div class="row"><label>Giới tính:</label>
                    <select name="gender">
                        <option value="true" <c:if test="${po.gender}">selected</c:if>>Nam</option>
                        <option value="false" <c:if test="${!po.gender}">selected</c:if>>Nữ</option>
                    </select>
                </div>

                <div class="row"><label>Username:</label>
                    <input type="text" name="username" value="${po.username}" readonly>
                </div>

                <!-- Đổi mật khẩu -->
                <div class="row"><label>Mật khẩu hiện tại:</label>
                    <input type="password" name="oldPassword">
                </div>
                <div class="row"><label>Mật khẩu mới:</label>
                    <input type="password" name="newPassword">
                </div>
                <div class="row"><label>Xác nhận mật khẩu mới:</label>
                    <input type="password" name="confirmPassword">
                </div>

              
                <div class="row"><label>Vai trò:</label>
                    <input type="text" value="${po.role}" readonly>
                </div>

                <div class="actions">
                    <input type="submit" value="Lưu thay đổi" class="btn-save">
                    <a href="profile?id=${po.userId}" class="btn-cancel">Hủy</a>
                </div>
            </form>
        </c:if>

        <!-- Thông báo -->
        <c:if test="${not empty requestScope.message}">
            <p style="color:green;text-align:center;">${requestScope.message}</p>
        </c:if>
        <c:if test="${not empty requestScope.error}">
            <p style="color:red;text-align:center;">${requestScope.error}</p>
        </c:if>
    </div>
</body>
</html>
