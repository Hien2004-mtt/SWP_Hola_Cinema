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
import java.util.logging.Level;
import java.util.logging.Logger;

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
            request.setAttribute("scheduleList", dao.getAllShowtimes());
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
//        if (loggedInUser == null || loggedInUser.getRole() != 0) {
//            response.sendRedirect("login.jsp");
//            return;
//        }

        try {
            String action = request.getParameter("action");
            if (action == null) action = "add";

            // Dùng chung parser thời gian
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            dateFormat.setLenient(false);

            switch (action) {
                case "update": {
                    String showtimeIdStr = request.getParameter("showtimeId");
                    String movieIdStr = request.getParameter("movieId");
                    String auditoriumIdStr = request.getParameter("auditoriumId");
                    String startTimeStr = request.getParameter("startTime");
                    String endTimeStr = request.getParameter("endTime");
                    String basePriceStr = request.getParameter("basePrice");

                    if (showtimeIdStr == null || movieIdStr == null || auditoriumIdStr == null || startTimeStr == null || endTimeStr == null || basePriceStr == null) {
                        request.setAttribute("error", "Vui lòng điền đầy đủ thông tin cập nhật!");
                        break;
                    }

                    int showtimeId = Integer.parseInt(showtimeIdStr.trim());
                    int movieId = Integer.parseInt(movieIdStr.trim());
                    int auditoriumId = Integer.parseInt(auditoriumIdStr.trim());
                    double basePrice = Double.parseDouble(basePriceStr.trim());
                    Timestamp startTime = new Timestamp(dateFormat.parse(startTimeStr.trim()).getTime());
                    Timestamp endTime = new Timestamp(dateFormat.parse(endTimeStr.trim()).getTime());

                    boolean ok = dao.updateShowtime(showtimeId, movieId, auditoriumId, startTime, endTime, basePrice);
                    if (ok) {
                        request.setAttribute("success", "Cập nhật lịch chiếu thành công!");
                    } else {
                        request.setAttribute("error", "Xung đột thời gian hoặc lỗi khi cập nhật!");
                    }
                    break;
                }
                case "delete": {
                    String showtimeIdStr = request.getParameter("showtimeId");
                    if (showtimeIdStr == null) {
                        request.setAttribute("error", "Thiếu mã lịch chiếu để xóa!");
                        break;
                    }
                    int showtimeId = Integer.parseInt(showtimeIdStr.trim());
                    boolean ok = dao.deleteShowtime(showtimeId);
                    if (ok) {
                        request.setAttribute("success", "Xóa lịch chiếu thành công!");
                    } else {
                        request.setAttribute("error", "Không thể xóa lịch chiếu!");
                    }
                    break;
                }
                case "add":
                default: {
                    String movieIdStr = request.getParameter("movieId");
                    String auditoriumIdStr = request.getParameter("auditoriumId");
                    String startTimeStr = request.getParameter("startTime");
                    String endTimeStr = request.getParameter("endTime");
                    String basePriceStr = request.getParameter("basePrice");

                    if (movieIdStr == null || auditoriumIdStr == null || startTimeStr == null || endTimeStr == null || basePriceStr == null) {
                        request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
                        break;
                    }

                    int movieId = Integer.parseInt(movieIdStr.trim());
                    int auditoriumId = Integer.parseInt(auditoriumIdStr.trim());
                    double basePrice = Double.parseDouble(basePriceStr.trim());
                    Timestamp startTime = new Timestamp(dateFormat.parse(startTimeStr.trim()).getTime());
                    Timestamp endTime = new Timestamp(dateFormat.parse(endTimeStr.trim()).getTime());

                    int newId = dao.addShowtime(movieId, auditoriumId, startTime, endTime, basePrice);
                    if (newId > 0) {
                        request.setAttribute("success", "Thêm lịch chiếu thành công!");
                    } else {
                        request.setAttribute("error", "Xung đột thời gian hoặc lỗi khi thêm lịch!");
                    }
                }
            }

            request.setAttribute("upcomingMovies", dao.getUpcomingMovies());
            request.setAttribute("activeAuditoriums", dao.getActiveAuditoriums());
            request.setAttribute("scheduleList", dao.getAllShowtimes());
            request.getRequestDispatcher("Views/manageSchedule.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            try {
                e.printStackTrace();
                request.setAttribute("error", "Giá trị số không hợp lệ: " + e.getMessage());
                request.setAttribute("upcomingMovies", dao.getUpcomingMovies());
                request.setAttribute("activeAuditoriums", dao.getActiveAuditoriums());
                request.setAttribute("scheduleList", dao.getAllShowtimes());
                request.getRequestDispatcher("Views/manageSchedule.jsp").forward(request, response);
            } catch (SQLException ex) {
                Logger.getLogger(ManageScheduleController.class.getName()).log(Level.SEVERE, null, ex);
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(ManageScheduleController.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (SQLException | ClassNotFoundException | ParseException e) {
            try {
                e.printStackTrace();
                request.setAttribute("error", "Lỗi khi xử lý: " + e.getMessage());
                request.setAttribute("upcomingMovies", dao.getUpcomingMovies());
                request.setAttribute("activeAuditoriums", dao.getActiveAuditoriums());
                request.setAttribute("scheduleList", dao.getAllShowtimes());
                request.getRequestDispatcher("Views/manageSchedule.jsp").forward(request, response);
            } catch (SQLException ex) {
                Logger.getLogger(ManageScheduleController.class.getName()).log(Level.SEVERE, null, ex);
            } catch (ClassNotFoundException ex) {
                Logger.getLogger(ManageScheduleController.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
}
