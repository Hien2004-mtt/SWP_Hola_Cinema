package Controllers;

import Dao.DashboardDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class DashboardServlet extends HttpServlet {
    private DashboardDAO dao = new DashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        double revenue = dao.getTotalRevenue();
        int tickets = dao.getTicketsSold();
        int customers = dao.getTotalCustomers();

        request.setAttribute("revenue", revenue);
        request.setAttribute("tickets", tickets);
        request.setAttribute("customers", customers);

        // ✅ forward tới file JSP đúng vị trí
        RequestDispatcher rd = request.getRequestDispatcher("/Views/dashboard.jsp");
        rd.forward(request, response);
    }
}
