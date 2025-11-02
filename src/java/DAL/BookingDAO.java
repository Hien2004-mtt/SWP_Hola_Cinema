package DAL;

import Models.Booking;
import java.sql.*;

/**
 * BookingDAO - thực hiện các thao tác CRUD với bảng Booking
 */
public class BookingDAO {

   
    public int addBooking(Connection conn,int userId, int showtimeId, double totalPrice) {
        // Câu SQL thêm booking mới. GETDATE() tự động ghi thời điểm tạo.
        String sql = "INSERT INTO Booking (user_id, showtime_id, total_price, status, created_at) "
                + "VALUES (?, ?, ?, 'pending', GETDATE())";

        try ( // Tạo PreparedStatement và yêu cầu trả về khóa tự sinh (booking_id)
                 PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            // Gán giá trị cho 3 dấu ? trong câu SQL
            ps.setInt(1, userId);
            ps.setInt(2, showtimeId);
            ps.setDouble(3, totalPrice);

            // Thực thi lệnh INSERT
            int rows = ps.executeUpdate();

            // Nếu thêm thành công ít nhất 1 dòng
            if (rows > 0) {
                // Lấy booking_id tự sinh ra
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Nếu có lỗi hoặc không tạo được booking
        return -1;
    }

    /**
     * Cập nhật trạng thái booking (pending → paid / cancelled / completed)
     */
    public boolean updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE Booking SET status = ? WHERE booking_id = ?";

        try (
                Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            // Gán tham số
            ps.setString(1, status);
            ps.setInt(2, bookingId);

            // Nếu update thành công ít nhất 1 dòng => true
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    /**
     * Lấy thông tin booking bằng booking_id
     */
    public Booking getBookingById(int bookingId) {
        String sql = "SELECT * FROM Booking WHERE booking_id = ?";

        try (
                Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Booking b = new Booking();

                b.setBookingId(rs.getInt("booking_id"));
                b.setUserId(rs.getInt("user_id"));
                b.setShowtimeId(rs.getInt("showtime_id"));

                // Cột voucher_id có thể NULL → cần kiểm tra
                int voucher = rs.getInt("voucher_id");
                if (rs.wasNull()) {
                    b.setVoucherId(null);
                } else {
                    b.setVoucherId(voucher);
                }

                b.setStatus(rs.getString("status"));
                b.setTotalPrice(rs.getDouble("total_price"));
                b.setCreatedAt(rs.getTimestamp("created_at"));
                b.setExpiresAt(rs.getTimestamp("expires_at"));

                return b;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
}
