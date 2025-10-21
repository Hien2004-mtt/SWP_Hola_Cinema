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
        try {
            // Lấy startDate từ request, nếu không có thì lấy ngày hôm nay
            String startDateStr = request.getParameter("startDate");
            java.time.LocalDate startDate;
            if (startDateStr != null && !startDateStr.isEmpty()) {
                startDate = java.time.LocalDate.parse(startDateStr);
            } else {
                startDate = java.time.LocalDate.now();
            }

            // Tạo danh sách 7 ngày liên tiếp
            java.util.List<String> dates = new java.util.ArrayList<>();
            for (int i = 0; i < 7; i++) {
                dates.add(startDate.plusDays(i).toString());
            }

            // Tính prev/nextStartDate
            String prevStartDate = startDate.minusDays(7).toString();
            String nextStartDate = startDate.plusDays(7).toString();

            ScheduleDAO dao = new ScheduleDAO();
            List<ShowtimeSchedule> schedules = dao.getAllShowtimes();

            // Gom các suất chiếu theo ngày và giờ, chỉ lấy trong 7 ngày
            java.util.Set<String> timeSet = new java.util.TreeSet<>();
            java.util.Map<String, java.util.Map<String, java.util.List<ShowtimeSchedule>>> scheduleMap = new java.util.HashMap<>();

            java.time.LocalDate endDate = startDate.plusDays(6);
            for (ShowtimeSchedule s : schedules) {
                if (s.getStartTime() != null) {
                    java.time.LocalDate date = s.getStartTime().toLocalDateTime().toLocalDate();
                    if (!date.isBefore(startDate) && !date.isAfter(endDate)) {
                        java.time.LocalTime time = s.getStartTime().toLocalDateTime().toLocalTime();
                        String dateStr = date.toString();
                        String timeStr = time.toString();
                        timeSet.add(timeStr);
                        scheduleMap.putIfAbsent(dateStr, new java.util.HashMap<>());
                        scheduleMap.get(dateStr).putIfAbsent(timeStr, new java.util.ArrayList<>());
                        scheduleMap.get(dateStr).get(timeStr).add(s);
                    }
                }
            }

            // Sắp xếp timeSet thành list
            java.util.List<String> times = new java.util.ArrayList<>(timeSet);
            java.util.Collections.sort(times);

            request.setAttribute("dates", dates);
            request.setAttribute("times", times);
            request.setAttribute("scheduleMap", scheduleMap);
            request.setAttribute("prevStartDate", prevStartDate);
            request.setAttribute("nextStartDate", nextStartDate);
        } catch (Exception e) {
            request.setAttribute("error", "Không thể lấy lịch chiếu phim");
        }
        // Truyền thời gian hiện tại (millis) cho JSP để so sánh
        request.setAttribute("now", System.currentTimeMillis());
        request.getRequestDispatcher("Views/agenda.jsp").forward(request, response);
    }
}
