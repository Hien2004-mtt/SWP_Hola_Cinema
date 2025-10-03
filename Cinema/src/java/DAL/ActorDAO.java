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
public class ActorDAO {
    private Connection con;
    private DBContext db = new DBContext();

    public List<String[]> getAllActors() throws SQLException {
        List<String[]> actors = new ArrayList<>();
        String sql = "SELECT actor_id, name FROM Actor ORDER BY name";
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                actors.add(new String[]{String.valueOf(rs.getInt("actor_id")), rs.getString("name")});
            }
        }
        return actors;
    }
}
