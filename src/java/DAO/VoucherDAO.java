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

    /* ==========================================================
    Hàm tự động cập nhật trạng thái voucher
       ========================================================== */
    private void autoUpdateVoucherStatus() throws SQLException {
        String sql = """
            UPDATE Voucher
            SET isActive = CASE
                WHEN GETDATE() < valid_from THEN 0                   -- ❌ Chưa đến ngày bắt đầu
                WHEN GETDATE() > valid_to THEN 0                     -- ❌ Hết hạn
                WHEN usage_limit <= 0 OR per_user_limit <= 0 THEN 0  -- ❌ Hết lượt sử dụng
                WHEN GETDATE() BETWEEN valid_from AND valid_to 
                     AND usage_limit > 0 AND per_user_limit > 0 THEN 1  -- ✅ Còn hiệu lực
                ELSE isActive
            END
        """;
        try (Statement st = conn.createStatement()) {
            st.executeUpdate(sql);
        }
    }

    /* ==========================================================
       2️⃣ Lấy voucher theo code (chỉ active)
       ========================================================== */
    public Voucher getVoucherByCode(String code) throws SQLException {
        autoUpdateVoucherStatus();

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

    /* ==========================================================
       3️⃣ Lấy tất cả voucher (admin)
       ========================================================== */
    public List<Voucher> getAll() throws SQLException {
        autoUpdateVoucherStatus();

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

    /* ==========================================================
       4️⃣ Lấy danh sách voucher còn hiệu lực (khách hàng)
       ========================================================== */
    public List<Voucher> getActiveVouchers() throws SQLException {
        autoUpdateVoucherStatus();

        List<Voucher> list = new ArrayList<>();
        String sql = """
            SELECT * FROM Voucher
            WHERE isActive = 1
              AND GETDATE() BETWEEN valid_from AND valid_to
              AND usage_limit > 0
              AND per_user_limit > 0
            ORDER BY valid_to ASC
        """;
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapVoucher(rs));
            }
        }
        return list;
    }

    /* ==========================================================
       5️⃣ Giảm usage_limit sau khi sử dụng
       ========================================================== */
    public void decreaseUsage(String code) throws SQLException {
        String sql = """
            UPDATE Voucher
            SET usage_limit = usage_limit - 1 
            WHERE code = ? AND usage_limit > 0
        """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ps.executeUpdate();
        }

        autoUpdateVoucherStatus();
    }

    /* ==========================================================
       6️⃣ Lấy voucher theo ID (dùng cho edit / chi tiết)
       ========================================================== */
    public Voucher getById(int id) throws SQLException {
        autoUpdateVoucherStatus();

        String sql = "SELECT * FROM Voucher WHERE voucher_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapVoucher(rs);
            }
        }
        return null;
    }

    /* ==========================================================
       7️⃣ Thêm voucher mới
       ========================================================== */
    public void insert(Voucher v) throws SQLException {
        autoUpdateVoucherStatus();

        if (v.getCode() == null || v.getCode().isEmpty()) {
            v.setCode(generateCode(10));
        }

        String sql = """
            INSERT INTO Voucher (code, type, value, valid_from, valid_to, usage_limit, per_user_limit, isActive)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """;

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

        autoUpdateVoucherStatus();
    }

    /* ==========================================================
       8️⃣ Cập nhật voucher
       ========================================================== */
    public void update(int id, String type, double value, Date validFrom, Date validTo,
                       int usageLimit, int perUserLimit) throws SQLException {

        String sql = """
            UPDATE Voucher 
            SET type=?, value=?, valid_from=?, valid_to=?, usage_limit=?, per_user_limit=?,
                isActive = CASE
                    WHEN GETDATE() < ? OR GETDATE() > ? THEN 0
                    WHEN ? <= 0 OR ? <= 0 THEN 0
                    ELSE 1
                END
            WHERE voucher_id=?
        """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, type);
            ps.setDouble(2, value);
            ps.setDate(3, new java.sql.Date(validFrom.getTime()));
            ps.setDate(4, new java.sql.Date(validTo.getTime()));
            ps.setInt(5, usageLimit);
            ps.setInt(6, perUserLimit);
            ps.setDate(7, new java.sql.Date(validFrom.getTime()));
            ps.setDate(8, new java.sql.Date(validTo.getTime()));
            ps.setInt(9, usageLimit);
            ps.setInt(10, perUserLimit);
            ps.setInt(11, id);
            ps.executeUpdate();
        }

        autoUpdateVoucherStatus();
    }

    /* ==========================================================
      9️⃣ Xóa mềm (vô hiệu / kích hoạt thủ công)
       ========================================================== */
    public void setActive(int id, boolean active) throws SQLException {
        String sql = "UPDATE Voucher SET isActive = ? WHERE voucher_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, active);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    /* ==========================================================
        Hàm tiện ích - Map result -> object
       ========================================================== */
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

    /* ==========================================================
       1️⃣ Sinh code ngẫu nhiên không trùng
       ========================================================== */
    public String generateCode(int length) throws SQLException {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
        Random random = new Random();
        String code;
        do {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < length; i++) {
                sb.append(chars.charAt(random.nextInt(chars.length())));
            }
            code = sb.toString();
        } while (isCodeExists(code));
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
    public boolean canUserUseVoucher(String code, int userId) throws SQLException {
    String sqlCheck = """
        SELECT v.voucher_id, v.per_user_limit
        FROM Voucher v
        WHERE v.code = ? AND v.isActive = 1
    """;
    int voucherId = 0;
    int perUserLimit = 1;

    try (PreparedStatement ps = conn.prepareStatement(sqlCheck)) {
        ps.setString(1, code);
        ResultSet rs = ps.executeQuery();
        if (!rs.next()) {
            throw new SQLException("Voucher không tồn tại hoặc đã hết hạn.");
        }
        voucherId = rs.getInt("voucher_id");
        perUserLimit = rs.getInt("per_user_limit");
    }

    //  Kiểm tra user đã dùng voucher này bao nhiêu lần
    String sqlCount = """
        SELECT COUNT(*) AS used_count
        FROM Booking
        WHERE user_id = ? AND voucher_id = ?
    """;
    try (PreparedStatement ps = conn.prepareStatement(sqlCount)) {
        ps.setInt(1, userId);
        ps.setInt(2, voucherId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            int usedCount = rs.getInt("used_count");
            return usedCount < perUserLimit;
        }
    }
    return true;
}
}
