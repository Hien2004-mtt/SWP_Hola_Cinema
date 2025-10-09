package DAO;

import Models.Payment;
import java.sql.*;
import DAL.DBContext;

public class PaymentDAO {

    public void save(Payment payment) throws Exception {
        String sql = """
            INSERT INTO Payment (booking_id, amount, method_id, transaction_ref, status, paid_at, qr_code_url)
            VALUES (?, ?, ?, ?, ?, ?, ?)
        """;

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, payment.getBookingId());
            ps.setDouble(2, payment.getAmount());
            ps.setInt(3, payment.getMethodId());
            ps.setString(4, payment.getTransactionRef());
            ps.setString(5, payment.getStatus());
            ps.setTimestamp(6, new Timestamp(payment.getPaidAt().getTime()));
            ps.setString(7, payment.getQrCodeUrl());
            ps.executeUpdate();
        }
    }
}
