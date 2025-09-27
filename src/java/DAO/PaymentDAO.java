/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package DAO;


import DAL.DBContext;
import Models.Payment;
import java.sql.*;

public class PaymentDAO {
    public void save(Payment payment) throws Exception {
        String sql = "INSERT INTO Payment (booking_id, amount, method, status, transaction_ref, paid_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, payment.getBookingId());
            ps.setDouble(2, payment.getAmount());
            ps.setString(3, payment.getMethod());
            ps.setString(4, payment.getStatus());
            ps.setString(5, payment.getTransactionRef());
            ps.setTimestamp(6, new Timestamp(payment.getPaidAt().getTime()));
            ps.executeUpdate();
        }
    }
}
