package Controllers.Services;

import java.sql.*;

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
}
