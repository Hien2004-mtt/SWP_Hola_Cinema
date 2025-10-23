package Controllers;

import DAL.SeatDAO;
import Models.Seat;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class SeatDeleteServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int seatId = Integer.parseInt(request.getParameter("seatId"));
        int auditoriumId = Integer.parseInt(request.getParameter("auditoriumId"));

        SeatDAO dao = new SeatDAO();
        Seat seat = dao.getSeatById(seatId); // bạn cần thêm hàm này trong SeatDAO nếu chưa có

        request.setAttribute("seat", seat);
        request.setAttribute("auditoriumId", auditoriumId);
        request.getRequestDispatcher("Views/SeatDelete.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int seatId = Integer.parseInt(request.getParameter("seatId"));
        int auditoriumId = Integer.parseInt(request.getParameter("auditoriumId"));

        SeatDAO dao = new SeatDAO();
        dao.updateSeatStatusById(seatId, false); // false = ghế bị khóa / xóa mềm

        response.sendRedirect("seatList?auditoriumId=" + auditoriumId);
    }
}
