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
                    String statusText = status ? "Active" : "Banned";
                    request.getSession().setAttribute("success", "Account status updated successfully! Status: " + statusText);
                } else {
                    // Check if user exists and current status
                    try (Connection conn = DBContext.getConnection();
                         PreparedStatement ps = conn.prepareStatement("SELECT user_id, status FROM Users WHERE user_id = ?")) {
                        ps.setInt(1, userId);
                        ResultSet rs = ps.executeQuery();
                        if (rs.next()) {
                            String currentStatus = rs.getString("status");
                            String expectedStatus = status ? "active" : "banned";
                            if (currentStatus != null && currentStatus.equalsIgnoreCase(expectedStatus)) {
                                request.getSession().setAttribute("error", "Status is already set to '" + currentStatus + "'! User ID: " + userId);
                            } else {
                                request.getSession().setAttribute("error", "Cannot update status! User ID: " + userId + ", Current status: '" + currentStatus + "', Trying to set: '" + expectedStatus + "'. Please check server console log.");
                            }
                        } else {
                            request.getSession().setAttribute("error", "User does not exist! User ID: " + userId);
                        }
                    } catch (Exception ex) {
                        ex.printStackTrace();
                        request.getSession().setAttribute("error", "Cannot update account status! Error: " + ex.getMessage());
                    }
                }
            } catch (NumberFormatException e) {
                e.printStackTrace();
                request.getSession().setAttribute("error", "Invalid data: " + e.getMessage());
            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("error", "An error occurred while updating status: " + e.getMessage());
            }
        } else {
            request.getSession().setAttribute("error", "Missing required information! userId: " + userIdStr + ", status: " + statusStr);
        }
        
        response.sendRedirect(request.getContextPath() + "/accountList");
    }
}
