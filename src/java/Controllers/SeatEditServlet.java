package Controllers;

import DAL.SeatDAO;
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
            StringBuilder msg = new StringBuilder();

            // kiểm tra có hành động nào không
            if ((seatType == null || seatType.isEmpty())) {
                // nếu không có seatType thì chỉ khôi phục ghế
                boolean restored = dao.restoreSeat(auditoriumId, row, number);
                if (restored) {
                    success = true;
                    msg.append(" Đã khôi phục ghế ").append(row).append(number).append(".");
                } else {
                    msg.append("Ghế ").append(row).append(number)
                            .append(" không tồn tại hoặc đã hiển thị.");
                }
            } else {
                // có seatType => đổi loại ghế + khôi phục nếu đang ẩn
                boolean typeUpdated = dao.updateSeatType(auditoriumId, row, number, seatType);
                boolean restored = dao.restoreSeat(auditoriumId, row, number);

                if (typeUpdated || restored) {
                    success = true;
                    msg.append("Ghế ").append(row).append(number)
                            .append(" đã được cập nhật loại ").append(seatType).append(" và hiển thị lại.");
                } else {
                    msg.append("Không tìm thấy ghế để cập nhật.");
                }
            }

            // gửi thông báo
            if (success) {
                request.getSession().setAttribute("message", msg.toString());
            } else {
                request.getSession().setAttribute("message", "Không có thay đổi nào được thực hiện.");
            }

            response.sendRedirect("seatEdit?auditoriumId=" + auditoriumId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("Views/Error.jsp");
        }
    }
}
