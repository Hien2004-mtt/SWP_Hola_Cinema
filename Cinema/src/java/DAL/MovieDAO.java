/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAL;

import Models.Movie;

import java.sql.*;
import java.time.LocalDate;
import java.util.List;

/**
 *
 * @author dinhh
 */
public class MovieDAO extends DBContext {

    // Check if movie exiests
    public boolean movieExists(String title, String directorName) {
        String sql = "SELECT COUNT(*) FROM Movie WHERE title = ? AND director_name = ?";
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
        String sql = "INSERT INTO Movie (title, description, duration_minutes, language, release_date, rating, poster_url, trailer_url, director_name, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
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
}
