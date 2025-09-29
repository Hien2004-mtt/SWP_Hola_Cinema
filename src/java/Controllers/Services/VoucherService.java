package Controllers.Services;

import java.sql.*;

public class VoucherService {
    private final Connection conn;
    public VoucherService(Connection conn) { this.conn = conn; }

    public double applyVoucher(String code, double totalPrice) throws SQLException {
        String sql = "SELECT * FROM Voucher WHERE code=? AND GETDATE() BETWEEN valid_from AND valid_to";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String type = rs.getString("type");
                double value = rs.getDouble("value");

                if ("percent".equals(type)) return totalPrice - (totalPrice * value / 100);
                else if ("fixed".equals(type)) return totalPrice - value;
                else if ("gift".equals(type)) return 0;
            }
        }
        return totalPrice; // không hợp lệ → giữ giá gốc
    }
}
