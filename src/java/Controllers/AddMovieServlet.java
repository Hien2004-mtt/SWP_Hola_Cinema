/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import Dao.ActorDAO;
import Dao.GenreDAO;
import Dao.MovieDAO;
import Models.Movie;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

/**
 *
 * @author dinhh
 */
@WebServlet("/add_movie")
public class AddMovieServlet extends HttpServlet {

    private MovieDAO movieDAO;
    private GenreDAO genreDAO;
    private ActorDAO actorDAO;

    @Override
    public void init() throws ServletException {
        genreDAO = new GenreDAO();
        actorDAO = new ActorDAO();
        movieDAO = new MovieDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("genres", genreDAO.getAllGenres());
            request.setAttribute("actors", actorDAO.getAllActors());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/Views/add_movie.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {

            // Lấy dữ liệu từ form
            String posterUrl = request.getParameter("posterUrl");
            String title = request.getParameter("title");
            String rating = request.getParameter("rating");
            String durationStr = request.getParameter("duration");
            String language = request.getParameter("language");
            String releaseDateStr = request.getParameter("releaseDate");
            String status = request.getParameter("status");
            String trailerUrl = request.getParameter("trailerUrl");
            String directorName = request.getParameter("directorName");
            String description = request.getParameter("description");
            String[] genreIdsArray = request.getParameterValues("genres[]");
            String[] actorIdsArray = request.getParameterValues("actors[]");

            if (posterUrl == null || posterUrl.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Poster URL cannot be empty!");
                doGet(request, response);
                return;
            }

            if (movieDAO.movieExists(title, directorName)) {
                request.setAttribute("errorMessage",
                        "A movie with this title and director already exists!");
                doGet(request, response);
                return;
            }

            int durationMinutes = 0;
            if (durationStr != null && !durationStr.trim().isEmpty()) {
                try {
                    durationMinutes = Integer.parseInt(durationStr);
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "Duration must be a valid number.");
                    doGet(request, response);
                    return;
                }
            } else {
                request.setAttribute("errorMessage", "Duration is a required field.");
                doGet(request, response);
                return;
            }

            LocalDate releaseDate = null;
            if (releaseDateStr != null && !releaseDateStr.trim().isEmpty()) {
                try {
                    releaseDate = LocalDate.parse(releaseDateStr);
                } catch (DateTimeParseException e) {
                    request.setAttribute("errorMessage", "Release Date must be in YYYY-MM-DD format.");
                    doGet(request, response);
                    return;
                }
            }

            List<Integer> genreList = new ArrayList<>();
            if (genreIdsArray != null) {
                for (String g : genreIdsArray) {
                    genreList.add(Integer.parseInt(g));
                }
            }

            List<Integer> actorList = new ArrayList<>();
            if (actorIdsArray != null) {
                for (String a : actorIdsArray) {
                    actorList.add(Integer.parseInt(a));
                }
            }

            // Tạo đối tượng Movie
            Movie movie = new Movie();
            movie.setTitle(title);
            movie.setRating(rating);
            movie.setDurationMinutes(durationMinutes);
            movie.setLanguage(language);
            movie.setReleaseDate(releaseDate);
            movie.setStatus(status);
            movie.setPosterUrl(posterUrl);
            movie.setTrailerUrl(trailerUrl);
            movie.setDirectorName(directorName);
            movie.setDescription(description);
            movie.setGenreIds(genreList);
            movie.setActorIds(actorList);

            int newMovieId = movieDAO.addMovie(movie);

            if (newMovieId != -1) {
                movieDAO.addMovieGenres(newMovieId, movie.getGenreIds());
                movieDAO.addMovieActors(newMovieId, movie.getActorIds());
            }

            response.sendRedirect(request.getContextPath() + "/movie_management");
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}
