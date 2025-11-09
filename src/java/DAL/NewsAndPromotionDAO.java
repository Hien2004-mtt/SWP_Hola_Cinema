/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAL;

import Models.NewsAndPromotion;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class NewsAndPromotionDAO {

    // Lấy tất cả news và promotions
    public List<NewsAndPromotion> getAll() throws SQLException, ClassNotFoundException {
        List<NewsAndPromotion> list = new ArrayList<>();
        String sql = "SELECT * FROM NewsAndPromotion ORDER BY created_at DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToNews(rs));
            }
        }
        return list;
    }

    // Lấy news và promotions đang active
    public List<NewsAndPromotion> getActive() throws SQLException, ClassNotFoundException {
        List<NewsAndPromotion> list = new ArrayList<>();
        Timestamp now = new Timestamp(System.currentTimeMillis());
        String sql = "SELECT * FROM NewsAndPromotion WHERE is_active = 1 "
                + "AND (start_date IS NULL OR start_date <= ?) "
                + "AND (end_date IS NULL OR end_date >= ?) "
                + "ORDER BY created_at DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setTimestamp(1, now);
            stmt.setTimestamp(2, now);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToNews(rs));
                }
            }
        }
        return list;
    }

    // Lấy theo type (news hoặc promotion)
    public List<NewsAndPromotion> getByType(String type) throws SQLException, ClassNotFoundException {
        List<NewsAndPromotion> list = new ArrayList<>();
        String sql = "SELECT * FROM NewsAndPromotion WHERE type = ? ORDER BY created_at DESC";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, type);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToNews(rs));
                }
            }
        }
        return list;
    }

    // Lấy theo ID
    public NewsAndPromotion getById(int id) throws SQLException, ClassNotFoundException {
        String sql = "SELECT * FROM NewsAndPromotion WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToNews(rs);
                }
            }
        }
        return null;
    }

    // Thêm mới
    public int add(NewsAndPromotion news) throws SQLException, ClassNotFoundException {
        String sql = "INSERT INTO NewsAndPromotion (title, content, image_url, type, start_date, end_date, is_active, created_at, updated_at, created_by) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, news.getTitle());
            stmt.setString(2, news.getContent());
            stmt.setString(3, news.getImageUrl());
            stmt.setString(4, news.getType());
            stmt.setTimestamp(5, news.getStartDate());
            stmt.setTimestamp(6, news.getEndDate());
            stmt.setBoolean(7, news.isActive());
            Timestamp now = new Timestamp(System.currentTimeMillis());
            stmt.setTimestamp(8, now);
            stmt.setTimestamp(9, now);
            stmt.setInt(10, news.getCreatedBy());

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        }
        return -1;
    }

    // Cập nhật
    public boolean update(NewsAndPromotion news) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE NewsAndPromotion SET title = ?, content = ?, image_url = ?, type = ?, "
                + "start_date = ?, end_date = ?, is_active = ?, updated_at = ? WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, news.getTitle());
            stmt.setString(2, news.getContent());
            stmt.setString(3, news.getImageUrl());
            stmt.setString(4, news.getType());
            stmt.setTimestamp(5, news.getStartDate());
            stmt.setTimestamp(6, news.getEndDate());
            stmt.setBoolean(7, news.isActive());
            stmt.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
            stmt.setInt(9, news.getId());

            return stmt.executeUpdate() > 0;
        }
    }

    // Xóa (soft delete - set is_active = false)
    public boolean delete(int id) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE NewsAndPromotion SET is_active = 0, updated_at = ? WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        }
    }

    // Xóa vĩnh viễn
    public boolean deletePermanently(int id) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM NewsAndPromotion WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        }
    }

    // Toggle active status
    public boolean toggleActive(int id) throws SQLException, ClassNotFoundException {
        String sql = "UPDATE NewsAndPromotion SET is_active = CASE WHEN is_active = 1 THEN 0 ELSE 1 END, "
                + "updated_at = ? WHERE id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            stmt.setInt(2, id);
            return stmt.executeUpdate() > 0;
        }
    }

    // Helper method to map ResultSet to NewsAndPromotion object
    private NewsAndPromotion mapResultSetToNews(ResultSet rs) throws SQLException {
        NewsAndPromotion news = new NewsAndPromotion();
        news.setId(rs.getInt("id"));
        news.setTitle(rs.getString("title"));
        news.setContent(rs.getString("content"));
        news.setImageUrl(rs.getString("image_url"));
        news.setType(rs.getString("type"));
        news.setStartDate(rs.getTimestamp("start_date"));
        news.setEndDate(rs.getTimestamp("end_date"));
        news.setActive(rs.getBoolean("is_active"));
        news.setCreatedAt(rs.getTimestamp("created_at"));
        news.setUpdatedAt(rs.getTimestamp("updated_at"));
        news.setCreatedBy(rs.getInt("created_by"));
        return news;
    }
}


