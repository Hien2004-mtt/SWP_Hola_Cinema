package Controllers;

import DAL.DAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/editRole")
public class EditRoleServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        String roleStr = request.getParameter("role");
        
        if (userIdStr == null || roleStr == null) {
            request.getSession().setAttribute("error", "Thiếu thông tin cần thiết!");
            response.sendRedirect(request.getContextPath() + "/accountList");
            return;
        }
        
        int userId, role;
        try {
            userId = Integer.parseInt(userIdStr);
            role = Integer.parseInt(roleStr);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Dữ liệu không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/accountList");
            return;
        }
        
        // Không cho đổi role thành admin
        if (role == 0) {
            request.getSession().setAttribute("error", "Không được phép đổi role thành Admin!");
            response.sendRedirect(request.getContextPath() + "/accountList");
            return;
        }
        
        try {
            boolean success = new DAO().updateUserRole(userId, role);
            if (success) {
                request.getSession().setAttribute("success", "Cập nhật role thành công!");
            } else {
                request.getSession().setAttribute("error", "Không thể cập nhật role!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Đã xảy ra lỗi khi cập nhật role!");
        }
        
        response.sendRedirect(request.getContextPath() + "/accountList");
    }
}
