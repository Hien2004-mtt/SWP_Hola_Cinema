/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAL;

import Models.Movie;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author dinhh
 */
public class MovieDAO extends DBContext {

    // Check if movie exiests
    public boolean movieExists(String title, String directorName) {
        String sql = "SELECT COUNT(*) FROM Movie "
                + "WHERE LOWER(TRIM(title)) = LOWER(TRIM(?)) "
                + "AND LOWER(TRIM(director_name)) = LOWER(TRIM(?))";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, title);
            stmt.setString(2, directorName);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Method to add a new movie and return its generated ID
    public int addMovie(Movie movie) {
        String sql = "INSERT INTO Movie (title, description, duration_minutes, language, release_date, rating, poster_url, trailer_url, director_name, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int movieId = -1;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setNString(1, movie.getTitle());
            ps.setNString(2, movie.getDescription());
            ps.setInt(3, movie.getDurationMinutes());
            ps.setNString(4, movie.getLanguage());

            // Handle possible null release date
            LocalDate releaseDate = movie.getReleaseDate();
            if (releaseDate != null) {
                ps.setDate(5, Date.valueOf(releaseDate));
            } else {
                ps.setNull(5, Types.DATE);
            }

            ps.setString(6, movie.getRating());
            ps.setString(7, movie.getPosterUrl());
            ps.setString(8, movie.getTrailerUrl());
            ps.setNString(9, movie.getDirectorName());
            ps.setString(10, movie.getStatus());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        movieId = rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return movieId;
    }

    // New method to add genres for a movie
    public void addMovieGenres(int movieId, List<Integer> genreIds) {
        String sql = "INSERT INTO Movie_Genre (movie_id, genre_id) VALUES (?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (Integer genreId : genreIds) {
                ps.setInt(1, movieId);
                ps.setInt(2, genreId);
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // New method to add actors for a movie
    public void addMovieActors(int movieId, List<Integer> actorIds) {
        String sql = "INSERT INTO Movie_Actor (movie_id, actor_id) VALUES (?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (Integer actorId : actorIds) {
                ps.setInt(1, movieId);
                ps.setInt(2, actorId);
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

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
                LocalDate releaseDate = m.getReleaseDate();
                if (releaseDate != null) {
                    ps.setDate(5, Date.valueOf(releaseDate));
                } else {
                    ps.setNull(5, Types.DATE);
                }
                m.setRating(rs.getString("rating"));
                m.setPosterUrl(rs.getString("poster_url"));
//            m.setDirectorName(rs.getInt("director_id"));

                return m;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Movie> getAllMovies() throws SQLException {
        List<Movie> list = new ArrayList<>();
        String sql = "SELECT * FROM Movie";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Movie m = new Movie();
                m.setMovieId(rs.getInt("movie_id"));
                m.setTitle(rs.getString("title"));
                m.setRating(rs.getString("rating"));
                m.setDurationMinutes(rs.getInt("duration_minutes"));
                m.setLanguage(rs.getString("language"));
                m.setReleaseDate(rs.getDate("release_date") != null
                        ? rs.getDate("release_date").toLocalDate() : null);
                m.setStatus(rs.getString("status"));
                m.setPosterUrl(rs.getString("poster_url"));
                m.setTrailerUrl(rs.getString("trailer_url"));
                m.setDirectorName(rs.getString("director_name"));
                m.setDescription(rs.getString("description"));
                list.add(m);
            }
        }
        return list;
    }

    public List<Movie> searchMoviesByTitle(String keyword) throws SQLException {
        List<Movie> list = new ArrayList<>();
        String sql = "SELECT * FROM Movie WHERE title LIKE ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Movie m = new Movie();
                    m.setMovieId(rs.getInt("movie_id"));
                    m.setTitle(rs.getString("title"));
                    m.setRating(rs.getString("rating"));
                    m.setDurationMinutes(rs.getInt("duration_minutes"));
                    m.setLanguage(rs.getString("language"));
                    m.setReleaseDate(rs.getDate("release_date") != null
                            ? rs.getDate("release_date").toLocalDate() : null);
                    m.setStatus(rs.getString("status"));
                    m.setPosterUrl(rs.getString("poster_url"));
                    m.setTrailerUrl(rs.getString("trailer_url"));
                    m.setDirectorName(rs.getString("director_name"));
                    m.setDescription(rs.getString("description"));
                    list.add(m);
                }
            }
        }
        return list;
    }

    // Lọc phim theo nhiều tiêu chí
    public List<Movie> filterMovies(String keyword, String genreId, String actorId, String status, String director) throws SQLException {
        List<Movie> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
                "SELECT DISTINCT m.* FROM Movie m "
                + "LEFT JOIN Movie_Genre mg ON m.movie_id = mg.movie_id "
                + "LEFT JOIN Movie_Actor ma ON m.movie_id = ma.movie_id "
                + "WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND m.title LIKE ? ");
            params.add(keyword.trim() + "%");
        }

        if (genreId != null && !genreId.isEmpty()) {
            sql.append("AND mg.genre_id = ? ");
            params.add(Integer.parseInt(genreId));
        }

        if (actorId != null && !actorId.isEmpty()) {
            sql.append("AND ma.actor_id = ? ");
            params.add(Integer.parseInt(actorId));
        }

        if (status != null && !status.isEmpty()) {
            sql.append("AND m.status = ? ");
            params.add(status);
        }

        if (director != null && !director.trim().isEmpty()) {
            sql.append("AND m.director_name LIKE ? ");
            params.add(director.trim() + "%");
        }

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Movie m = new Movie();
                m.setMovieId(rs.getInt("movie_id"));
                m.setTitle(rs.getString("title"));
                m.setDescription(rs.getString("description"));
                m.setDurationMinutes(rs.getInt("duration_minutes"));
                m.setLanguage(rs.getString("language"));
                m.setReleaseDate(rs.getDate("release_date") != null
                        ? rs.getDate("release_date").toLocalDate() : null);
                m.setRating(rs.getString("rating"));
                m.setPosterUrl(rs.getString("poster_url"));
                m.setTrailerUrl(rs.getString("trailer_url"));
                m.setDirectorName(rs.getString("director_name"));
                m.setStatus(rs.getString("status"));
                list.add(m);
            }
        }

        return list;
    }
}
