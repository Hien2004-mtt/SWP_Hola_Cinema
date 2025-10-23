/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAL;

import Models.Movie;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author USER
 */
public class MovieDAO {

    public Movie getMovieById(int id) {
        String sql = "SELECT * FROM Movie WHERE movie_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Movie m = new Movie();
                m.setMovieId(rs.getInt("movie_id"));
                m.setTitle(rs.getString("title"));
                m.setDescription(rs.getString("description"));
                m.setDurationMinutes(rs.getInt("duration_minutes"));
                m.setLanguage(rs.getString("language"));
                m.setReleaseDate(rs.getTimestamp("release_date"));
                m.setRating(rs.getString("rating"));
                m.setPosterUrl(rs.getString("poster_url"));
                m.setDirectorId(rs.getInt("director_id"));

                return m;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ Lấy danh sách phim đang chiếu
    public List<Movie> getNowShowingMovies() {
        return getMoviesByStatus("now showing");
    }

    public List<Movie> getComingSoonMovies() {
        return getMoviesByStatus("coming soon");
    }
    // ✅ Lấy phim theo trạng thái (tái sử dụng code)

    private List<Movie> getMoviesByStatus(String status) {
        List<Movie> list = new ArrayList<>();
        String sql = "SELECT * FROM Movie WHERE status = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractMovie(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    // ✅ Hàm phụ để chuyển ResultSet → Movie Object

    private Movie extractMovie(ResultSet rs) throws SQLException {
        Movie m = new Movie();
        m.setMovieId(rs.getInt("movie_id"));
        m.setTitle(rs.getString("title"));
        m.setDescription(rs.getString("description"));
        m.setDurationMinutes(rs.getInt("duration_minutes"));
        m.setLanguage(rs.getString("language"));
        m.setReleaseDate(rs.getDate("release_date"));
        m.setRating(rs.getString("rating"));
        m.setPosterUrl(rs.getString("poster_url"));
        m.setStatus(rs.getString("status"));
        m.setDirectorId(rs.getInt("director_id"));
        return m;
    }

    public static void main(String[] args) {
        MovieDAO dao = new MovieDAO();

        System.out.println("=== TEST: NOW SHOWING MOVIES ===");
        for (Movie m : dao.getNowShowingMovies()) {
            System.out.println(m.getMovieId() + " | " + m.getTitle() + " | " + m.getStatus());
        }

        System.out.println("\n=== TEST: COMING SOON MOVIES ===");
        for (Movie m : dao.getComingSoonMovies()) {
            System.out.println(m.getMovieId() + " | " + m.getTitle() + " | " + m.getStatus());
        }

        System.out.println("\n=== TEST: ALL MOVIES ===");
        for (Movie m : dao.getAllMovies()) {
            System.out.println(m.getMovieId() + " | " + m.getTitle() + " | " + m.getStatus());
        }
    }
    // ✅ Lấy danh sách tất cả phim

    public List<Movie> getAllMovies() {
        List<Movie> list = new ArrayList<>();
        String sql = "SELECT * FROM Movie";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(extractMovie(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

}
