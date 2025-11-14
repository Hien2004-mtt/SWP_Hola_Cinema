package Controllers;

import DAL.DAO;
import DAL.DBContext;
import Models.UserAccount;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet(name = "EditStatusServlet", urlPatterns = {"/editStatus"})
public class EditStatusServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdStr = request.getParameter("userId");
        String statusStr = request.getParameter("status");
        
        System.out.println("EditStatusServlet - Received userId: " + userIdStr + ", status: " + statusStr);
        
        if (userIdStr != null && statusStr != null) {
            try {
                int userId = Integer.parseInt(userIdStr);
                boolean status = Boolean.parseBoolean(statusStr);
                
                System.out.println("Parsed - userId: " + userId + ", status boolean: " + status);
                System.out.println("Status string value: '" + statusStr + "'");
                
                DAO dao = new DAO();
                boolean success = dao.updateUserStatus(userId, status);
                
                System.out.println("Update result: " + success);
                
                if (success) {
                    String statusText = status ? "Active" : "Locked";
                    request.getSession().setAttribute("success", "Cập nhật trạng thái tài khoản thành công! Trạng thái: " + statusText);
                } else {
                    // Kiểm tra xem user có tồn tại không và status hiện tại là gì
                    try (Connection conn = DBContext.getConnection();
                         PreparedStatement ps = conn.prepareStatement("SELECT user_id, status FROM Users WHERE user_id = ?")) {
                        ps.setInt(1, userId);
                        ResultSet rs = ps.executeQuery();
                        if (rs.next()) {
                            String currentStatus = rs.getString("status");
                            String expectedStatus = status ? "active" : "locked";
                            if (currentStatus != null && currentStatus.equalsIgnoreCase(expectedStatus)) {
                                request.getSession().setAttribute("error", "Trạng thái đã được set thành '" + currentStatus + "' rồi! User ID: " + userId);
                            } else {
                                request.getSession().setAttribute("error", "Không thể cập nhật trạng thái! User ID: " + userId + ", Status hiện tại: '" + currentStatus + "', Muốn set: '" + expectedStatus + "'. Vui lòng kiểm tra server console log.");
                            }
                        } else {
                            request.getSession().setAttribute("error", "User không tồn tại! User ID: " + userId);
                        }
                    } catch (Exception ex) {
                        ex.printStackTrace();
                        request.getSession().setAttribute("error", "Không thể cập nhật trạng thái tài khoản! Lỗi: " + ex.getMessage());
                    }
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
                request.getSession().setAttribute("error", "Dữ liệu không hợp lệ: " + e.getMessage());
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("error", "Đã xảy ra lỗi khi cập nhật trạng thái: " + e.getMessage());
            }
        } else {
            request.getSession().setAttribute("error", "Thiếu thông tin cần thiết! userId: " + userIdStr + ", status: " + statusStr);
        }
        
        response.sendRedirect(request.getContextPath() + "/accountList");
    }
}
