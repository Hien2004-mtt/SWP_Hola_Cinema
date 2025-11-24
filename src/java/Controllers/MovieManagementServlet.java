
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import Dao.ActorDAO;
import Dao.GenreDAO;
import Dao.MovieDAO;
import Models.Movie;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author dinhh
 */
@WebServlet("/movie_management")
public class MovieManagementServlet extends HttpServlet {

    private MovieDAO movieDAO;
    private GenreDAO genreDAO;
    private ActorDAO actorDAO;

    @Override
    public void init() {
        movieDAO = new MovieDAO();
        genreDAO = new GenreDAO();
        actorDAO = new ActorDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy tham số filter/search
        String keyword = request.getParameter("keyword");
        String genreId = request.getParameter("genreId");
        String actorId = request.getParameter("actorId");
        String status = request.getParameter("status");
        String rating = request.getParameter("rating");
        String director = request.getParameter("director");
        
        try {
            int page = 1;
            int pageSize = 20; // số phim mỗi trang
            String pageParam = request.getParameter("page");
            
            if (pageParam != null) {
                try {
                    page = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            int offset = (page - 1) * pageSize;
            // Gọi DAO để lọc dữ liệu
            List<Movie> movies = movieDAO.filterMoviesWithPaging(keyword, genreId, actorId, status, rating, director, offset, pageSize);

            // Lấy danh sách genre và actor cho dropdown filter
            request.setAttribute("genres", genreDAO.getAllGenres());
            request.setAttribute("actors", actorDAO.getAllActors());

            // Lấy danh sách genre + actor của từng movie để hiển thị
            Map<Integer, List<String>> movieGenres = new HashMap<>();
            Map<Integer, List<String>> movieActors = new HashMap<>();
            for (Movie m : movies) {
                movieGenres.put(m.getMovieId(), genreDAO.getGenresByMovieId(m.getMovieId()));
                movieActors.put(m.getMovieId(), actorDAO.getActorsByMovieId(m.getMovieId()));
            }

            int totalMovies = movieDAO.countFilteredMovies(keyword, genreId, actorId, status, director);
            int totalPages = (int) Math.ceil((double) totalMovies / pageSize);


            // Gửi dữ liệu sang JSP
            request.setAttribute("movieList", movies);
            request.setAttribute("movieGenres", movieGenres);
            request.setAttribute("movieActors", movieActors);

            // Giữ lại filter values (để form không reset khi lọc)
            request.setAttribute("keyword", keyword);
            request.setAttribute("genreId", genreId);
            request.setAttribute("actorId", actorId);
            request.setAttribute("status", status);
            request.setAttribute("director", director);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            // Forward sang JSP
            request.getRequestDispatcher("/Views/movie_management.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Error loading movie data", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Movie management controller with search and filter support";
    }
}

