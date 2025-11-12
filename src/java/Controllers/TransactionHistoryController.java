package Controllers;

import DAO.TransactionHistoryDAO;
import Models.TransactionHistory;
import Models.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class TransactionHistoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // 🧩 Tham số lọc & phân trang
        String timeFilter = request.getParameter("timeFilter");
        String sortOrder = request.getParameter("sortOrder");
        int page = 1;
        int recordsPerPage = 10;

        if (timeFilter == null) timeFilter = "all";
        if (sortOrder == null) sortOrder = "desc";
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        TransactionHistoryDAO dao = new TransactionHistoryDAO();
        int totalRecords = dao.getTotalUserTransactionCount(user.getUserId(), timeFilter);
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        List<TransactionHistory> transactions = dao.getUserTransactionsByPage(
                user.getUserId(),
                (page - 1) * recordsPerPage,
                recordsPerPage,
                timeFilter,
                sortOrder
        );

        request.setAttribute("transactions", transactions);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("timeFilter", timeFilter);
        request.setAttribute("sortOrder", sortOrder);

        RequestDispatcher rd = request.getRequestDispatcher("/Views/transactionHistory.jsp");
        rd.forward(request, response);
    }
}
