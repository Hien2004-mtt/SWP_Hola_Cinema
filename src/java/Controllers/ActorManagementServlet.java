/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controllers;

import DAL.ActorDAO;
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
@WebServlet("/manageActor")
public class ActorManagementServlet extends HttpServlet {

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // 1. Lấy tham số 'action'
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            handleAddActor(request, response);
        } else if ("delete".equals(action)) {
            handleDeleteActor(request, response);
        } else {
            response.setStatus(400); // Bad Request
            response.getWriter().write("{\"error\":\"Invalid action\"}");
        }
    }

    // 2. Add Actor
    private void handleAddActor(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        String name = request.getParameter("name").trim();
        ActorDAO dao = new ActorDAO();

        try {
            int id = dao.insertOrReactivateActor(name);

            if (id == -2) {
                // Đã tồn tại và active
                response.setStatus(409);
                response.getWriter().write("{\"error\":\"Actor already exists\"}");
                return;
            } else if (id > 0) {
                // Thêm mới hoặc re-activate thành công
                String json = String.format("{\"id\":%d,\"name\":\"%s\"}", id, name);
                response.getWriter().write(json);
            } else {
                response.setStatus(500);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"error\":\"Server error\"}");
        }
    }

    // 3. Logic "Delete" (Xóa mềm) mới
    private void handleDeleteActor(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json;charset=UTF-8");

        int actorId = Integer.parseInt(request.getParameter("id"));

        try {
            ActorDAO dao = new ActorDAO();

            
            boolean success = dao.softDeleteActor(actorId);

            if (success) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("{\"message\":\"Actor soft deleted successfully\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"Actor not found\"}");
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

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Manages Actor entities (Add and Soft Delete)";
    }// </editor-fold>

    // Bạn có thể xóa 2 hàm doGet và processRequest nếu không dùng đến
}
