/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Admin
 */
public class ShowtimeConfirmServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy id suất chiếu mà người dùng chọn từ form
        String showtimeIdRaw = request.getParameter("showtimeId");

        if (showtimeIdRaw != null && !showtimeIdRaw.isEmpty()) {
            try {
                // Parse sang số nguyên
                int showtimeId = Integer.parseInt(showtimeIdRaw);

                // Lưu vào session để bước chọn ghế có thể sử dụng
                HttpSession session = request.getSession();
                session.setAttribute("selectedShowtimeId", showtimeId);

                // Chuyển hướng sang servlet hiển thị sơ đồ ghế
                response.sendRedirect("SeatSelection");

            } catch (NumberFormatException e) {
                // Nếu ID không hợp lệ (không phải số)
                request.setAttribute("error", "Mã suất chiếu không hợp lệ!");
                request.getRequestDispatcher("Views/Showtime.jsp").forward(request, response);
            }

        } else {
            // Nếu chưa chọn suất chiếu nào
            request.setAttribute("error", "Vui lòng chọn một suất chiếu trước khi tiếp tục.");
            request.getRequestDispatcher("Views/Showtime.jsp").forward(request, response);
        }
    }
}
