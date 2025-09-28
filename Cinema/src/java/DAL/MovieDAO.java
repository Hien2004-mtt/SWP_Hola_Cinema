/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAL;

import Models.Movie;
import java.sql.*;

/**
 *
 * @author USER
 */
public class MovieDAO {
    public Movie getMovieById(int id) {
    String sql = "SELECT * FROM Movie WHERE movie_id = ?";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
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
}
