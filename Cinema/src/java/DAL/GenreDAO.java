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
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                genres.add(new String[]{String.valueOf(rs.getInt("genre_id")), rs.getString("name")});
            }
        }
        return genres;
    }
}
