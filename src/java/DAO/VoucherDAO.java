package DAO;

import Models.Voucher;
import java.sql.*;
import java.util.*;

public class VoucherDAO {
    private final Connection conn;
    public VoucherDAO(Connection conn) { this.conn = conn; }

    public List<Voucher> getAll() throws SQLException {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM Voucher";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Voucher(
                        rs.getInt("voucher_id"),
                        rs.getString("code"),
                        rs.getString("type"),
                        rs.getDouble("value"),
                        rs.getDate("valid_from"),
                        rs.getDate("valid_to"),
                        rs.getInt("usage_limit"),
                        rs.getInt("per_user_limit")
                ));
            }
        }
        return list;
    }

    public void insert(Voucher v) throws SQLException {
        String sql = "INSERT INTO Voucher(code,type,value,valid_from,valid_to,usage_limit,per_user_limit) VALUES(?,?,?,?,?,?,?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getCode());
            ps.setString(2, v.getType());
            ps.setDouble(3, v.getValue());
            ps.setDate(4, new java.sql.Date(v.getValidFrom().getTime()));
            ps.setDate(5, new java.sql.Date(v.getValidTo().getTime()));
            ps.setInt(6, v.getUsageLimit());
            ps.setInt(7, v.getPerUserLimit());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM Voucher WHERE voucher_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}
