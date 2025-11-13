<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Lỗi hệ thống</title>
        <style>
            body {
                font-family: 'Poppins', sans-serif;
                background-color: #f8f9fb;
                display: flex;
                align-items: center;
                justify-content: center;
                height: 100vh;
            }
            .error-box {
                background: #fff;
                border-radius: 10px;
                padding: 30px 50px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
                text-align: center;
            }
            h2 {
                color: #dc3545;
            }
            a {
                display: inline-block;
                margin-top: 15px;
                color: #007bff;
                text-decoration: none;
            }
            a:hover {
                text-decoration: underline;
            }
        </style>
    </head>
    <body>
        <div class="error-box">
            <h2>${error}</h2>
            <a href="home">Quay lại trang chủ</a>
        </div>
    </body>
</html>
