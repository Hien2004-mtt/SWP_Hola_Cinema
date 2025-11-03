/*
 * Controller: Hiển thị trang chủ (Home Page)
 * - Nếu chưa login: vẫn xem được danh sách phim
 * - Nếu đã login: hiển thị thêm tên người dùng
 * - Hỗ trợ tìm kiếm phim theo tên (param ?q=)
 */
package Controllers;

import DAL.MovieDAO;
import Models.Movie;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/home")
public class HomeController extends HttpServlet {

    private final MovieDAO movieDAO = new MovieDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("q");
        List<Movie> nowShowing;
        List<Movie> comingSoon;

        if (keyword != null && !keyword.trim().isEmpty()) {
            nowShowing = movieDAO.userSearchMoviesByTitle(keyword.trim());
            comingSoon = null; 
            request.setAttribute("searchKeyword", keyword);
        } else {
            nowShowing = movieDAO.getNowShowingMovies();
            comingSoon = movieDAO.getComingSoonMovies();
        }

        request.setAttribute("moviesNow", nowShowing);
        request.setAttribute("moviesComing", comingSoon);

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            request.setAttribute("loggedUser", session.getAttribute("user"));
        }

        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}
