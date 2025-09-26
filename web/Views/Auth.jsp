<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register / Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .tab-container {
            width: 400px;
            margin: 50px auto;
            border: 1px solid #ccc;
            border-radius: 5px;
            overflow: hidden;
        }
        .tab-header {
            display: flex;
            cursor: pointer;
        }
        .tab-header div {
            flex: 1;
            text-align: center;
            padding: 12px;
            background: #f2f2f2;
            border-bottom: 2px solid transparent;
            transition: 0.3s;
        }
        .tab-header div.active {
            background: #fff;
            border-bottom: 2px solid #007bff;
            font-weight: bold;
        }
        .tab-content {
            padding: 20px;
            display: none;
        }
        .tab-content.active {
            display: block;
        }
        .error {
            color: red;
            font-size: 0.9em;
        }
    </style>
</head>
<body>

<div class="tab-container">
    <div class="tab-header">
        <div id="tab-register" class="active" onclick="showTab('register')">Đăng ký</div>
        <div id="tab-login" onclick="showTab('login')">Đăng nhập</div>
    </div>

    <div id="register" class="tab-content active">
        <h2>Register</h2>
        <form id="registerForm" action="${pageContext.request.contextPath}/Register" method="post" onsubmit="return validatePassword()">
            <label>Name:</label>
            <input type="text" name="name" required><br><br>

            <label>Email:</label>
            <input type="email" name="email" required><br><br>

            <label>Password:</label>
            <input type="password" id="password" name="password" required><br>
            <span id="passwordError" class="error"></span><br>

            <label>Phone:</label>
            <input type="text" name="phone"><br><br>

            <label>Date of Birth:</label>
            <input type="date" name="dob"><br><br>

            <label>Gender:</label>
            <select name="gender">
                <option value="Male">Male</option>
                <option value="Female">Female</option>
            </select><br><br>

            <input type="submit" value="Register">
        </form>
    </div>

    <div <div id="login" class="tab-content">
    <c:if test="${not empty loginError}">
        <p class="error">${loginError}</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/Login" method="post">
        <label>Phone:</label>
        <input type="text" name="phone" required><br><br>

        <label>Password:</label>
        <input type="password" name="password" required><br><br>

        <input type="submit" value="Login">
    </form>
    </div>
</div>

<script>
function showTab(tab) {
    // reset active header
    document.getElementById("tab-register").classList.remove("active");
    document.getElementById("tab-login").classList.remove("active");

    // reset content
    document.getElementById("register").classList.remove("active");
    document.getElementById("login").classList.remove("active");

    // set active cho tab đang chọn
    document.getElementById(tab).classList.add("active");
    document.getElementById("tab-" + tab).classList.add("active");
}

function validatePassword() {
    const password = document.getElementById("password").value;
    const errorSpan = document.getElementById("passwordError");
    const regex = /^(?=.*[A-Z])(?=.*\d).{6,}$/;

    if (!regex.test(password)) {
        errorSpan.textContent = "Password ≥ 6 ký tự, chứa ít nhất 1 chữ hoa và 1 số.";
        return false;
    } else {
        errorSpan.textContent = "";
        return true;
    }
}
</script>

</body>
</html>
