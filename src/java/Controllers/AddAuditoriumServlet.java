package Controllers;

import Dao.AuditoriumDAO;
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
      try{
        String name = request.getParameter("name");
        int totalSeat = Integer.parseInt(request.getParameter("totalSeat"));
        String description = request.getParameter("description");
        AuditoriumDAO aud = new AuditoriumDAO();
        aud.insert(new Auditorium(0,name,totalSeat,false,description));
        request.getSession().setAttribute("messageAuditorium", "Thêm phòng chiếu:"+name+",có tổng số ghế là:"+totalSeat);
       response.sendRedirect("listAuditorium");
      }catch(Exception e){
          e.printStackTrace();
          request.getSession().setAttribute("messageAuditorium", "Đã xảy ra lỗi vui lòng thử lại");
          response.sendRedirect("listAuditorium");
      }
    }
}
