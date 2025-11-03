package Controllers;

import DAL.AdminDAO;
import Models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {

    private AdminDAO adminDAO;

    @Override
    public void init() throws ServletException {
        adminDAO = new AdminDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("../login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.getRole() != 0) { 
            response.sendRedirect("../home");
            return;
        }

        double todayRevenue = adminDAO.getTodayRevenue();
        double monthRevenue = adminDAO.getMonthRevenue();
        double yearRevenue = adminDAO.getYearRevenue();
        int totalTickets = adminDAO.getTotalTicketsSold();
        int nowShowing = adminDAO.getNowShowingCount();
        int comingSoon = adminDAO.getComingSoonCount();
        int activeCinemas = adminDAO.getActiveCinemas();
        int totalUsers = adminDAO.getTotalUsers();
        double avgRating = adminDAO.getAverageRating();

        double[] monthlyRevenue = adminDAO.getMonthlyRevenueThisYear();

        request.setAttribute("todayRevenue", todayRevenue);
        request.setAttribute("monthRevenue", monthRevenue);
        request.setAttribute("yearRevenue", yearRevenue);
        request.setAttribute("totalTickets", totalTickets);
        request.setAttribute("nowShowing", nowShowing);
        request.setAttribute("comingSoon", comingSoon);
        request.setAttribute("activeCinemas", activeCinemas);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("avgRating", avgRating);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("adminUser", user);

        request.getRequestDispatcher("/Views/admin/dashboard.jsp").forward(request, response);
    }
}
