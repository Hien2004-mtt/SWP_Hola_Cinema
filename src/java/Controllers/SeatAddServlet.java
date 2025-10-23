package Controllers;

import DAL.AuditoriumDAO;
import DAL.SeatDAO;
import Models.Auditorium;
import Models.Seat;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class SeatAddServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy danh sách phòng để hiển thị trong dropdown
        AuditoriumDAO audDAO = new AuditoriumDAO();
        List<Auditorium> auditoriums = audDAO.getAll();

        request.setAttribute("auditoriums", auditoriums);
        request.getRequestDispatcher("Views/AddSeat.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int auditoriumId = Integer.parseInt(request.getParameter("auditoriumId"));
            int rows = Integer.parseInt(request.getParameter("rows"));
            int cols = Integer.parseInt(request.getParameter("cols"));
            String seatType = request.getParameter("seatType");

            List<Seat> seats = new ArrayList<>();
            for (int i = 0; i < rows; i++) {
                char rowChar = (char) ('A' + i);
                for (int j = 1; j <= cols; j++) {
                    Seat s = new Seat();
                    s.setAuditoriumId(auditoriumId);
                    s.setRow(String.valueOf(rowChar));
                    s.setNumber(j);
                    s.setSeatType(seatType);
                    s.setIsActivate(true);
                    seats.add(s);
                }
            }

            SeatDAO seatDAO = new SeatDAO();
            boolean success = seatDAO.addMultipleSeats(seats);

            if (success) {
                response.sendRedirect("seatDetail?auditoriumId=" + auditoriumId);
            } else {
                response.getWriter().println( "Lỗi khi thêm ghế vào phòng!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi khi xử lý dữ liệu!");
        }
    }
}
