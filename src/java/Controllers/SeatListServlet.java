package Controllers;

import DAL.AuditoriumDAO;
import DAL.SeatDAO;
import Models.Auditorium;
import Models.Seat;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class SeatListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String auditoriumParam = request.getParameter("auditoriumId");

        // 🏠 Nếu KHÔNG có auditoriumId → hiển thị danh sách phòng chiếu
        if (auditoriumParam == null || auditoriumParam.isEmpty()) {
            AuditoriumDAO audDAO = new AuditoriumDAO();
            List<Auditorium> auditoriums = audDAO.getAll();

            request.setAttribute("auditoriums", auditoriums);
            request.getRequestDispatcher("Views/SeatList.jsp").forward(request, response);
            return;
        }
    }
}
