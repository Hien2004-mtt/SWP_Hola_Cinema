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
        try{
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        int totalSeat = Integer.parseInt(request.getParameter("totalSeat"));
        String description = request.getParameter("description");
        AuditoriumDAO aud = new AuditoriumDAO();
        aud.update(new Auditorium(id, name, totalSeat,false,description));
        request.getSession().setAttribute("messageAuditorium", "Đã sửa phòng:"+name+",có tổng số ghế là: "+totalSeat);
        response.sendRedirect("listAuditorium");
        }catch(Exception e){
            e.printStackTrace();
            request.getSession().setAttribute("messageAuditorium", "Đã sảy ra lỗi vui lòng thử lại");
            response.sendRedirect("listAuditorium");
        }
        
        }
}
