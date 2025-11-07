/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controllers;

import DAL.GenreDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author dinhh
 */
@WebServlet("/manageGenre")
public class GenreManagementServlet extends HttpServlet {

    // ... (không cần sửa processRequest hay doGet) ...
    /**
     * Handles the HTTP <code>POST</code> method.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // 1. Thêm dòng này để kiểm tra hành động
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            handleAddGenre(request, response);
        } else if ("delete".equals(action)) {
            handleDeleteGenre(request, response);
        } else {
            response.setStatus(400); // Bad Request
            response.getWriter().write("{\"error\":\"Invalid action\"}");
        }
    }

    // 2. Add Genre
    private void handleAddGenre(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        String name = request.getParameter("name").trim();
        GenreDAO dao = new GenreDAO();

        try {
            // Dùng hàm mới thông minh hơn
            int id = dao.insertOrReactivateGenre(name);

            if (id == -2) {
                // Đã tồn tại và is_active = 1
                response.setStatus(409); // Conflict
                response.getWriter().write("{\"error\":\"Genre already exists\"}");
                return;
            } else if (id > 0) {
                // Thêm mới hoặc re-activate thành công
                String json = String.format("{\"id\":%d,\"name\":\"%s\"}", id, name);
                response.getWriter().write(json);
            } else {
                // Lỗi khác
                response.setStatus(500);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"error\":\"Server error\"}");
        }
    }

    // 3. Tạo hàm "Delete" (xóa mềm)
    private void handleDeleteGenre(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        int genreId = Integer.parseInt(request.getParameter("id"));
        try {

            GenreDAO dao = new GenreDAO();

            boolean success = dao.softDeleteGenre(genreId);

            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"message\":\"Genre soft deleted successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"Genre not found\"}");
            }
        } catch (NumberFormatException e) {
            response.setStatus(400); // Bad Request - ID không phải là số
            response.getWriter().write("{\"error\":\"Invalid ID format\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"error\":\"Server error\"}");
        }
    }
}
