/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAL;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author dinhh
 */
public class GenreDAO {

    private DBContext db = new DBContext();

    public List<String[]> getAllGenres() throws SQLException {
        List<String[]> genres = new ArrayList<>();
        String sql = "SELECT genre_id, name FROM Genre ORDER BY name";
        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                genres.add(new String[]{String.valueOf(rs.getInt("genre_id")), rs.getString("name")});
            }
        }
        return genres;
    }

    public int insertGenre(String name) throws SQLException {
        String sql = "INSERT INTO Genre (name) VALUES (?)";
        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, name);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1); // trả về id mới
            }
        }
        return -1;
    }

    public List<String> getGenresByMovieId(int movieId) throws SQLException {
        List<String> genres = new ArrayList<>();
        String sql = "SELECT g.name FROM Movie_Genre mg "
                + "JOIN Genre g ON mg.genre_id = g.genre_id "
                + "WHERE mg.movie_id = ?";
        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, movieId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                genres.add(rs.getString("name"));
            }
        }
        return genres;
    }
}
