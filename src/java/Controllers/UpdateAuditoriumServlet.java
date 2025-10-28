package Controllers;

import DAL.AuditoriumDAO;
import Models.Auditorium;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class UpdateAuditoriumServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        AuditoriumDAO aud = new AuditoriumDAO();
        Auditorium a = aud.getById(id);
        request.setAttribute("auditorium", a);
        request.getRequestDispatcher("Views/UpdateAuditorium.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        int totalSeat = Integer.parseInt(request.getParameter("totalSeat"));

        AuditoriumDAO aud = new AuditoriumDAO();
        aud.update(new Auditorium(id, name, totalSeat, false));
System.out.println("Đã vào UpdateAuditoriumServlet");
        response.sendRedirect("listAuditorium");
    }
}
