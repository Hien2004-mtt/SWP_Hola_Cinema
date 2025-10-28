/*
 * Controller: Hiển thị trang chủ (Home Page)
 * - Nếu chưa login: vẫn xem được danh sách phim
 * - Nếu đã login: hiển thị thêm tên người dùng
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

        // 🔹 Lấy danh sách phim
        List<Movie> nowShowing = movieDAO.getNowShowingMovies();
        List<Movie> comingSoon = movieDAO.getComingSoonMovies();

        // 🔹 Gửi dữ liệu sang JSP
        request.setAttribute("moviesNow", nowShowing);
        request.setAttribute("moviesComing", comingSoon);

        // 🔹 Kiểm tra session (để hiển thị phần user nếu đã login)
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            request.setAttribute("loggedUser", session.getAttribute("user"));
        }

        // 🔹 Chuyển hướng sang trang JSP view
        request.getRequestDispatcher("home.jsp").forward(request, response);
    }
}
