package DAL;

import Models.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MovieDetailDAO {

    // ================== LẤY THÔNG TIN CHI TIẾT PHIM ==================
    public Movie getMovieDetail(int movieId) {
        Movie movie = null;
        String sql = """
            SELECT *
            FROM Movie
            WHERE movie_id = ?
        """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, movieId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                movie = new Movie();
                movie.setMovieId(rs.getInt("movie_id"));
                movie.setTitle(rs.getString("title"));
                movie.setDescription(rs.getString("description"));
                movie.setDurationMinutes(rs.getInt("duration_minutes"));
                movie.setLanguage(rs.getString("language"));
                movie.setReleaseDate(rs.getDate("release_date"));
                movie.setRating(rs.getString("rating"));
                movie.setDirectorName(rs.getString("director_name"));
                movie.setPosterUrl(rs.getString("poster_url"));
                movie.setTrailerUrl(rs.getString("trailer_url"));
                movie.setStatus(rs.getString("status"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return movie;
    }

    // ================== LẤY DANH SÁCH DIỄN VIÊN ==================
    public List<Actor> getActorsByMovie(int movieId) {
        List<Actor> list = new ArrayList<>();
        String sql = """
            SELECT a.actor_id, a.name
            FROM Movie_Actor ma
            JOIN Actor a ON ma.actor_id = a.actor_id
            WHERE ma.movie_id = ?
        """;

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, movieId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Actor a = new Actor();
                a.setActorId(rs.getInt("actor_id"));
                a.setName(rs.getString("name"));
                list.add(a);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ================== LẤY THỂ LOẠI PHIM ==================
    public List<String> getGenresByMovie(int movieId) {
        List<String> list = new ArrayList<>();
        String sql = """
            SELECT g.name
            FROM Movie_Genre mg
            JOIN Genre g ON mg.genre_id = g.genre_id
            WHERE mg.movie_id = ?
        """;

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, movieId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("name"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ================== LẤY REVIEW THEO PHIM ==================
    public List<Review> getReviewsByMovie(int movieId) {
        List<Review> list = new ArrayList<>();
        String sql = """
            SELECT r.review_id, r.user_id, r.rating, r.comment, r.created_at, u.name AS user_name
            FROM Review r
            JOIN Users u ON r.user_id = u.user_id
            JOIN Booking b ON r.booking_id = b.booking_id
            JOIN BookingItem bi ON b.booking_id = bi.booking_id
            JOIN Showtime s ON bi.showtime_id = s.showtime_id
            WHERE s.movie_id = ?
            ORDER BY r.created_at DESC
        """;

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, movieId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Review r = new Review();
                r.setReviewId(rs.getInt("review_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setRating(rs.getInt("rating"));
                r.setComment(rs.getString("comment"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                r.setUserName(rs.getString("user_name"));
                list.add(r);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ================== TEST MAIN ==================
    public static void main(String[] args) {
        MovieDetailDAO dao = new MovieDetailDAO();

        System.out.println("=== TEST getMovieDetail(3) ===");
        Movie m = dao.getMovieDetail(3);
        if (m != null) {
            System.out.println("Title: " + m.getTitle());
            System.out.println("Director: " + m.getDirectorName());
            System.out.println("Status: " + m.getStatus());
        }

        System.out.println("\n=== TEST getActorsByMovie(3) ===");
        for (Actor a : dao.getActorsByMovie(3)) {
            System.out.println(a.getName());
        }

        System.out.println("\n=== TEST getGenresByMovie(3) ===");
        for (String g : dao.getGenresByMovie(3)) {
            System.out.println(g);
        }

        System.out.println("\n=== TEST getReviewsByMovie(3) ===");
        for (Review r : dao.getReviewsByMovie(3)) {
            System.out.println(r.getUserName() + " - " + r.getRating() + "★ - " + r.getComment());
        }
    }
}
