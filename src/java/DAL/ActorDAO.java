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

    private DBContext db = new DBContext();

    // ✅ Lấy tất cả actor còn hoạt động
    public List<String[]> getAllActors() throws SQLException {
        List<String[]> actors = new ArrayList<>();
        String sql = "SELECT actor_id, name FROM Actor WHERE is_active = 1 ORDER BY name";
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                actors.add(new String[]{
                    String.valueOf(rs.getInt("actor_id")),
                    rs.getString("name")
                });
            }
        }
        return actors;
    }

    /**
     * ✅ Thêm mới hoặc kích hoạt lại actor nếu đã tồn tại nhưng is_active = 0
     * @return -2 nếu đã tồn tại và active
     *         id (>=1) nếu thêm mới hoặc kích hoạt lại thành công
     *         -1 nếu lỗi khác
     */
    public int insertOrReactivateActor(String name) throws SQLException {
        String checkSql = "SELECT actor_id, is_active FROM Actor WHERE name = ?";
        String reactivateSql = "UPDATE Actor SET is_active = 1 WHERE actor_id = ?";
        String insertSql = "INSERT INTO Actor (name, is_active) VALUES (?, 1)";

        try (Connection conn = db.getConnection()) {
            // Kiểm tra actor đã tồn tại chưa
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setString(1, name);
                ResultSet rs = checkPs.executeQuery();

                if (rs.next()) {
                    int id = rs.getInt("actor_id");
                    boolean isActive = rs.getBoolean("is_active");

                    if (isActive) {
                        // Đã active → báo lỗi
                        return -2;
                    } else {
                        // Bị soft delete → kích hoạt lại
                        try (PreparedStatement reactivatePs = conn.prepareStatement(reactivateSql)) {
                            reactivatePs.setInt(1, id);
                            reactivatePs.executeUpdate();
                        }
                        return id;
                    }
                }
            }

            // Nếu chưa tồn tại → thêm mới
            try (PreparedStatement insertPs = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                insertPs.setString(1, name);
                insertPs.executeUpdate();

                ResultSet rs = insertPs.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return -1;
    }

    // ✅ Lấy danh sách actor theo movie
    public List<String> getActorsByMovieId(int movieId) throws SQLException {
        List<String> actors = new ArrayList<>();
        String sql = "SELECT a.name FROM Movie_Actor ma "
                + "JOIN Actor a ON ma.actor_id = a.actor_id "
                + "WHERE ma.movie_id = ?";
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, movieId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                actors.add(rs.getString("name"));
            }
        }
        return actors;
    }

    // ✅ Soft delete actor
    public boolean softDeleteActor(int actorId) throws SQLException {
        String sql = "UPDATE Actor SET is_active = 0 WHERE actor_id = ?";
        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, actorId);
            int rows = stmt.executeUpdate();
            return rows > 0;
        }
    }
}
