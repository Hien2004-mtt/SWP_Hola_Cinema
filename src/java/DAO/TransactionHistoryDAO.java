package DAO;

import DAL.DBContext;
import java.sql.*;
import java.util.*;
import Models.TransactionHistory;


public class TransactionHistoryDAO {

    public List<TransactionHistory> getUserTransactions(int userId) {
        List<TransactionHistory> list = new ArrayList<>();
        String sql = """
            SELECT p.payment_id, p.booking_id, m.title AS movie_title, 
                   s.start_time, p.amount, p.status, p.method, p.paid_at
            FROM Payment p
            JOIN Booking b ON p.booking_id = b.booking_id
            JOIN Showtime s ON b.showtime_id = s.showtime_id
            JOIN Movie m ON s.movie_id = m.movie_id
            WHERE b.user_id = ?
            ORDER BY p.paid_at DESC
        """;

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TransactionHistory t = new TransactionHistory();
                t.setPaymentId(rs.getInt("payment_id"));
                t.setBookingId(rs.getInt("booking_id"));
                t.setMovieTitle(rs.getString("movie_title"));
                t.setStartTime(rs.getTimestamp("start_time"));
                t.setAmount(rs.getBigDecimal("amount"));
                t.setStatus(rs.getString("status"));
                t.setMethod(rs.getString("method"));
                t.setPaidAt(rs.getTimestamp("paid_at"));
                list.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
     public List<TransactionHistory> getUserTransactionsByPage(
            int userId, int offset, int limit, String timeFilter, String sortOrder) {

        List<TransactionHistory> list = new ArrayList<>();
        String timeCondition = "";

        // Lọc theo thời gian
        switch (timeFilter) {
            case "today" -> timeCondition = "AND CAST(p.paid_at AS DATE) = CAST(GETDATE() AS DATE)";
            case "week" -> timeCondition = "AND DATEDIFF(DAY, p.paid_at, GETDATE()) <= 7";
            case "month" -> timeCondition = "AND DATEDIFF(DAY, p.paid_at, GETDATE()) <= 30";
        }

        // Sắp xếp
        String order = sortOrder.equalsIgnoreCase("asc") ? "ASC" : "DESC";

        String sql = String.format("""
            SELECT p.payment_id, p.booking_id, m.title AS movie_title, 
                   s.start_time, p.amount, p.status, p.method, p.paid_at
            FROM Payment p
            JOIN Booking b ON p.booking_id = b.booking_id
            JOIN Showtime s ON b.showtime_id = s.showtime_id
            JOIN Movie m ON s.movie_id = m.movie_id
            WHERE b.user_id = ? %s
            ORDER BY p.paid_at %s
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """, timeCondition, order);

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TransactionHistory t = new TransactionHistory();
                t.setPaymentId(rs.getInt("payment_id"));
                t.setBookingId(rs.getInt("booking_id"));
                t.setMovieTitle(rs.getString("movie_title"));
                t.setStartTime(rs.getTimestamp("start_time"));
                t.setAmount(rs.getBigDecimal("amount"));
                t.setStatus(rs.getString("status"));
                t.setMethod(rs.getString("method"));
                t.setPaidAt(rs.getTimestamp("paid_at"));
                list.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 📊 Đếm tổng số giao dịch (để tính tổng trang)
    public int getTotalUserTransactionCount(int userId, String timeFilter) {
        String timeCondition = "";

        switch (timeFilter) {
            case "today" -> timeCondition = "AND CAST(p.paid_at AS DATE) = CAST(GETDATE() AS DATE)";
            case "week" -> timeCondition = "AND DATEDIFF(DAY, p.paid_at, GETDATE()) <= 7";
            case "month" -> timeCondition = "AND DATEDIFF(DAY, p.paid_at, GETDATE()) <= 30";
        }

        String sql = String.format("""
            SELECT COUNT(*) AS total
            FROM Payment p
            JOIN Booking b ON p.booking_id = b.booking_id
            WHERE b.user_id = ? %s
        """, timeCondition);

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("total");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
