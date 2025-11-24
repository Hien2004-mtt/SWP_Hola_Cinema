package Controllers;

import Dao.MovieDetailDAO;
import Models.*;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/movieDetail")
public class MovieDetailController extends HttpServlet {

    private final MovieDetailDAO dao = new MovieDetailDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Movie movie = dao.getMovieDetail(id);
        List<Actor> actors = dao.getActorsByMovie(id);
        List<String> genres = dao.getGenresByMovie(id);
        List<Review> reviews = dao.getReviewsByMovie(id);

        // Gán dữ liệu vào request
        request.setAttribute("movie", movie);
        request.setAttribute("actors", actors);
        request.setAttribute("genres", genres);
        request.setAttribute("reviews", reviews);

        request.getRequestDispatcher("movie_detail.jsp").forward(request, response);
    }
}
