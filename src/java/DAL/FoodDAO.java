package DAL;

import Models.Food;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class FoodDAO {

    private static final int PAGE_SIZE = 8;

    private Food mapRow(ResultSet rs) throws SQLException {
        return new Food(
            rs.getInt("food_id"),
            rs.getString("name"),
            rs.getString("type"),
            rs.getBigDecimal("price"),
            rs.getBoolean("status")
        );
    }

    // ===================== Lấy danh sách có filter + sort + phân trang =====================
    public List<Food> getFoodsByFilter(String keyword, String type,
                                       BigDecimal min, BigDecimal max,
                                       String statusStr, String sortOrder,
                                       int page) {
        List<Food> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM Food WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        // Bộ lọc
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND name LIKE ? ");
            params.add("%" + keyword + "%");
        }
        if (type != null && !type.isEmpty()) {
            sql.append(" AND type = ? ");
            params.add(type);
        }
        if (min != null && max != null) {
            sql.append(" AND price BETWEEN ? AND ? ");
            params.add(min);
            params.add(max);
        }
        if (statusStr != null && !statusStr.isEmpty()) {
            sql.append(" AND status = ? ");
            params.add("1".equals(statusStr));
        }

        // Sắp xếp
        if ("asc".equalsIgnoreCase(sortOrder)) {
            sql.append(" ORDER BY price ASC ");
        } else if ("desc".equalsIgnoreCase(sortOrder)) {
            sql.append(" ORDER BY price DESC ");
        } else {
            sql.append(" ORDER BY food_id DESC ");
        }

        // Phân trang
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * PAGE_SIZE);
        params.add(PAGE_SIZE);

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countFoodsByFilter(String keyword, String type,
                                  BigDecimal min, BigDecimal max,
                                  String statusStr) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Food WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND name LIKE ? ");
            params.add("%" + keyword + "%");
        }
        if (type != null && !type.isEmpty()) {
            sql.append(" AND type = ? ");
            params.add(type);
        }
        if (min != null && max != null) {
            sql.append(" AND price BETWEEN ? AND ? ");
            params.add(min);
            params.add(max);
        }
        if (statusStr != null && !statusStr.isEmpty()) {
            sql.append(" AND status = ? ");
            params.add("1".equals(statusStr));
        }

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    // CRUD + Toggle
    public void addFood(Food f) {
        String sql = "INSERT INTO Food(name, type, price, status) VALUES (?, ?, ?, ?)";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, f.getName());
            ps.setString(2, f.getType());
            ps.setBigDecimal(3, f.getPrice());
            ps.setBoolean(4, f.isStatus());
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void updateFood(Food f) {
        String sql = "UPDATE Food SET name=?, type=?, price=?, status=? WHERE food_id=?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, f.getName());
            ps.setString(2, f.getType());
            ps.setBigDecimal(3, f.getPrice());
            ps.setBoolean(4, f.isStatus());
            ps.setInt(5, f.getFoodId());
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void deleteFood(int id) {
        String sql = "DELETE FROM Food WHERE food_id=?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    public void toggleStatus(int id) {
        String sql = "UPDATE Food SET status = CASE WHEN status=1 THEN 0 ELSE 1 END WHERE food_id=?";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }
}
