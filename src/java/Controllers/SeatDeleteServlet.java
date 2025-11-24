package Controllers;

import Dao.SeatDAO;
import Models.Seat;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class SeatDeleteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int auditoriumId = Integer.parseInt(request.getParameter("auditoriumId"));
            SeatDAO dao = new SeatDAO();
            List<Seat> seats = dao.getSeatByAuditoriumIdForManager(auditoriumId);

            request.setAttribute("auditoriumId", auditoriumId);
            request.setAttribute("seats", seats);
            request.getRequestDispatcher("Views/SeatDelete.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải dữ liệu phòng chiếu.");
            request.getRequestDispatcher("Views/Error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int auditoriumId = Integer.parseInt(request.getParameter("auditoriumId"));
            String row = request.getParameter("row").trim().toUpperCase();
            int number = Integer.parseInt(request.getParameter("number"));

            SeatDAO dao = new SeatDAO();
            boolean hidden = dao.updateSeatShowingStatus(auditoriumId, row, number, false);

            if (hidden) {
                request.getSession().setAttribute("messageSeatDelete",
                        "Ghế " + row + number + " đã được ẩn thành công.");
            } else {
                request.getSession().setAttribute("messageSeatDelete",
                        " Không tìm thấy ghế " + row + number + " hoặc đã bị ẩn.");
            }

            response.sendRedirect("seatDelete?auditoriumId=" + auditoriumId);

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("messageSeatDelete", "Đã xảy ra lỗi khi ẩn ghế.");
            response.sendRedirect("seatDelete?auditoriumId=" + request.getParameter("auditoriumId"));
        }
    }
}
