package Dao;

import Dal.DBContext;
import Models.Payment;
import java.sql.*;

public class PaymentDAO {

    public void save(Payment payment) throws Exception {
        String sql = """
            INSERT INTO Payment (booking_id, amount, method, transaction_ref, status, paid_at, qr_code_url)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, payment.getBookingId());
            ps.setDouble(2, payment.getAmount());
            ps.setString(3, payment.getMethod()); // <-- đổi sang String
            ps.setString(4, payment.getTransactionRef());
            ps.setString(5, payment.getStatus());
            ps.setTimestamp(6, new Timestamp(payment.getPaidAt().getTime()));
            ps.setString(7, payment.getQrCodeUrl());
            ps.executeUpdate();
        } catch(Exception e){
            e.printStackTrace();
        }
    }

    public Payment getByBookingId(int bookingId) throws Exception {
        String sql = "SELECT * FROM Payment WHERE booking_id = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Payment p = new Payment();
                    p.setPaymentId(rs.getInt("payment_id"));
                    p.setBookingId(rs.getInt("booking_id"));
                    p.setAmount(rs.getDouble("amount"));
                    p.setMethod(rs.getString("method")); // <-- đổi sang String
                    p.setTransactionRef(rs.getString("transaction_ref"));
                    p.setStatus(rs.getString("status"));
                    p.setPaidAt(rs.getTimestamp("paid_at"));
                    p.setQrCodeUrl(rs.getString("qr_code_url"));
                    return p;
                }
            }
        }
        return null;
    }

    public void updateStatus(int paymentId, String status) throws Exception {
        String sql = "UPDATE Payment SET status = ? WHERE payment_id = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, paymentId);
            ps.executeUpdate();
        }
    }
}
