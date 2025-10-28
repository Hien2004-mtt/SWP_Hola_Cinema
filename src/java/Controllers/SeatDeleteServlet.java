package Controllers;

import DAL.SeatDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class SeatDeleteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int auditoriumId = Integer.parseInt(request.getParameter("auditoriumId"));
            String row = request.getParameter("row").trim().toUpperCase();
            int number = Integer.parseInt(request.getParameter("number"));
            String action = request.getParameter("action");
            SeatDAO dao = new SeatDAO();
            //bam nut an ghe -> isShowing = 0. Bam nut khoi phuc --> isShowing = 1 
            boolean isShowing = !"hide".equals(action);
            // ✅ Gọi hàm delete theo row + number + auditoriumId
            boolean deleted = dao.updateSeatShowingStatus(auditoriumId, row, number,isShowing);

            if (deleted) {
                request.getSession().setAttribute("message",
                        (isShowing ? "✅ Đã khôi phục ghế " : "❌ Đã ẩn ghế ") + row + number);
            } else {
                request.getSession().setAttribute("message",
                        "⚠️ Không tìm thấy ghế " + row + number + " trong phòng " + auditoriumId);
            }

            response.sendRedirect("seatDetail?auditoriumId=" + auditoriumId);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "⚠️ Dữ liệu nhập không hợp lệ! Vui lòng kiểm tra lại.");
            request.getRequestDispatcher("Views/SeatDetail.jsp").forward(request, response);
        }
    }
}
