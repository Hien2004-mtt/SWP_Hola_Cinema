package Controllers;

import DAL.SeatDAO;
import DAL.AuditoriumDAO;
import Models.Auditorium;
import Models.Seat;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class SeatAddRowServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int auditoriumId = Integer.parseInt(request.getParameter("auditoriumId"));
            String row = request.getParameter("row").trim().toUpperCase();

         
            if (!row.matches("^[A-Z]$")) {
                request.getSession().setAttribute("messageSeat", " Hàng ghế không hợp lệ! Chỉ được nhập từ A–Z.");
                response.sendRedirect("seatAddRowForm?auditoriumId=" + auditoriumId);
                return;
            }

            int seatCount = Integer.parseInt(request.getParameter("seatCount"));
            String seatType = request.getParameter("seatType");

            //  Lấy tổng ghế tối đa của phòng
            AuditoriumDAO audDAO = new AuditoriumDAO();
            Auditorium auditorium = audDAO.getById(auditoriumId);
            int totalSeat = auditorium != null ? auditorium.getTotalSeat() : 0;

            //  Lấy danh sách ghế hiện tại của phòng
            SeatDAO seatDAO = new SeatDAO();
            List<Seat> currentSeats = seatDAO.getSeatByAuditoriumId(auditoriumId);
            int currentSeatCount = currentSeats.size();

            //  Kiểm tra điều kiện thêm ghế
            if (currentSeatCount == 0) {
                // phòng chưa có ghế
                if (seatCount < 0 || seatCount > totalSeat) {
                    request.getSession().setAttribute("messageSeat",
                            "Phòng chưa có ghế, số ghế thêm phải nằm trong khoảng 10 đến " + totalSeat + ".");
                    response.sendRedirect("seatAddRowForm?auditoriumId=" + auditoriumId);
                    return;
                }
            } else {
                // phòng đã có ghế
                if (currentSeatCount + seatCount > totalSeat) {
                    request.getSession().setAttribute("messageSeat",
                            "️ Không thể thêm quá tổng " + totalSeat + " ghế cho phòng này! "
                            + "(Hiện có: " + currentSeatCount + ", đang thêm: " + seatCount + ")");
                    response.sendRedirect("seatAddRowForm?auditoriumId=" + auditoriumId);
                    return;
                }
            }

            // Kiểm tra trùng hàng ghế
            List<Seat> existingSeats = seatDAO.getSeatByRow(auditoriumId, row);
            int existingCount = existingSeats.size();

            List<Seat> newSeats = new ArrayList<>();
            for (int i = 1; i <= seatCount; i++) {
                int seatNumber = existingCount + i;

                if (seatDAO.isSeatExists(auditoriumId, row, seatNumber)) {
                    request.getSession().setAttribute("messageSeat",
                            "️ Ghế " + row + seatNumber + " đã tồn tại trong phòng " + auditoriumId + "!");
                    response.sendRedirect("seatAddRowForm?auditoriumId=" + auditoriumId);
                    return;
                }

                Seat s = new Seat();
                s.setAuditoriumId(auditoriumId);
                s.setRow(row);
                s.setNumber(seatNumber);
                s.setSeatType(seatType);
                s.setIsActivate(true);
                s.setIsShowing(true);
                newSeats.add(s);
            }

            // Thêm vào database
            boolean success = seatDAO.addMultipleSeats(newSeats);

            if (success) {
                request.getSession().setAttribute("messageSeat",
                        " Đã thêm " + seatCount + " ghế hàng " + row + " cho phòng #" + auditoriumId + ".");
                response.sendRedirect("seatDetail?auditoriumId=" + auditoriumId);
            } else {
                request.getSession().setAttribute("messageSeat",
                        "Lỗi khi thêm ghế vào cơ sở dữ liệu!");
                response.sendRedirect("seatAddRowForm?auditoriumId=" + auditoriumId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("messageSeat", "❌ Đã xảy ra lỗi, vui lòng thử lại sau.");
            response.sendRedirect("seatAddRowForm?auditoriumId=" + request.getParameter("auditoriumId"));
        }
    }
}
