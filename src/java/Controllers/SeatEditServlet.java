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


public class SeatEditServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int auditoriumId = Integer.parseInt(request.getParameter("auditoriumId"));
            SeatDAO dao = new SeatDAO();
            List<Seat> seats = dao.getSeatByAuditoriumIdForManager(auditoriumId);

            request.setAttribute("auditoriumId", auditoriumId);
            request.setAttribute("seats", seats);
            request.getRequestDispatcher("Views/SeatEdit.jsp").forward(request, response);

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
            String seatType = request.getParameter("seatType"); // tùy chọn

            SeatDAO dao = new SeatDAO();
            boolean success = false;
            String message = "";

            if (seatType == null || seatType.isEmpty()) {
                //  Chỉ khôi phục ghế
                boolean restored = dao.restoreSeat(auditoriumId, row, number);
                if (restored) {
                    success = true;
                    message = " Đã khôi phục ghế " + row + number + ".";
                } else {
                    message = "️ Ghế " + row + number + " không tồn tại hoặc đã hiển thị.";
                }
            } else {
                //  Cập nhật loại ghế và khôi phục nếu đang ẩn
                boolean updated = dao.updateSeatType(auditoriumId, row, number, seatType);
                boolean restored = dao.restoreSeat(auditoriumId, row, number);

                if (updated || restored) {
                    success = true;
                    message = " Ghế " + row + number + " đã được cập nhật loại " + seatType ;
                } else {
                    message = "️ Không tồn tại ghế " + row + number;
                }
            }

            //  Lưu thông báo vào session
            request.getSession().setAttribute("messageUpdate", message);

            //  Quay lại trang cập nhật
            response.sendRedirect("seatEdit?auditoriumId=" + auditoriumId);

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("messageUpdate", " Đã xảy ra lỗi, vui lòng thử lại sau!");
            response.sendRedirect("seatEdit?auditoriumId=" + request.getParameter("auditoriumId"));
        }
    }
}
