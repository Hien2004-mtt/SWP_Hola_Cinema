package Controllers;

import DAL.SeatDAO;
import Models.Seat;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
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
            int seatCount = Integer.parseInt(request.getParameter("seatCount"));
            String seatType = request.getParameter("seatType");

            SeatDAO seatDAO = new SeatDAO();
            List<Seat> existingSeats = seatDAO.getSeatByRow(auditoriumId, row);
            int existingCount = existingSeats.size();

            List<Seat> newSeats = new ArrayList<>();

            // ✅ Chuẩn bị danh sách ghế mới
            for (int i = 1; i <= seatCount; i++) {
                int seatNumber = existingCount + i;

                if (seatDAO.isSeatExists(auditoriumId, row, seatNumber)) {
                    request.setAttribute("error",
                            "⚠️ Ghế " + row + seatNumber + " trong phòng " + auditoriumId + " đã tồn tại!");
                    request.getRequestDispatcher("Views/AddSeatRow.jsp").forward(request, response);
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

            // ✅ Sau vòng lặp mới xử lý thêm vào DB
            if (newSeats.isEmpty()) {
                request.setAttribute("error", "⚠️ Không có ghế nào được thêm. Có thể hàng đã đầy.");
                request.getRequestDispatcher("Views/AddSeatRow.jsp").forward(request, response);
                return;
            }

            boolean success = seatDAO.addMultipleSeats(newSeats);

            if (success) {
                // ✅ Chỉ redirect 1 lần duy nhất
                response.sendRedirect("seatDetail?auditoriumId=" + auditoriumId);
            } else {
                request.setAttribute("error", "❌ Lỗi khi thêm ghế vào cơ sở dữ liệu!");
                request.getRequestDispatcher("Views/AddSeatRow.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "❌ Đã xảy ra lỗi, vui lòng reload lại trang.");
            request.getRequestDispatcher("Views/AddSeatRow.jsp").forward(request, response);
        }
    }
}
