package Controllers;

import DAL.AuditoriumDAO;
import Models.Auditorium;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


public class SeatListServlet extends HttpServlet {

    private static final int PAGE_SIZE = 5; // Hiển thị 5 phòng mỗi trang

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            AuditoriumDAO audDAO = new AuditoriumDAO();
            List<Auditorium> allAuditoriums = audDAO.getAll();

            // 🔍 Lấy query tìm kiếm
            String q = request.getParameter("q");
            if (q != null && !q.trim().isEmpty()) {
                String query = q.trim().toLowerCase();
                List<Auditorium> filtered = new ArrayList<>();
                for (Auditorium a : allAuditoriums) {
                    if (String.valueOf(a.getAuditoriumId()).contains(query)
                            || (a.getName() != null && a.getName().toLowerCase().contains(query))) {
                        filtered.add(a);
                    }
                }
                allAuditoriums = filtered;
            }

            // 🔢 Phân trang (an toàn nếu người dùng nhập sai)
            int page = 1;
            try {
                String pageParam = request.getParameter("page");
                if (pageParam != null && !pageParam.isEmpty()) {
                    page = Integer.parseInt(pageParam);
                }
            } catch (NumberFormatException e) {
                page = 1; // reset về trang 1 nếu có lỗi
            }

            int totalAuditoriums = allAuditoriums.size();
            int totalPages = (int) Math.ceil((double) totalAuditoriums / PAGE_SIZE);

            int start = (page - 1) * PAGE_SIZE;
            int end = Math.min(start + PAGE_SIZE, totalAuditoriums);
            List<Auditorium> pageAuditoriums = new ArrayList<>();

            if (totalAuditoriums > 0 && start < totalAuditoriums) {
                pageAuditoriums = allAuditoriums.subList(start, end);
            }

            //  Gửi dữ liệu sang JSP
            request.setAttribute("auditoriums", pageAuditoriums);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("q", q == null ? "" : q);

            request.getRequestDispatcher("Views/SeatList.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("messageSeat", "❌ Lỗi khi tải danh sách phòng chiếu!");
            response.sendRedirect("Views/Error.jsp");
        }
    }
}
