package Controllers;

import Dao.DAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "EditStatusServlet", urlPatterns = {"/editStatus"})
public class EditStatusServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        String statusStr = request.getParameter("status");
        if (userIdStr != null && statusStr != null) {
            try {
                int userId = Integer.parseInt(userIdStr);
                boolean status = Boolean.parseBoolean(statusStr);
                DAO dao = new DAO();
                boolean success = dao.updateUserStatus(userId, status);
                // Có thể thêm thông báo thành công/thất bại
            } catch (NumberFormatException e) {
                // Xử lý lỗi chuyển đổi
            }
        }
        response.sendRedirect("accountList"); // Quay lại trang danh sách tài khoản
    }
}
