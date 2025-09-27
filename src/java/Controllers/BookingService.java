/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package Controllers;




import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Service để xử lý tính tổng tiền cho 1 booking.
 */
public class BookingService {
    private final Connection connection;

    public BookingService(Connection connection) {
        this.connection = connection;
    }

    /**
     * Tính tổng tiền của 1 bookingId dựa trên BookingItem, Booking_Food, Booking_Combo.
     */
    public double calculateTotalPrice(int bookingId) throws SQLException {
        double total = 0.0;

        // 1. Tổng tiền vé (BookingItem)
        String sqlItems = "SELECT SUM(price) AS total FROM BookingItem WHERE booking_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sqlItems)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total += rs.getDouble("total");
                }
            }
        }

        // 2. Tổng tiền Food
        String sqlFood = "SELECT SUM(price * quantity) AS total FROM Booking_Food WHERE booking_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sqlFood)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total += rs.getDouble("total");
                }
            }
        }

        // 3. Tổng tiền Combo
        String sqlCombo = "SELECT SUM(price * quantity) AS total FROM Booking_Combo WHERE booking_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sqlCombo)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total += rs.getDouble("total");
                }
            }
        }

        return total;
    }
}
