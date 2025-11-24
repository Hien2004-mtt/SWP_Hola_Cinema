package Dao;

import Dal.DBContext;
import Models.Food;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class FoodDAO {

    private static final int PAGE_SIZE = 8;

    // ===================== Map ResultSet -> Food =====================
    private Food mapRow(ResultSet rs) throws SQLException {
        return new Food(
                rs.getInt("food_id"),
                rs.getString("name"),
                rs.getString("type"),
                rs.getBigDecimal("price"),
                rs.getBoolean("is_active") // ✅ sửa: is_active thay cho status
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
            sql.append(" AND is_active = ? "); // ✅ sửa
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

        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===================== Đếm số lượng theo bộ lọc =====================
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
            sql.append(" AND is_active = ? "); // ✅ sửa
            params.add("1".equals(statusStr));
        }

        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ===================== Thêm món ăn =====================
    public void addFood(Food f) {
        String sql = "INSERT INTO Food(name, type, price, is_active) VALUES (?, ?, ?, ?)"; // ✅ sửa
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, f.getName());
            ps.setString(2, f.getType());
            ps.setBigDecimal(3, f.getPrice());
            ps.setBoolean(4, f.isStatus());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ===================== Cập nhật món ăn =====================
    public void updateFood(Food f) {
        String sql = "UPDATE Food SET name=?, type=?, price=?, is_active=? WHERE food_id=?"; // ✅ sửa
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, f.getName());
            ps.setString(2, f.getType());
            ps.setBigDecimal(3, f.getPrice());
            ps.setBoolean(4, f.isStatus());
            ps.setInt(5, f.getFoodId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ===================== Xóa món ăn =====================
    public void deleteFood(int id) {
        String sql = "DELETE FROM Food WHERE food_id=?";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ===================== Chuyển trạng thái (toggle) =====================
    public void toggleStatus(int id) {
        String sql = "UPDATE Food SET is_active = CASE WHEN is_active=1 THEN 0 ELSE 1 END WHERE food_id=?"; // ✅ sửa
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ===================== Test Main =====================
    public static void main(String[] args) {
        FoodDAO dao = new FoodDAO();

        System.out.println("===== TEST ADD FOOD =====");
        // ✅ Dùng type = 'snack' để hợp lệ với CHK_Food_Type
        Food newFood = new Food(0, "Pizza Hải sản", "snack", new BigDecimal("95000"), true);
        dao.addFood(newFood);
        System.out.println("✔ Thêm món ăn mới thành công!");

        System.out.println("\n===== TEST GET FOODS (FILTER + SORT + PAGE) =====");
        List<Food> foods = dao.getFoodsByFilter(
                "", // keyword
                "snack", // type hợp lệ
                new BigDecimal("50000"),
                new BigDecimal("200000"),
                "1", // active
                "asc", // sort asc
                1
        );
        for (Food f : foods) {
            System.out.printf("%d | %s | %s | %s | %s%n",
                    f.getFoodId(), f.getName(), f.getType(), f.getPrice(), f.isStatus());
        }

        System.out.println("\n===== TEST COUNT FOODS =====");
        int count = dao.countFoodsByFilter("", "snack",
                new BigDecimal("50000"), new BigDecimal("200000"), "1");
        System.out.println("Tổng số món phù hợp: " + count);

        System.out.println("\n===== TEST UPDATE FOOD =====");
        if (!foods.isEmpty()) {
            Food f = foods.get(0);
            f.setName(f.getName() + " [Updated]");
            f.setPrice(f.getPrice().add(new BigDecimal("5000")));
            dao.updateFood(f);
            System.out.println("✔ Đã cập nhật món: " + f.getName());
        } else {
            System.out.println("⚠ Không có món nào để cập nhật.");
        }

        System.out.println("\n===== TEST TOGGLE STATUS =====");
        if (!foods.isEmpty()) {
            int id = foods.get(0).getFoodId();
            dao.toggleStatus(id);
            System.out.println("✔ Đã đổi trạng thái món có ID = " + id);
        }

        System.out.println("\n===== TEST DELETE FOOD =====");
        if (!foods.isEmpty()) {
            int id = foods.get(0).getFoodId();
            dao.deleteFood(id);
            System.out.println("✔ Đã xóa món có ID = " + id);
        }

        System.out.println("\n===== TEST DONE =====");
    }

}
