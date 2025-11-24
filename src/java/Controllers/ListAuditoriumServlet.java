package Controllers;

import Dao.AuditoriumDAO;
import Models.Auditorium;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ListAuditoriumServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AuditoriumDAO aud = new AuditoriumDAO();

        List<Auditorium> list = aud.getAllForManager();

        // Tìm kiếm
        String q = request.getParameter("q");
        if (q != null && !q.trim().isEmpty()) {
            q = q.trim().toLowerCase();
            List<Auditorium> filtered = new ArrayList<>();
            for (Auditorium a : list) {
                if (String.valueOf(a.getAuditoriumId()).contains(q)
                        || (a.getName() != null && a.getName().toLowerCase().contains(q))) {
                    filtered.add(a);
                }
            }
            list = filtered;
        }

        // Sắp xếp
        String sort = request.getParameter("sort");
        String dir = request.getParameter("dir");
        if (sort != null && dir != null) {
            Comparator<Auditorium> comp = null;
            switch (sort) {
                case "id":
                    comp = Comparator.comparingInt(Auditorium::getAuditoriumId);
                    break;
                case "name":
                    comp = Comparator.comparing(a -> a.getName() == null ? "" : a.getName(),
                            String.CASE_INSENSITIVE_ORDER);
                    break;
                case "total":
                    comp = Comparator.comparingInt(Auditorium::getTotalSeat);
                    break;
                case "description":
                    comp = Comparator.comparing(
                            a -> a.getDescription() == null ? "" : a.getDescription(),
                            String.CASE_INSENSITIVE_ORDER);
                default:
                    comp = Comparator.comparingInt(Auditorium::getAuditoriumId);
                    break;
            }
            if ("desc".equalsIgnoreCase(dir)) {
                comp = comp.reversed();
            }
            list.sort(comp);
        }
        int pageSize = 5;
        int page = 1;
        String pageParam = request.getParameter("page");
        if(pageParam != null && pageParam.matches("\\d+")){
            page = Integer.parseInt(pageParam);
        }
        int totalItem = list.size();
        int totalPage = (int) Math.ceil((double) totalItem/pageSize);
        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalItem);
        List<Auditorium> paginatedList = new ArrayList<>();
        if(fromIndex < toIndex){
            paginatedList = list.subList(fromIndex, toIndex);
        }
        request.setAttribute("list", paginatedList);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPage);
        request.setAttribute("sort", sort == null ? "" : sort);
        request.setAttribute("dir", dir == null ? "" : dir);
        request.setAttribute("q", q == null ? "" : q);
        request.getRequestDispatcher("Views/Auditorium.jsp").forward(request, response);
    }
}
