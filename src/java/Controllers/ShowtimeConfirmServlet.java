package Controllers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ShowtimeConfirmServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String showtimeIdRaw = request.getParameter("showtimeId");

        //  Người dùng chưa chọn suất chiếu
        if (showtimeIdRaw == null || showtimeIdRaw.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn một suất chiếu trước khi tiếp tục.");
            request.getRequestDispatcher("Views/Showtime.jsp").forward(request, response);
            return;
        }

        try {
            int showtimeId = Integer.parseInt(showtimeIdRaw);

            HttpSession session = request.getSession();
            session.setAttribute("selectedShowtimeId", showtimeId);

            //  Thành công → sang bước chọn ghế
            response.sendRedirect("seat");

        } catch (NumberFormatException e) {
            // Trường hợp sửa form tay
            request.setAttribute("error", "Mã suất chiếu không hợp lệ!");
            request.getRequestDispatcher("Views/Showtime.jsp").forward(request, response);
        }
    }
}
