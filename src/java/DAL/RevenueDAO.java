package DAL;

import Models.RevenueRecord;
import java.sql.*;
import java.util.*;
import java.math.BigDecimal;

public class RevenueDAO {

    // ======== Lấy danh sách doanh thu mặc định hoặc theo điều kiện lọc ========
    public List<RevenueRecord> getRevenueByCondition(String fromDate, String toDate, String movieName,
                                                     BigDecimal minRevenue, BigDecimal maxRevenue, String sortOrder) {
        List<RevenueRecord> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
            SELECT 
                m.title AS movieTitle,
                COUNT(bi.booking_item_id) AS totalTickets,
                SUM(p.amount) AS totalRevenue,
                MAX(p.paid_at) AS paidAt
            FROM Payment p
            JOIN Booking b ON p.booking_id = b.booking_id
            JOIN BookingItem bi ON b.booking_id = bi.booking_id
            JOIN Showtime s ON s.showtime_id = bi.showtime_id
            JOIN Movie m ON s.movie_id = m.movie_id
            WHERE p.status = 'success'
              AND p.paid_at BETWEEN ? AND ?
        """);

        // Các điều kiện tùy chọn
        if (movieName != null && !movieName.trim().isEmpty()) {
            sql.append(" AND m.title LIKE ? ");
        }
        if (minRevenue != null) {
            sql.append(" AND p.amount >= ? ");
        }
        if (maxRevenue != null) {
            sql.append(" AND p.amount <= ? ");
        }

        sql.append(" GROUP BY m.title ");

        // Sắp xếp
        if ("asc".equalsIgnoreCase(sortOrder)) {
            sql.append(" ORDER BY totalRevenue ASC ");
        } else if ("desc".equalsIgnoreCase(sortOrder)) {
            sql.append(" ORDER BY totalRevenue DESC ");
        } else {
            sql.append(" ORDER BY totalRevenue DESC ");
        }

        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int idx = 1;
            ps.setString(idx++, fromDate);
            ps.setString(idx++, toDate);

            if (movieName != null && !movieName.trim().isEmpty()) {
                ps.setString(idx++, "%" + movieName + "%");
            }
            if (minRevenue != null) {
                ps.setBigDecimal(idx++, minRevenue);
            }
            if (maxRevenue != null) {
                ps.setBigDecimal(idx++, maxRevenue);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new RevenueRecord(
                        rs.getString("movieTitle"),
                        rs.getInt("totalTickets"),
                        rs.getBigDecimal("totalRevenue"),
                        rs.getTimestamp("paidAt")
                ));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // ======== Tổng doanh thu trong khoảng ========
    public BigDecimal getTotalRevenue(String fromDate, String toDate) {
        String sql = """
            SELECT SUM(p.amount) AS total
            FROM Payment p
            WHERE p.status = 'success'
              AND p.paid_at BETWEEN ? AND ?
        """;
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, fromDate);
            ps.setString(2, toDate);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    // ======== MAIN TEST ========
    public static void main(String[] args) {
        RevenueDAO dao = new RevenueDAO();

        System.out.println("===== TEST 1: LẤY DOANH THU TOÀN BỘ TRONG KHOẢNG =====");
        BigDecimal total = dao.getTotalRevenue("2025-11-01", "2025-11-10");
        System.out.println("💰 Tổng doanh thu từ 2025-11-01 đến 2025-11-10: " + total + " VND");

        System.out.println("\n===== TEST 2: LẤY DANH SÁCH DOANH THU THEO PHIM =====");
        List<RevenueRecord> list = dao.getRevenueByCondition(
                "2025-11-01",
                "2025-11-10",
                "",
                null,
                null,
                "desc"
        );

        if (list.isEmpty()) {
            System.out.println("⚠ Không có dữ liệu doanh thu nào trong khoảng này.");
        } else {
            for (RevenueRecord r : list) {
                System.out.printf("🎬 %s | Vé: %d | Doanh thu: %s | Thanh toán gần nhất: %s%n",
                        r.getMovieTitle(),
                        r.getTotalTickets(),
                        r.getTotalRevenue(),
                        r.getPaidAt());
            }
        }

        System.out.println("\n===== TEST 3: LỌC THEO TÊN PHIM (ví dụ: 'Avengers') =====");
        List<RevenueRecord> filtered = dao.getRevenueByCondition(
                "2025-11-01",
                "2025-11-10",
                "Avengers",
                new BigDecimal("100"),
                new BigDecimal("5000"),
                "asc"
        );

        if (filtered.isEmpty()) {
            System.out.println("⚠ Không có doanh thu cho phim 'Avengers' trong khoảng này.");
        } else {
            for (RevenueRecord r : filtered) {
                System.out.printf("🎞 %s | Vé: %d | Doanh thu: %s | Gần nhất: %s%n",
                        r.getMovieTitle(),
                        r.getTotalTickets(),
                        r.getTotalRevenue(),
                        r.getPaidAt());
            }
        }

        System.out.println("\n===== TEST DONE =====");
    }
}
