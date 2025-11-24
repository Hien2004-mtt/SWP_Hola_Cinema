package Controllers;

import Dao.FoodDAO;
import Models.Food;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin/foodManagement")
public class FoodManagementController extends HttpServlet {

    private static final int PAGE_SIZE = 8;

    @Override
protected void doGet(HttpServletRequest req, HttpServletResponse res)
        throws ServletException, IOException {

    FoodDAO dao = new FoodDAO();
    String action = req.getParameter("action");

    if ("delete".equals(action)) {
        int id = Integer.parseInt(req.getParameter("id"));
        dao.deleteFood(id);
        res.sendRedirect("foodManagement");
        return;
    } else if ("toggle".equals(action)) {
        int id = Integer.parseInt(req.getParameter("id"));
        dao.toggleStatus(id);
        res.sendRedirect("foodManagement");
        return;
    }

    // Lấy bộ lọc
    String keyword = req.getParameter("name");
    String type = req.getParameter("type");
    String minStr = req.getParameter("min");
    String maxStr = req.getParameter("max");
    String statusStr = req.getParameter("status");
    String sort = req.getParameter("sort");

    BigDecimal min = (minStr != null && !minStr.isEmpty()) ? new BigDecimal(minStr) : null;
    BigDecimal max = (maxStr != null && !maxStr.isEmpty()) ? new BigDecimal(maxStr) : null;

    // Phân trang
    int page = 1;
    try {
        if (req.getParameter("page") != null) page = Integer.parseInt(req.getParameter("page"));
    } catch (NumberFormatException ignored) {}

    int total = dao.countFoodsByFilter(keyword, type, min, max, statusStr);
    int totalPages = (int) Math.ceil(total / 8.0);

    List<Food> list = dao.getFoodsByFilter(keyword, type, min, max, statusStr, sort, page);

    req.setAttribute("foodList", list);
    req.setAttribute("currentPage", page);
    req.setAttribute("totalPages", totalPages);

    // Giữ filter + sort
    req.setAttribute("name", keyword);
    req.setAttribute("type", type);
    req.setAttribute("min", minStr);
    req.setAttribute("max", maxStr);
    req.setAttribute("status", statusStr);
    req.setAttribute("sort", sort);

    req.getRequestDispatcher("/Views/foodManagement.jsp").forward(req, res);
}


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        FoodDAO dao = new FoodDAO();
        String idStr = req.getParameter("foodId");
        String name = req.getParameter("name");
        String type = req.getParameter("type");
        BigDecimal price = new BigDecimal(req.getParameter("price"));
        boolean status = req.getParameter("status") != null;

        Food f = new Food(
                idStr == null || idStr.isEmpty() ? 0 : Integer.parseInt(idStr),
                name, type, price, status);

        if (idStr == null || idStr.isEmpty()) dao.addFood(f);
        else dao.updateFood(f);

        res.sendRedirect("foodManagement");
    }
}
