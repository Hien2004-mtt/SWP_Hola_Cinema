package Controllers;

import DAL.SeatDAO;
import Models.Seat;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class SeatDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String auditoriumParam = request.getParameter("auditoriumId");

        if (auditoriumParam == null || auditoriumParam.isEmpty()) {
            response.getWriter().println("❌ Thiếu auditoriumId!");
            return;
        }

        try {
            int auditoriumId = Integer.parseInt(auditoriumParam);

            SeatDAO seatDAO = new SeatDAO();
            List<Seat> seats = seatDAO.getSeatByAuditoriumId(auditoriumId);

            request.setAttribute("auditoriumId", auditoriumId);
            request.setAttribute("seats", seats);
            request.getRequestDispatcher("Views/SeatDetail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.getWriter().println("⚠️ Giá trị auditoriumId không hợp lệ.");
        }
    }
}
