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
import Models.ShowtimeSchedule;
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
    
    // Phương thức helper để kết hợp date và time thành Timestamp
    private Timestamp combineDateTime(String dateStr, String timeStr, SimpleDateFormat dateFormat, SimpleDateFormat timeFormat) throws ParseException {
        java.util.Date date = dateFormat.parse(dateStr);
        java.util.Date time = timeFormat.parse(timeStr);
        
        // Lấy thông tin ngày từ date
        java.util.Calendar dateCal = java.util.Calendar.getInstance();
        dateCal.setTime(date);
        
        // Lấy thông tin thời gian từ time
        java.util.Calendar timeCal = java.util.Calendar.getInstance();
        timeCal.setTime(time);
        
        // Kết hợp ngày và thời gian
        dateCal.set(java.util.Calendar.HOUR_OF_DAY, timeCal.get(java.util.Calendar.HOUR_OF_DAY));
        dateCal.set(java.util.Calendar.MINUTE, timeCal.get(java.util.Calendar.MINUTE));
        dateCal.set(java.util.Calendar.SECOND, 0);
        dateCal.set(java.util.Calendar.MILLISECOND, 0);
        
        return new Timestamp(dateCal.getTimeInMillis());
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User loggedInUser = (User) request.getSession().getAttribute("user");
//        if (loggedInUser == null || loggedInUser.getRole() != 0) {
//            response.sendRedirect("login.jsp");
//            return;
//        }

        try {
            // Lấy filter và search từ request
            String filter = request.getParameter("filter");
            String search = request.getParameter("search");

            // Thử lấy phim đang chiếu và sắp chiếu trước
            java.util.List<ShowtimeSchedule> upcomingMovies = dao.getUpcomingMovies();
            if (upcomingMovies.isEmpty()) {
                upcomingMovies = dao.getAllMovies();
            }

            // Lấy danh sách lịch chiếu
            java.util.List<ShowtimeSchedule> scheduleList = dao.getAllShowtimes();
            java.sql.Timestamp now = new java.sql.Timestamp(System.currentTimeMillis());
            for (ShowtimeSchedule schedule : scheduleList) {
                if (schedule.getEndTime() != null && schedule.getEndTime().before(now) && "active".equals(schedule.getStatus())) {
                    // Chuyển trạng thái thành completed nếu đã qua thời gian kết thúc
                    dao.updateShowtimeStatus(schedule.getShowtimeId(), "completed");
                    schedule.setStatus("completed");
                }
            }

            // Lọc theo trạng thái nếu có filter
            if (filter != null && !filter.equals("all")) {
                java.util.List<ShowtimeSchedule> filteredList = new java.util.ArrayList<>();
                for (ShowtimeSchedule s : scheduleList) {
                    if (filter.equals(s.getStatus())) {
                        filteredList.add(s);
                    }
                }
                scheduleList = filteredList;
            }

            // Lọc theo search nếu có
            if (search != null && !search.trim().isEmpty()) {
                String searchLower = search.trim().toLowerCase();
                java.util.List<ShowtimeSchedule> searchedList = new java.util.ArrayList<>();
                for (ShowtimeSchedule s : scheduleList) {
                    boolean match = false;
                    if (s.getMovieName() != null && s.getMovieName().toLowerCase().contains(searchLower)) match = true;
                    if (s.getAuditoriumName() != null && s.getAuditoriumName().toLowerCase().contains(searchLower)) match = true;
                    if (s.getStatus() != null && s.getStatus().toLowerCase().contains(searchLower)) match = true;
                    if (String.valueOf(s.getShowtimeId()).contains(searchLower)) match = true;
                    if (match) searchedList.add(s);
                }
                scheduleList = searchedList;
            }

            request.setAttribute("upcomingMovies", upcomingMovies);
            request.setAttribute("activeAuditoriums", dao.getActiveAuditoriums());
            request.setAttribute("scheduleList", scheduleList);
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

            // Parser cho date và time riêng biệt
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
            dateFormat.setLenient(false);
            timeFormat.setLenient(false);

            switch (action) {
                case "update": {
                    String showtimeIdStr = request.getParameter("showtimeId");
                    String movieIdStr = request.getParameter("movieId");
                    String auditoriumIdStr = request.getParameter("auditoriumId");
                    String showDateStr = request.getParameter("showDate");
                    String startTimeStr = request.getParameter("startTime");
                    String endTimeStr = request.getParameter("endTime");
                    String basePriceStr = request.getParameter("basePrice");

                    if (showtimeIdStr == null || movieIdStr == null || auditoriumIdStr == null || 
                        showDateStr == null || startTimeStr == null || endTimeStr == null || basePriceStr == null) {
                        request.setAttribute("error", "Vui lòng điền đầy đủ thông tin cập nhật!");
                        break;
                    }

                    int showtimeId = Integer.parseInt(showtimeIdStr.trim());
                    int movieId = Integer.parseInt(movieIdStr.trim());
                    int auditoriumId = Integer.parseInt(auditoriumIdStr.trim());
                    double basePrice = Double.parseDouble(basePriceStr.trim());
                    
                    // Kết hợp date và time thành Timestamp
                    Timestamp startTime = combineDateTime(showDateStr.trim(), startTimeStr.trim(), dateFormat, timeFormat);
                    Timestamp endTime = combineDateTime(showDateStr.trim(), endTimeStr.trim(), dateFormat, timeFormat);

                    boolean ok = dao.updateShowtime(showtimeId, movieId, auditoriumId, startTime, endTime, basePrice);
                    if (ok) {
                        request.setAttribute("success", "Cập nhật lịch chiếu thành công!");
                    } else {
                        request.setAttribute("error", "Xung đột thời gian hoặc lỗi khi cập nhật!");
                    }
                    break;
                }
                case "cancel": {
                    String showtimeIdStr = request.getParameter("showtimeId");
                    if (showtimeIdStr == null) {
                        request.setAttribute("error", "Thiếu mã lịch chiếu để hủy!");
                        break;
                    }
                    int showtimeId = Integer.parseInt(showtimeIdStr.trim());
                    boolean ok = dao.cancelShowtime(showtimeId);
                    if (ok) {
                        request.setAttribute("success", "Hủy suất chiếu thành công!");
                    } else {
                        request.setAttribute("error", "Không thể hủy suất chiếu!");
                    }
                    break;
                }
                case "restore": {
                    String showtimeIdStr = request.getParameter("showtimeId");
                    if (showtimeIdStr == null) {
                        request.setAttribute("error", "Thiếu mã lịch chiếu để khôi phục!");
                        break;
                    }
                    int showtimeId = Integer.parseInt(showtimeIdStr.trim());
                    boolean ok = dao.restoreShowtime(showtimeId);
                    if (ok) {
                        request.setAttribute("success", "Khôi phục suất chiếu thành công!");
                    } else {
                        request.setAttribute("error", "Không thể khôi phục suất chiếu!");
                    }
                    break;
                }
                case "add":
                default: {
                    String movieIdStr = request.getParameter("movieId");
                    String auditoriumIdStr = request.getParameter("auditoriumId");
                    String showDateStr = request.getParameter("showDate");
                    String startTimeStr = request.getParameter("startTime");
                    String endTimeStr = request.getParameter("endTime");
                    String basePriceStr = request.getParameter("basePrice");

                    if (movieIdStr == null || auditoriumIdStr == null || showDateStr == null || 
                        startTimeStr == null || endTimeStr == null || basePriceStr == null) {
                        request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
                        // Truyền lại dữ liệu đã nhập
                        request.setAttribute("form_movieId", movieIdStr);
                        request.setAttribute("form_auditoriumId", auditoriumIdStr);
                        request.setAttribute("form_showDate", showDateStr);
                        request.setAttribute("form_startTime", startTimeStr);
                        request.setAttribute("form_endTime", endTimeStr);
                        request.setAttribute("form_basePrice", basePriceStr);
                        break;
                    }

                    int movieId = Integer.parseInt(movieIdStr.trim());
                    int auditoriumId = Integer.parseInt(auditoriumIdStr.trim());
                    double basePrice = Double.parseDouble(basePriceStr.trim());

                    // Kết hợp date và time thành Timestamp
                    Timestamp startTime = combineDateTime(showDateStr.trim(), startTimeStr.trim(), dateFormat, timeFormat);
                    Timestamp endTime = combineDateTime(showDateStr.trim(), endTimeStr.trim(), dateFormat, timeFormat);

                    Timestamp now = new Timestamp(System.currentTimeMillis());
                    if (endTime.before(now)) {
                        request.setAttribute("error", "Không thể thêm lịch chiếu ở quá khứ!");
                        // Truyền lại dữ liệu đã nhập
                        request.setAttribute("form_movieId", movieIdStr);
                        request.setAttribute("form_auditoriumId", auditoriumIdStr);
                        request.setAttribute("form_showDate", showDateStr);
                        request.setAttribute("form_startTime", startTimeStr);
                        request.setAttribute("form_endTime", endTimeStr);
                        request.setAttribute("form_basePrice", basePriceStr);
                        break;
                    }

                    int newId = dao.addShowtime(movieId, auditoriumId, startTime, endTime, basePrice);
                    if (newId > 0) {
                        request.setAttribute("success", "Thêm lịch chiếu thành công!");
                    } else {
                        request.setAttribute("error", "Xung đột thời gian hoặc lỗi khi thêm lịch!");
                        // Truyền lại dữ liệu đã nhập
                        request.setAttribute("form_movieId", movieIdStr);
                        request.setAttribute("form_auditoriumId", auditoriumIdStr);
                        request.setAttribute("form_showDate", showDateStr);
                        request.setAttribute("form_startTime", startTimeStr);
                        request.setAttribute("form_endTime", endTimeStr);
                        request.setAttribute("form_basePrice", basePriceStr);
                    }
                }
            }

            // Thử lấy phim đang chiếu và sắp chiếu trước
            java.util.List<ShowtimeSchedule> upcomingMovies = dao.getUpcomingMovies();
            
            // Nếu không có phim nào, thử lấy tất cả phim
            if (upcomingMovies.isEmpty()) {
                upcomingMovies = dao.getAllMovies();
            }
            
            request.setAttribute("upcomingMovies", upcomingMovies);
            request.setAttribute("activeAuditoriums", dao.getActiveAuditoriums());
            request.setAttribute("scheduleList", dao.getAllShowtimes());
            request.getRequestDispatcher("Views/manageSchedule.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            try {
                e.printStackTrace();
                request.setAttribute("error", "Giá trị số không hợp lệ: " + e.getMessage());
                
                // Thử lấy phim đang chiếu và sắp chiếu trước
                java.util.List<ShowtimeSchedule> upcomingMovies = dao.getUpcomingMovies();
                if (upcomingMovies.isEmpty()) {
                    upcomingMovies = dao.getAllMovies();
                }
                
                request.setAttribute("upcomingMovies", upcomingMovies);
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
                
                // Thử lấy phim đang chiếu và sắp chiếu trước
                java.util.List<ShowtimeSchedule> upcomingMovies = dao.getUpcomingMovies();
                if (upcomingMovies.isEmpty()) {
                    upcomingMovies = dao.getAllMovies();
                }
                
                request.setAttribute("upcomingMovies", upcomingMovies);
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

