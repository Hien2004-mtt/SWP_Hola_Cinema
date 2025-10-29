package Controllers.Services;

import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class BookingService {
    private final Connection conn;
    public BookingService(Connection conn) { this.conn = conn; }

    public double calculateTotalPrice(int bookingId) throws SQLException {
        double total = 0;

        // Vé
        String sqlItems = "SELECT SUM(price) AS total FROM BookingItem WHERE booking_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sqlItems)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) total += rs.getDouble("total");
        }

        // Đồ ăn
        String sqlFood = "SELECT SUM(price*quantity) AS total FROM Booking_Food WHERE booking_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sqlFood)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) total += rs.getDouble("total");
        }

        // Combo
        String sqlCombo = "SELECT SUM(price*quantity) AS total FROM Booking_Combo WHERE booking_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sqlCombo)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) total += rs.getDouble("total");
        }

        return total;
    }
    
    public Map<String, Object> getBookingInfo(int bookingId) {
        Map<String, Object> info = new HashMap<>();

        String sql = """
            SELECT 
                b.booking_id,
                b.total_price,
                b.status,
                u.name AS customer_name,
                u.email AS customer_email,
                m.title AS movie_title,
                a.name AS auditorium_name,
                s.start_time,
                s.end_time,
                STRING_AGG(CONCAT(se.[row], se.[number]), ', ') AS seat_codes
            FROM Booking b
            JOIN Users u ON b.user_id = u.user_id
            JOIN Showtime s ON b.showtime_id = s.showtime_id
            JOIN Movie m ON s.movie_id = m.movie_id
            JOIN Auditorium a ON s.auditorium_id = a.auditorium_id
            JOIN BookingItem bi ON b.booking_id = bi.booking_id
            JOIN Seat se ON bi.seat_id = se.seat_id
            WHERE b.booking_id = ?
            GROUP BY 
                b.booking_id, b.total_price, b.status, 
                u.name, u.email, 
                m.title, a.name, s.start_time, s.end_time
        """;

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                info.put("booking_id", rs.getInt("booking_id"));
                info.put("total_price", rs.getDouble("total_price"));
                info.put("status", rs.getString("status"));
                info.put("customer_name", rs.getString("customer_name"));
                info.put("customer_email", rs.getString("customer_email"));
                info.put("movie_title", rs.getString("movie_title"));
                info.put("auditorium_name", rs.getString("auditorium_name"));
                info.put("start_time", rs.getTimestamp("start_time"));
                info.put("end_time", rs.getTimestamp("end_time"));
                info.put("seat_code", rs.getString("seat_codes"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return info;
    }
}

