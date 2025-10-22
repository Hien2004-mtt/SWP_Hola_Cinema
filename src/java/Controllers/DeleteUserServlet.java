package Controllers;

import DAL.DAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "DeleteUserServlet", urlPatterns = {"/deleteUser"})
public class DeleteUserServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdStr = request.getParameter("user_id");
        if (userIdStr != null) {
            try {
                int userId = Integer.parseInt(userIdStr);
                DAO dao = new DAO();
              //  boolean success = dao.deleteUserById(userId);
                // Chuyển hướng về lại trang accountList sau khi xóa
                response.sendRedirect("accountList");
            } catch (NumberFormatException e) {
                response.sendRedirect("accountList?error=invalid_id");
            }
        } else {
            response.sendRedirect("accountList?error=missing_id");
        }
    }
}
