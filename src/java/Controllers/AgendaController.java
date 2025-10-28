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
                String specificDateStr = request.getParameter("specificDate");
                String startDateStr = request.getParameter("startDate");
                java.time.LocalDate startDate;
                if (startDateStr != null && !startDateStr.isEmpty()) {
                    startDate = java.time.LocalDate.parse(startDateStr);
                } else {
                    startDate = java.time.LocalDate.now();
                }

                // Nếu có specificDate thì hiển thị 3 ngày trước, ngày tìm kiếm, 3 ngày sau
                java.util.List<String> dates = new java.util.ArrayList<>();
                if (specificDateStr != null && !specificDateStr.isEmpty()) {
                    java.time.LocalDate specificDate = java.time.LocalDate.parse(specificDateStr);
                    for (int i = -3; i <= 3; i++) {
                        dates.add(specificDate.plusDays(i).toString());
                    }
                } else {
                    for (int i = 0; i < 7; i++) {
                        dates.add(startDate.plusDays(i).toString());
                    }
                }

                // Tính prev/nextStartDate
                String prevStartDate = startDate.minusDays(7).toString();
                String nextStartDate = startDate.plusDays(7).toString();

                ScheduleDAO dao = new ScheduleDAO();
                List<ShowtimeSchedule> schedules = dao.getAllShowtimes();

                java.util.Set<String> timeSet = new java.util.TreeSet<>();
                java.util.Map<String, java.util.Map<String, java.util.List<ShowtimeSchedule>>> scheduleMap = new java.util.HashMap<>();

                // Luôn lấy lịch chiếu cho tất cả các ngày trong danh sách dates
                java.util.Set<String> dateSet = new java.util.HashSet<>(dates);
                for (ShowtimeSchedule s : schedules) {
                    if (s.getStartTime() != null) {
                        java.time.LocalDate date = s.getStartTime().toLocalDateTime().toLocalDate();
                        String dateStr = date.toString();
                        if (dateSet.contains(dateStr)) {
                            java.time.LocalTime time = s.getStartTime().toLocalDateTime().toLocalTime();
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
            request.setAttribute("now", System.currentTimeMillis());
            request.getRequestDispatcher("Views/agenda.jsp").forward(request, response);
    }
}
