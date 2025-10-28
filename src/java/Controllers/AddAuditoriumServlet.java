package Controllers;

import DAL.AuditoriumDAO;
import Models.Auditorium;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AddAuditoriumServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("Views/AddAuditorium.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
       

        String name = request.getParameter("name");
        int totalSeat = Integer.parseInt(request.getParameter("totalSeat"));

        AuditoriumDAO aud = new AuditoriumDAO();
        aud.insert(new Auditorium(0,name,totalSeat,false));
       response.sendRedirect("listAuditorium");

    }
}
