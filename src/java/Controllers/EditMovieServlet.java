///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//
//package Controllers;
//
//import DAL.ActorDAO;
//import DAL.GenreDAO;
//import DAL.MovieDAO;
//import Models.Movie;
//import jakarta.servlet.RequestDispatcher;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import java.io.IOException;
//import java.time.LocalDate;
//import java.util.ArrayList;
//import java.util.List;
///**
// *
// * @author dinhh
// */
//@WebServlet("/edit_movie")
//public class EditMovieServlet extends HttpServlet {
//
//    private MovieDAO movieDAO;
//    private GenreDAO genreDAO;
//    private ActorDAO actorDAO;
//
//    @Override
//    public void init() throws ServletException {
//        movieDAO = new MovieDAO();
//        genreDAO = new GenreDAO();
//        actorDAO = new ActorDAO();
//    }
//
//    // ===== HIỂN THỊ TRANG EDIT =====
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        try {
//            int movieId = Integer.parseInt(request.getParameter("movieId"));
//
//            // ✅ Lấy thông tin phim
//            Movie movie = movieDAO.getMovieById(movieId);
//
//            // ✅ Lấy danh sách ID genre/actor mà phim có
//            List<Integer> movieGenreIds = movieDAO.getGenreIdsByMovie(movieId);
//            List<Integer> movieActorIds = movieDAO.getActorIdsByMovie(movieId);
//
//            // ✅ Lấy toàn bộ genre và actor (List<String[]>)
//            List<String[]> genres = genreDAO.getAllGenres();
//            List<String[]> actors = actorDAO.getAllActors();
//
//            // ✅ Gửi dữ liệu sang JSP
//            request.setAttribute("movie", movie);
//            request.setAttribute("genres", genres);
//            request.setAttribute("actors", actors);
//            request.setAttribute("movieGenreIds", movieGenreIds);
//            request.setAttribute("movieActorIds", movieActorIds);
//
//            RequestDispatcher dispatcher = request.getRequestDispatcher("/Views/edit_movie.jsp");
//            dispatcher.forward(request, response);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            throw new ServletException(e);
//        }
//    }
//
//    // ===== XỬ LÝ CẬP NHẬT MOVIE =====
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        try {
//            int movieId = Integer.parseInt(request.getParameter("movieId"));
//
//            // ✅ Lấy dữ liệu từ form
//            Movie movie = new Movie();
//            movie.setMovieId(movieId);
//            movie.setTitle(request.getParameter("title"));
//            movie.setRating(request.getParameter("rating"));
//            movie.setDurationMinutes(Integer.parseInt(request.getParameter("duration")));
//            movie.setLanguage(request.getParameter("language"));
//            movie.setReleaseDate(LocalDate.parse(request.getParameter("releaseDate")));
//            movie.setStatus(request.getParameter("status"));
//            movie.setPosterUrl(request.getParameter("posterUrl"));
//            movie.setTrailerUrl(request.getParameter("trailerUrl"));
//            movie.setDirectorName(request.getParameter("directorName"));
//            movie.setDescription(request.getParameter("description"));
//
//            // ✅ Lấy danh sách genre/actor chọn
//            String[] genreIdsArray = request.getParameterValues("genres[]");
//            String[] actorIdsArray = request.getParameterValues("actors[]");
//
//            List<Integer> genreIds = new ArrayList<>();
//            if (genreIdsArray != null) {
//                for (String g : genreIdsArray) {
//                    genreIds.add(Integer.parseInt(g));
//                }
//            }
//
//            List<Integer> actorIds = new ArrayList<>();
//            if (actorIdsArray != null) {
//                for (String a : actorIdsArray) {
//                    actorIds.add(Integer.parseInt(a));
//                }
//            }
//
//            // ✅ Cập nhật phim
//            movieDAO.updateMovie(movie);
//
//            // ✅ Xóa rồi thêm lại quan hệ
//            movieDAO.deleteMovieGenres(movieId);
//            movieDAO.deleteMovieActors(movieId);
//            movieDAO.addMovieGenres(movieId, genreIds);
//            movieDAO.addMovieActors(movieId, actorIds);
//
//            // ✅ Quay về trang quản lý phim
//            response.sendRedirect(request.getContextPath() + "/movie_management");
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            throw new ServletException(e);
//        }
//    }
//}