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

        TransactionHistoryDAO dao = new TransactionHistoryDAO();
        List<TransactionHistory> transactions = dao.getUserTransactions(user.getUserId());
        request.setAttribute("transactions", transactions);

        RequestDispatcher rd = request.getRequestDispatcher("/Views/transactionHistory.jsp");
        rd.forward(request, response);
    }
}
