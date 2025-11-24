package Controllers;

import Dao.MovieDAO;
import Dao.ShowtimeDAO;
import Models.Movie;
import Models.Showtime;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ShowtimeSelectionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println(">>> ShowtimeSelectionServlet triggered!");

        HttpSession session = request.getSession();
        ShowtimeDAO showtimeDAO = new ShowtimeDAO();
        MovieDAO movieDAO = new MovieDAO();

        try {
            String movieRaw = request.getParameter("movieId");
            Integer movieId = null;

            if (movieRaw != null) {
                movieId = Integer.parseInt(movieRaw);
                session.setAttribute("movieId", movieId);
            } else {
                movieId = (Integer) session.getAttribute("movieId");
            }

            if (movieId == null) {
                request.setAttribute("error", " Vui lòng chọn lại phim.");
                response.sendRedirect("home");
                return;
            }

            //  Lấy danh sách suất chiếu theo phim
            List<Showtime> showtimes = showtimeDAO.getAllShowtimeByMovieId(movieId);
            request.setAttribute("showtimes", showtimes);

            //  Lấy tên phim
            Movie movie = movieDAO.getMovieById(movieId);
            request.setAttribute("movieTitle", movie != null ? movie.getTitle() : "Không xác định");
            request.setAttribute("movieId", movieId);

            //  Nếu phim không có suất chiếu nào
            if (showtimes == null || showtimes.isEmpty()) {
                request.setAttribute("noShowtime", "Xin lỗi, hiện tại phim đang không có suất chiếu,xin hãy chọn vào một ngày khác");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "️ Đã xảy ra lỗi, vui lòng tải lại trang.");
        }

        request.getRequestDispatcher("Views/Showtime.jsp").forward(request, response);
    }
}
