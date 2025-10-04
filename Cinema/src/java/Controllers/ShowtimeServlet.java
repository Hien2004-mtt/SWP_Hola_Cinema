package Controllers;

import DAL.MovieDAO;
import DAL.ShowtimeDAO;
import Models.Movie;
import Models.Showtime;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

public class ShowtimeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        ShowtimeDAO stDAO = new ShowtimeDAO();
        MovieDAO mdao = new MovieDAO();

        try {
            String movieIdRaw = request.getParameter("movieId");
            Integer movieId = null;

            if (movieIdRaw != null) {
                movieId = Integer.parseInt(movieIdRaw);
                //luu movieId vao session
                session.setAttribute("movieId", movieId);
            } else {
                //neu request k co thi lay tu session ra
                movieId = (Integer) session.getAttribute("movieId");
            }
            //check xem movieId co ton tai ko
            if (movieId == null) {
                request.setAttribute("error", "Không xác định được phim bạn đang chọn!");
                request.getRequestDispatcher("Views/home.jsp").forward(request, response);
                return;
            }

            //lay cac suat chien trong database
            List<Showtime> showtimes = stDAO.getAllShowtimeByMovieId(movieId);
            request.setAttribute("showtimes", showtimes);

            //lay cac thong tin ve phim theo Id
            Movie movie = mdao.getMovieById(movieId);
            if (movie != null) {
                request.setAttribute("movieTitle", movie.getTitle());
            } else {
                request.setAttribute("movieTitle", "Không xác định");
            }

            request.setAttribute("movieId", movieId);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách suất chiếu!");
        }

        request.getRequestDispatcher("Views/Showtime.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String showtimeIdRaw = request.getParameter("showtimeId");

        if (showtimeIdRaw != null && !showtimeIdRaw.isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("selectedShowtimeId", Integer.parseInt(showtimeIdRaw));
            response.sendRedirect("Seat");
        } else {
            request.setAttribute("error", "Vui lòng chọn một suất chiếu trước khi tiếp tục.");
            doGet(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet hiển thị danh sách suất chiếu và xử lý chọn suất chiếu.";
    }
}
