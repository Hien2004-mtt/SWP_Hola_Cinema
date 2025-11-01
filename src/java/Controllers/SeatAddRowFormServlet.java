package Controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;


public class SeatAddRowFormServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int auditoriumId = Integer.parseInt(request.getParameter("auditoriumId"));
        request.setAttribute("auditoriumId", auditoriumId);
        request.getRequestDispatcher("Views/AddSeatRow.jsp").forward(request, response);
    }
}
