package Controllers;

import DAL.RevenueDAO;
import Models.RevenueRecord;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin/revenue")
public class RevenueController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String fromDate = request.getParameter("from");
        String toDate = request.getParameter("to");
        String movieName = request.getParameter("movieName");
        String minStr = request.getParameter("min");
        String maxStr = request.getParameter("max");
        String action = request.getParameter("action"); // xác định nút nào được bấm
        String sortOrder = null;

        if (fromDate == null || toDate == null) {
            fromDate = "2025-01-01";
            toDate = "2025-12-31";
        }

        BigDecimal minRevenue = (minStr != null && !minStr.isEmpty()) ? new BigDecimal(minStr) : null;
        BigDecimal maxRevenue = (maxStr != null && !maxStr.isEmpty()) ? new BigDecimal(maxStr) : null;

        // xác định hành động
        if ("sortAsc".equals(action)) {
            sortOrder = "asc";
        } else if ("sortDesc".equals(action)) {
            sortOrder = "desc";
        }

        RevenueDAO dao = new RevenueDAO();
        List<RevenueRecord> list = dao.getRevenueByCondition(fromDate, toDate, movieName, minRevenue, maxRevenue, sortOrder);
        request.setAttribute("revenueList", list);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("movieName", movieName);
        request.setAttribute("min", minStr);
        request.setAttribute("max", maxStr);

        RequestDispatcher rd = request.getRequestDispatcher("/Views/revenue.jsp");
        rd.forward(request, response);
    }
}
