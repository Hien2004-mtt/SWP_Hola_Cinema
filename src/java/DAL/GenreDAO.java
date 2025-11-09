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

    // Lấy tất cả genre còn hoạt động
    public List<String[]> getAllGenres() throws SQLException {
        List<String[]> genres = new ArrayList<>();
        String sql = "SELECT genre_id, name FROM Genre WHERE is_active = 1 ORDER BY name";
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                genres.add(new String[]{
                    String.valueOf(rs.getInt("genre_id")),
                    rs.getString("name")
                });
            }
        }
        return genres;
    }

    
    public int insertOrReactivateGenre(String name) throws SQLException {
        String checkSql = "SELECT genre_id, is_active FROM Genre WHERE name = ?";
        String reactivateSql = "UPDATE Genre SET is_active = 1 WHERE genre_id = ?";
        String insertSql = "INSERT INTO Genre (name, is_active) VALUES (?, 1)";

        try (Connection conn = db.getConnection()) {
            // Kiểm tra xem genre đã tồn tại chưa
            try (PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
                checkPs.setString(1, name);
                ResultSet rs = checkPs.executeQuery();

                if (rs.next()) {
                    int id = rs.getInt("genre_id");
                    boolean isActive = rs.getBoolean("is_active");

                    if (isActive) {
                        // Đã active => báo lỗi
                        return -2;
                    } else {
                        // Bị soft delete => kích hoạt lại
                        try (PreparedStatement reactivatePs = conn.prepareStatement(reactivateSql)) {
                            reactivatePs.setInt(1, id);
                            reactivatePs.executeUpdate();
                        }
                        return id;
                    }
                }
            }

            // Nếu chưa tồn tại => thêm mới
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

    public List<String> getGenresByMovieId(int movieId) throws SQLException {
        List<String> genres = new ArrayList<>();
        String sql = "SELECT g.name FROM Movie_Genre mg "
                + "JOIN Genre g ON mg.genre_id = g.genre_id "
                + "WHERE mg.movie_id = ?";
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, movieId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                genres.add(rs.getString("name"));
            }
        }
        return genres;
    }

    // Xóa mềm genre
    public boolean softDeleteGenre(int genreId) throws SQLException {
        String sql = "UPDATE Genre SET is_active = 0 WHERE genre_id = ?";
        try (Connection conn = db.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, genreId);
            int rows = stmt.executeUpdate();
            return rows > 0;
        }
    }
}
