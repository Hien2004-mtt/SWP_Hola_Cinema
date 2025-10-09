package DAO;

import Models.Voucher;
import DAL.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class VoucherDAO {
    private final Connection conn;

    public VoucherDAO(Connection conn) {
        this.conn = conn;
    }

    //  Lấy voucher theo code, chỉ lấy khi đang active
    public Voucher getVoucherByCode(String code) throws SQLException {
        String sql = "SELECT * FROM Voucher WHERE code = ? AND isActive = 1";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapVoucher(rs);
            }
        }
        return null;
    }

    //  Lấy tất cả voucher (admin)
    public List<Voucher> getAll() throws SQLException {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM Voucher ORDER BY voucherId DESC";
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapVoucher(rs));
            }
        }
        return list;
    }

    // Thêm voucher
    public void insert(Voucher v) throws SQLException {
        String sql = "INSERT INTO Voucher (code, type, value, validFrom, validTo, usageLimit, perUserLimit, isActive) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getCode());
            ps.setString(2, v.getType());
            ps.setDouble(3, v.getValue());
            ps.setDate(4, new java.sql.Date(v.getValidFrom().getTime()));
            ps.setDate(5, new java.sql.Date(v.getValidTo().getTime()));
            ps.setInt(6, v.getUsageLimit());
            ps.setInt(7, v.getPerUserLimit());
            ps.setBoolean(8, v.isIsValid());
            ps.executeUpdate();
        }
    }

    // Xóa mềm (vô hiệu hóa)
    public void setActive(int id, boolean active) throws SQLException {
        String sql = "UPDATE Voucher SET isActive = ? WHERE voucherId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    //  Giảm usageLimit khi voucher được dùng
    public void decreaseUsage(String code) throws SQLException {
        String sql = "UPDATE Voucher SET usageLimit = usageLimit - 1 WHERE code = ? AND usageLimit > 0";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ps.executeUpdate();
        }
    }

    //  Mapper helper
    private Voucher mapVoucher(ResultSet rs) throws SQLException {
        Voucher v = new Voucher();
        v.setVoucherId(rs.getInt("voucherId"));
        v.setCode(rs.getString("code"));
        v.setType(rs.getString("type"));
        v.setValue(rs.getDouble("value"));
        v.setValidFrom(rs.getDate("validFrom"));
        v.setValidTo(rs.getDate("validTo"));
        v.setUsageLimit(rs.getInt("usageLimit"));
        v.setPerUserLimit(rs.getInt("perUserLimit"));
        v.setIsValid(rs.getBoolean("isActive"));
        return v;
    }
}
