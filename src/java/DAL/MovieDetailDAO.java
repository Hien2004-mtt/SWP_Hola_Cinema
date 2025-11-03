package DAL;

import Models.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MovieDetailDAO {

//    // ================== LẤY THÔNG TIN PHIM CHÍNH ==================
//    public Movie getMovieDetail(int movieId) {
//        Movie movie = null;
//        String sql = """
//            SELECT m.*, 
//                   d.name AS director_name, 
//                   d.bio AS director_bio, 
//                   d.photo_url AS director_photo
//            FROM Movie m
//            LEFT JOIN Director d ON m.director_id = d.director_id
//            WHERE m.movie_id = ?
//        """;
//        try (Connection conn = DBContext.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setInt(1, movieId);
//            ResultSet rs = ps.executeQuery();
//
//            if (rs.next()) {
//                movie = new Movie();
//                movie.setMovieId(rs.getInt("movie_id"));
//                movie.setTitle(rs.getString("title"));
//                movie.setDescription(rs.getString("description"));
//                movie.setDurationMinutes(rs.getInt("duration_minutes"));
//                movie.setLanguage(rs.getString("language"));
//                movie.setReleaseDate(rs.getDate("release_date"));
//                movie.setRating(rs.getString("rating"));
//                movie.setPosterUrl(rs.getString("poster_url"));
//                movie.setStatus(rs.getString("status"));
//                movie.setDirectorId(rs.getInt("director_id"));
//
//                // Thông tin đạo diễn
//                movie.setDirectorName(rs.getString("director_name"));
//                movie.setDirectorBio(rs.getString("director_bio"));
//                movie.setDirectorPhoto(rs.getString("director_photo"));
//            }
//
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return movie;
//    }

    // ================== LẤY DIỄN VIÊN ==================
    public List<Actor> getActorsByMovie(int movieId) {
        List<Actor> list = new ArrayList<>();
        String sql = """
            SELECT a.actor_id, a.name, a.photo_url, ma.role_name
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
                a.setPhotoUrl(rs.getString("photo_url"));
                a.setRoleName(rs.getString("role_name"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ================== LẤY THỂ LOẠI ==================
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

    // ================== LẤY REVIEW ==================
    public List<Review> getReviewsByMovie(int movieId) {
        List<Review> list = new ArrayList<>();
        String sql = """
            SELECT r.*, u.name AS user_name
            FROM Review r
            JOIN Users u ON r.user_id = u.user_id
            WHERE r.movie_id = ?
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
                r.setMovieId(rs.getInt("movie_id"));
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
}
