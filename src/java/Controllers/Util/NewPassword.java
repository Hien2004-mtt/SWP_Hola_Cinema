package Controllers.Util;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/newPassword")
public class NewPassword extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String newPassword = request.getParameter("password");
        String confPassword = request.getParameter("confPassword");
        String email = (String) session.getAttribute("email");
        RequestDispatcher dispatcher;

        if (email == null) {
            System.out.println("⚠️ Email trong session bị null, không thể cập nhật.");
            request.setAttribute("error", "Phiên làm việc đã hết hạn. Vui lòng thực hiện lại từ đầu.");
            dispatcher = request.getRequestDispatcher("forgotPassword.jsp");
            dispatcher.forward(request, response);
            return;
        }

        if (newPassword != null && newPassword.equals(confPassword)) {
            try {
                // ✅ Nạp driver trước khi kết nối
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

                try (Connection con = DriverManager.getConnection(
                        "jdbc:sqlserver://localhost:1433;databaseName=cinema3;encrypt=false;trustServerCertificate=true;",
                        "sa", "123");
                     PreparedStatement pst = con.prepareStatement(
                             "UPDATE [dbo].[Users] SET password_hash = ?, updated_at = GETDATE() WHERE email = ?")) {

                    pst.setString(1, newPassword);
                    pst.setString(2, email);

                    int rowCount = pst.executeUpdate();
                    if (rowCount > 0) {
                        System.out.println("✅ Cập nhật mật khẩu thành công cho: " + email);
                        request.setAttribute("message", "Đổi mật khẩu thành công!");
                        dispatcher = request.getRequestDispatcher("/Views/login.jsp");
                    } else {
                        System.out.println("❌ Không tìm thấy user có email: " + email);
                        request.setAttribute("error", "Không tìm thấy người dùng.");
                        dispatcher = request.getRequestDispatcher("changePassword.jsp");
                    }

                }
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
                request.setAttribute("error", "Không tìm thấy driver SQL Server: " + e.getMessage());
                dispatcher = request.getRequestDispatcher("changePassword.jsp");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
                dispatcher = request.getRequestDispatcher("changePassword.jsp");
            }
        } else {
            request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
            dispatcher = request.getRequestDispatcher("changePassword.jsp");
        }

        dispatcher.forward(request, response);
    }
}
