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
 * @author USER
 */
public class ShowtimeServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
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
            out.println("<title>Servlet ShowtimeServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ShowtimeServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String movieIdRaw = request.getParameter("movieId");
        try {
            int movieId = Integer.parseInt(movieIdRaw);

            // Lấy danh sách suất chiếu
            ShowtimeDAO stDAO = new ShowtimeDAO();
            List<Showtime> showtimes = stDAO.getAllShowtimeByMovieId(movieId);
            request.setAttribute("showtimes", showtimes);

            // Lấy thông tin phim
            MovieDAO mdao = new MovieDAO();
            Movie movie = mdao.getMovieById(movieId);
            if (movie != null) {
                request.setAttribute("movieTitle", movie.getTitle());
            } else {
                request.setAttribute("movieTitle", "Không xác định");
            }

            // Truyền lại movieId nếu cần dùng tiếp
            request.setAttribute("movieId", movieId);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách");
        }

        request.getRequestDispatcher("Views/Showtime.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String ShowtimeId_raw = request.getParameter("showtimeId");
        if (ShowtimeId_raw != null && !ShowtimeId_raw.isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("selectedShowtimeId", Integer.parseInt(ShowtimeId_raw));
            response.sendRedirect("Seat");
        } else {
            request.setAttribute("error", "Vui lòng chọn suất chiếu");
            doGet(request, response);
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
