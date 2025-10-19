/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controllers;

import DAL.MovieDAO;
import DAL.ShowtimeDAO;
import Models.Movie;
import Models.Showtime;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author Admin
 */
public class ShowtimeSelectionServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ShowtimeSelectionServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ShowtimeSelectionServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        ShowtimeDAO std = new ShowtimeDAO();
        MovieDAO md = new MovieDAO();
        try {
            //lấy movie id khi ng dùng chọn phim
            String movie_raw = request.getParameter("movieId");
            Integer movieId = null;
            if(movie_raw != null){
                // Nếu tìm thấy id phim thì lưu vào session
                movieId = Integer.parseInt(movie_raw);
                session.setAttribute("movieId", movieId);
            } else{
                movieId = (Integer) session.getAttribute("moviId");
            }
            if(movieId == null){ // nếu movie id k hợp lệ
                request.setAttribute("error", "Vui lòng chọn lại phim");
                request.getRequestDispatcher("Views/home.jsp").forward(request, response);
                return;
            }
            //Lấy danh sách suất chiếu từ db
            List<Showtime> st = std.getAllShowtimeByMovieId(movieId);
            request.setAttribute("showtime", st);
            //Lấy tiêu đề phim từ movie id
            Movie m = md.getMovieById(movieId);
            if(m !=  null){
                request.setAttribute("movieTitle", m.getTitle());
            }else{
                request.setAttribute("movieTitle", "Không xác định");
            }
            //truyền movie id sang jsp
                        request.setAttribute("movieId", movieId);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi vui lòng reload lại trang");
        }
        request.getRequestDispatcher("Views/Showtime.jsp").forward(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
