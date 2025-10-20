package DAO;

import Models.Voucher;
import DAL.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

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
        String sql = "SELECT * FROM Voucher ORDER BY voucher_id DESC";
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
        // Nếu code chưa có → tự sinh code ngẫu nhiên
        if (v.getCode() == null || v.getCode().isEmpty()) {
            v.setCode(generateCode(10));
        }

        String sql = "INSERT INTO Voucher (code, type, value, valid_from, valid_to, usage_limit, per_user_limit, isActive) "
           + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, v.getCode());
            ps.setString(2, v.getType());
            ps.setDouble(3, v.getValue());
            ps.setDate(4, new java.sql.Date(v.getValidFrom().getTime()));
            ps.setDate(5, new java.sql.Date(v.getValidTo().getTime()));
            ps.setInt(6, v.getUsageLimit());
            ps.setInt(7, v.getPerUserLimit());
            ps.setBoolean(8, v.isIsActive());
            ps.executeUpdate();
        }
    }

    // Xóa mềm (vô hiệu hóa)
    public void setActive(int id, boolean active) throws SQLException {
        String sql = "UPDATE Voucher SET isActive = ? WHERE voucher_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    //  Giảm usageLimit khi voucher được dùng
    public void decreaseUsage(String code) throws SQLException {
        String sql = "UPDATE Voucher SET usage_limit = usage_limit - 1 WHERE code = ? AND usage_limit > 0";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ps.executeUpdate();
        }
    }

    //  Mapper helper
    private Voucher mapVoucher(ResultSet rs) throws SQLException {
        Voucher v = new Voucher();
        v.setVoucherId(rs.getInt("voucher_id"));
        v.setCode(rs.getString("code"));
        v.setType(rs.getString("type"));
        v.setValue(rs.getDouble("value"));
        v.setValidFrom(rs.getDate("valid_from"));
        v.setValidTo(rs.getDate("valid_to"));
        v.setUsageLimit(rs.getInt("usage_limit"));
        v.setPerUserLimit(rs.getInt("per_user_limit"));
        v.setIsActive(rs.getBoolean("isActive"));
        return v;
    }
    
    public  String generateCode(int length) throws SQLException {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        Random random = new Random();
        String code;

        do {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < length; i++) {
                sb.append(chars.charAt(random.nextInt(chars.length())));
            }
            code = sb.toString();
        } while (isCodeExists(code)); //  sinh lại nếu trùng

        return code;
    }
    
    private boolean isCodeExists(String code) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Voucher WHERE code = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }
    public Voucher getById(int id) throws SQLException {
    String sql = "SELECT * FROM Voucher WHERE voucher_id = ?";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) return mapVoucher(rs);
    }
    return null;
}

public void update(int id, String type, double value, Date validFrom, Date validTo,
                   int usageLimit, int perUserLimit) throws SQLException {
    String sql = "UPDATE Voucher SET type=?, value=?, valid_from=?, valid_to=?, usage_limit=?, per_user_limit=? WHERE voucher_id=?";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, type);
        ps.setDouble(2, value);
        ps.setDate(3, new java.sql.Date(validFrom.getTime()));
        ps.setDate(4, new java.sql.Date(validTo.getTime()));
        ps.setInt(5, usageLimit);
        ps.setInt(6, perUserLimit);
        ps.setInt(7, id);
        ps.executeUpdate();
    }
}
}
