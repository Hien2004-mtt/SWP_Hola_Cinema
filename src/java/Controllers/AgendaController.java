package Controllers;

import DAL.ScheduleDAO;
import Models.ShowtimeSchedule;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/agenda")
public class AgendaController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy danh sách lịch chiếu phim từ DAO
        // Forward tới trang agenda.jsp
        request.getRequestDispatcher("Views/agenda.jsp").forward(request, response);
    }
}
