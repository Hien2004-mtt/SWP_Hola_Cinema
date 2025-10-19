<%-- 
    Document   : register
    Created on : Sep 24, 2025, 3:26:44 PM
    Author     : dinhh
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Register</title>
</head>
<body>
<h2>Register</h2>
<form action="register" method="post">
    Email: <input type="email" name="email" required><br>
    Password: <input type="password" name="password" required><br>
    Full Name: <input type="text" name="name" required><br>
    Phone: <input type="tel" name="phone" pattern="[0-9]{9,11}" required /><br>
    Date of Birth: <input type="date" name="dob"><br>
    Gender:
    <input type="radio" name="gender" value="1" checked> Male
    <input type="radio" name="gender" value="0"> Female<br>
    <button type="submit">Register</button>
</form>

<% if (request.getParameter("error") != null) { %>
    <p style="color:red;">Register failed! Try again.</p>
<% } %>
</body>
</html>
