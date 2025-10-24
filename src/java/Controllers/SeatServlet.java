/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAL.AuditoriumDAO;
import DAL.MovieDAO;
import DAL.SeatDAO;
import DAL.ShowtimeDAO;
import Models.Movie;
import Models.Seat;
import Models.Showtime;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.PrintWriter;

/**
 *
 * @author USER
 */
public class SeatServlet extends HttpServlet {

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
            out.println("<title>Servlet Seat</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet Seat at " + request.getContextPath() + "</h1>");
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
        SeatDAO seatDAO = new SeatDAO();
        List<Seat> seats = null;
        try {
            seats = seatDAO.getAllSeat();
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể lấy danh sách ghế.");
        }

        //Lấy showtimeId từ session
        HttpSession session = request.getSession();
        Object showtimeObj = session.getAttribute("selectedShowtimeId");
        if (showtimeObj == null) {
            response.sendRedirect("selectionShowtime"); // hoặc trang báo lỗi
            return;
        }

        int showtimeId = (int) showtimeObj;

        //Lấy thông tin suất chiếu
        ShowtimeDAO showtimeDAO = new ShowtimeDAO();
        Showtime st = showtimeDAO.getShowtimeById(showtimeId);
        AuditoriumDAO aud = new AuditoriumDAO();
        String auditoriumName = aud.getAuditoriumNameById(showtimeId);
        if (st == null) {
            request.setAttribute("movieTitle", "Không tìm thấy suất chiếu");
            request.setAttribute("startTime", "Không xác định");
            request.setAttribute("basePrice", 0);
        } else {
            //Lấy thông tin phim
            MovieDAO movieDAO = new MovieDAO();
            Movie m = movieDAO.getMovieById(st.getMovieId());

            if (m != null) {
                request.setAttribute("movieTitle", m.getTitle());
            } else {
                request.setAttribute("movieTitle", "Không tìm thấy phim");
            }
            request.setAttribute("auditoriumName", auditoriumName);
            request.setAttribute("startTime", st.getStartTime());
            request.setAttribute("basePrice", st.getBasePrice());
            request.setAttribute("showtimeId", showtimeId);
            request.setAttribute("movieId", st.getMovieId());

        }

        //Truyền danh sách ghế
        request.setAttribute("seats", seats);
        request.getRequestDispatcher("/Views/Seat.jsp").forward(request, response);
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

        // Lấy danh sách ghế từ form
        String[] selectedSeats = request.getParameterValues("selectedSeats");

        HttpSession session = request.getSession();

        if (selectedSeats != null && selectedSeats.length > 0) {
            // Ghép danh sách ghế thành chuỗi
            String seatList = String.join(", ", selectedSeats);

            // Lưu vào session để khi quay lại vẫn giữ ghế
            session.setAttribute("selectedSeats", selectedSeats);

            // Gửi thông báo sang confirm.jsp
            request.setAttribute("message", "Bạn đã chọn: " + seatList);
        } else {
            request.setAttribute("message", "Bạn chưa chọn ghế nào.");
            // Nếu không chọn thì xóa session cũ
            session.removeAttribute("selectedSeats");
        }

        // Chuyển tiếp sang trang xác nhận
        request.getRequestDispatcher("Views/confirm.jsp").forward(request, response);
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
