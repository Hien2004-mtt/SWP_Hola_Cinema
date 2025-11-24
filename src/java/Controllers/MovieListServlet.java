/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controllers;

import Dao.ActorDAO;
import Dao.GenreDAO;
import Dao.MovieDAO;
import Models.Movie;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author dinhh
 */
@WebServlet("/movies")
public class MovieListServlet extends HttpServlet {
    private final MovieDAO movieDAO = new MovieDAO();
    private final GenreDAO genreDAO = new GenreDAO();
    private final ActorDAO actorDAO = new ActorDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            // ✅ Lấy trạng thái filter
            String status = req.getParameter("status");
            if (status == null || (!status.equalsIgnoreCase("now showing") && !status.equalsIgnoreCase("coming soon"))) {
                status = "now showing"; // mặc định
            }

            // ✅ Lọc phim theo trạng thái
            List<Movie> all = movieDAO.getAllMovies();
            List<Movie> filtered = new ArrayList<>();
            for (Movie m : all) {
                if (m.getStatus() != null && m.getStatus().equalsIgnoreCase(status)) {
                    filtered.add(m);
                }
            }

            // ✅ Gán genres và actors cho từng phim
            for (Movie movie : filtered) {
                movie.setGenres(genreDAO.getGenresByMovieId(movie.getMovieId()));
                movie.setActors(actorDAO.getActorsByMovieId(movie.getMovieId()));
            }

            // ✅ Gửi dữ liệu sang JSP
            req.setAttribute("movies", filtered);
            req.setAttribute("statusFilter", status);
            req.getRequestDispatcher("/Views/movie_list.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}

