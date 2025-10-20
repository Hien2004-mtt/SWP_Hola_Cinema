/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAL.ActorDAO;
import DAL.GenreDAO;
import DAL.MovieDAO;
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

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        

        try {
            List<Movie> movies;
            if (keyword != null && !keyword.trim().isEmpty()) {
                movies = movieDAO.searchMoviesByTitle(keyword);
            } else {
                movies = movieDAO.getAllMovies();
            }

            Map<Integer, List<String>> movieGenres = new HashMap<>();
            Map<Integer, List<String>> movieActors = new HashMap<>();

            for (Movie m : movies) {
                movieGenres.put(m.getMovieId(), genreDAO.getGenresByMovieId(m.getMovieId()));
                movieActors.put(m.getMovieId(), actorDAO.getActorsByMovieId(m.getMovieId()));
            }

            request.setAttribute("movieList", movies);
            request.setAttribute("movieGenres", movieGenres);
            request.setAttribute("movieActors", movieActors);

            request.getRequestDispatcher("/Views/movie_management.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
