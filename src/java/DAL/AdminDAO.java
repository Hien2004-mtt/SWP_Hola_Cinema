package DAL;

import java.sql.*;
import java.time.LocalDate;
import java.time.YearMonth;
import java.util.Optional;

public class AdminDAO {

    // ====== DOANH THU ======

    /** 🧾 Tổng doanh thu hôm nay */
    public double getTodayRevenue() {
        String sql = """
            SELECT SUM(amount) 
            FROM Payment 
            WHERE CAST(paid_at AS DATE) = CAST(GETDATE() AS DATE)
              AND status = 'success'
        """;
        return querySingleDouble(sql);
    }

    /** 💰 Tổng doanh thu tháng hiện tại */
    public double getMonthRevenue() {
        String sql = """
            SELECT SUM(amount)
            FROM Payment
            WHERE MONTH(paid_at) = MONTH(GETDATE())
              AND YEAR(paid_at) = YEAR(GETDATE())
              AND status = 'success'
        """;
        return querySingleDouble(sql);
    }

    /** 💵 Tổng doanh thu năm hiện tại */
    public double getYearRevenue() {
        String sql = """
            SELECT SUM(amount)
            FROM Payment
            WHERE YEAR(paid_at) = YEAR(GETDATE())
              AND status = 'success'
        """;
        return querySingleDouble(sql);
    }

    // ====== THỐNG KÊ KHÁC ======

    /** 🎟️ Tổng số vé bán ra */
    public int getTotalTicketsSold() {
        String sql = """
            SELECT COUNT(*) 
            FROM BookingItem bi
            JOIN Booking b ON bi.booking_id = b.booking_id
            JOIN Payment p ON p.booking_id = b.booking_id
            WHERE p.status = 'success'
        """;
        return querySingleInt(sql);
    }

    /** 🎬 Số lượng phim đang chiếu */
    public int getNowShowingCount() {
        String sql = "SELECT COUNT(*) FROM Movie WHERE status = 'now showing'";
        return querySingleInt(sql);
    }

    /** 🎞️ Số lượng phim sắp chiếu */
    public int getComingSoonCount() {
        String sql = "SELECT COUNT(*) FROM Movie WHERE status = 'coming soon'";
        return querySingleInt(sql);
    }

    /** 🏢 Tổng số rạp đang hoạt động */
    public int getActiveCinemas() {
        String sql = "SELECT COUNT(*) FROM Auditorium";
        return querySingleInt(sql);
    }

    /** 👥 Tổng số người dùng */
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM Users";
        return querySingleInt(sql);
    }

    /** ⭐ Điểm đánh giá trung bình của tất cả phim */
    public double getAverageRating() {
        String sql = "SELECT AVG(CAST(rating AS FLOAT)) FROM Review";
        return querySingleDouble(sql);
    }

    // ====== HỖ TRỢ ======

    private double querySingleDouble(String sql) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return Optional.ofNullable(rs.getDouble(1)).orElse(0.0);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    private int querySingleInt(String sql) {
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // ====== TÙY CHỌN MỞ RỘNG ======

    /** 📅 Lấy doanh thu trong khoảng ngày */
    public double getRevenueByDateRange(LocalDate start, LocalDate end) {
        String sql = """
            SELECT SUM(amount)
            FROM Payment
            WHERE CAST(paid_at AS DATE) BETWEEN ? AND ?
              AND status = 'success'
        """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, Date.valueOf(start));
            ps.setDate(2, Date.valueOf(end));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    /** 📊 Doanh thu theo tháng trong năm hiện tại */
    public double[] getMonthlyRevenueThisYear() {
        double[] data = new double[12];
        String sql = """
            SELECT MONTH(paid_at) AS m, SUM(amount) AS total
            FROM Payment
            WHERE YEAR(paid_at) = YEAR(GETDATE())
              AND status = 'success'
            GROUP BY MONTH(paid_at)
        """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                int month = rs.getInt("m");
                double total = rs.getDouble("total");
                data[month - 1] = total;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return data;
    }
}
