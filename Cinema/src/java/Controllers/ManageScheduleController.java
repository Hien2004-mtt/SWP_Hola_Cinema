/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controllers;

/**
 *
 * @author ASUS
 */
import DAL.ScheduleDAO;
import Models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;

@WebServlet("/manageSchedule")
public class ManageScheduleController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ScheduleDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new ScheduleDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User loggedInUser = (User) request.getSession().getAttribute("user");
//        if (loggedInUser == null || loggedInUser.getRole() != 0) {
//            response.sendRedirect("login.jsp");
//            return;
//        }

        try {
            request.setAttribute("upcomingMovies", dao.getUpcomingMovies());
            request.setAttribute("activeAuditoriums", dao.getActiveAuditoriums());
            request.getRequestDispatcher("Views/manageSchedule.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("Views/manageSchedule.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        User loggedInUser = (User) request.getSession().getAttribute("user");
        if (loggedInUser == null || loggedInUser.getRole() != 0) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int movieId = Integer.parseInt(request.getParameter("movieId"));
            int auditoriumId = Integer.parseInt(request.getParameter("auditoriumId"));
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");
            double price = Double.parseDouble(request.getParameter("price"));

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            Timestamp startTime = new Timestamp(dateFormat.parse(startTimeStr).getTime());
            Timestamp endTime = new Timestamp(dateFormat.parse(endTimeStr).getTime());

            int showtimeId = dao.addShowtime(movieId, auditoriumId, startTime, endTime, price);
            if (showtimeId > 0) {
                request.setAttribute("success", "Thêm lịch chiếu thành công!");
            } else if (showtimeId == -1) {
                request.setAttribute("error", "Xung đột thời gian hoặc lỗi khi thêm lịch!");
            } else {
                request.setAttribute("error", "Lỗi không xác định!");
            }
            request.setAttribute("upcomingMovies", dao.getUpcomingMovies());
            request.setAttribute("activeAuditoriums", dao.getActiveAuditoriums());
            request.getRequestDispatcher("/WEB-INF/views/admin/manageSchedule.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException | ParseException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi xử lý: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/admin/manageSchedule.jsp").forward(request, response);
        }
    }
}

