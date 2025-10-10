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
        int userId, role;
        try {
            userId = Integer.parseInt(userIdStr);
            role = Integer.parseInt(roleStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input");
            return;
        }
        // Không cho đổi role thành admin
        if (role == 0) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Changing role to Admin is not allowed.");
            return;
        }
        boolean success = new DAO().updateUserRole(userId, role);
        if (success) {
            response.sendRedirect("accountList");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Update failed");
        }
    }
}
