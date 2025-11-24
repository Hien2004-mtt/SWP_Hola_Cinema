package Dao;

import Dal.DBContext;
import Models.Booking;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * BookingDAO - thực hiện các thao tác CRUD với bảng Booking
 */
public class BookingDAO {
    public String hashBookingId(int bookingId) {
    try {
        MessageDigest md = MessageDigest.getInstance("MD5");
        md.update(String.valueOf(bookingId).getBytes());
        byte[] digest = md.digest();
        StringBuilder sb = new StringBuilder();
        for (byte b : digest) {
            sb.append(String.format("%02x", b));
        }
        // Lấy 8 ký tự đầu cho gọn
        return sb.substring(0, 8).toUpperCase();
    } catch (NoSuchAlgorithmException e) {
        throw new RuntimeException(e);
    }
}
   
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
    public Map<String, Object> getBookingInfo(int bookingId) {
    Map<String, Object> info = new HashMap<>();

    String sql = """
        SELECT 
            b.booking_id,
            b.total_price,
            b.status,
            u.name AS customer_name,
            u.email AS customer_email,
            m.title AS movie_title,
            a.name AS auditorium_name,
            s.start_time,
            s.end_time,
            STRING_AGG(CONCAT(se.[row], se.[number]), ', ') AS seat_codes,
            STRING_AGG(se.seat_type, ', ') AS seat_types
        FROM Booking b
        JOIN Users u ON b.user_id = u.user_id
        JOIN Showtime s ON b.showtime_id = s.showtime_id
        JOIN Movie m ON s.movie_id = m.movie_id
        JOIN Auditorium a ON s.auditorium_id = a.auditorium_id
        LEFT JOIN BookingItem bi ON b.booking_id = bi.booking_id
        LEFT JOIN Seat se ON bi.seat_id = se.seat_id
        WHERE b.booking_id = ?
        GROUP BY 
            b.booking_id, b.total_price, b.status, 
            u.name, u.email, 
            m.title, a.name, s.start_time, s.end_time
    """;

    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, bookingId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            info.put("booking_id", rs.getInt("booking_id"));
            info.put("total_price", rs.getDouble("total_price"));
            info.put("status", rs.getString("status"));
            info.put("customer_name", rs.getString("customer_name"));
            info.put("customer_email", rs.getString("customer_email"));
            info.put("movie_title", rs.getString("movie_title"));
            info.put("auditorium_name", rs.getString("auditorium_name"));
            info.put("start_time", rs.getTimestamp("start_time"));
            info.put("end_time", rs.getTimestamp("end_time"));
            info.put("seat_code", rs.getString("seat_codes"));
            info.put("seat_type", rs.getString("seat_types"));
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return info;
}
    
    public void updateBookingAfterVoucher(int bookingId, int voucherId, double discountedTotal) {
        String sql = "UPDATE Booking SET voucher_id = ?, total_price = ? WHERE booking_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voucherId);
            ps.setDouble(2, discountedTotal);
            ps.setInt(3, bookingId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
       



    // ================================================
    // ✅ Các hàm bổ sung để BookingServlet hiển thị dữ liệu sang JSP
    // ================================================

    /** Lấy tên khách hàng */
    public String getUserNameByBookingId(int bookingId) {
        String sql = """
            SELECT u.name
            FROM Booking b
            JOIN Users u ON b.user_id = u.user_id
            WHERE b.booking_id = ?
        """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("name");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }

    /** Lấy tên phim */
    public String getMovieTitleByBookingId(int bookingId) {
        String sql = """
            SELECT m.title
            FROM Booking b
            JOIN Showtime s ON b.showtime_id = s.showtime_id
            JOIN Movie m ON s.movie_id = m.movie_id
            WHERE b.booking_id = ?
        """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("title");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }

    /** Lấy tên phòng chiếu */
    public String getAuditoriumNameByBookingId(int bookingId) {
        String sql = """
            SELECT a.name
            FROM Booking b
            JOIN Showtime s ON b.showtime_id = s.showtime_id
            JOIN Auditorium a ON s.auditorium_id = a.auditorium_id
            WHERE b.booking_id = ?
        """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("name");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "";
    }

    /** Lấy thời gian bắt đầu suất chiếu */
    public Timestamp getShowtimeStartByBookingId(int bookingId) {
        String sql = """
            SELECT s.start_time
            FROM Booking b
            JOIN Showtime s ON b.showtime_id = s.showtime_id
            WHERE b.booking_id = ?
        """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getTimestamp("start_time");
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Lấy danh sách ghế */
    public List<String> getSeatCodesByBookingId(int bookingId) {
        List<String> list = new ArrayList<>();
        String sql = """
            SELECT se.[row], se.[number]
            FROM BookingItem bi
            JOIN Seat se ON bi.seat_id = se.seat_id
            WHERE bi.booking_id = ?
        """;
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("row") + rs.getInt("number"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }



    // Lấy tổng tiền
    public double getTotalPrice(int bookingId) {
        String sql = "SELECT total_price FROM Booking WHERE booking_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("total_price");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    public int getUserIdByBookingId(int bookingId) throws SQLException {
    String sql = "SELECT user_id FROM Booking WHERE booking_id = ?";
    try (Connection conn = DBContext.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, bookingId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt("user_id");
        }
    }
    return 0;
}
    public int getVoucherIdByBookingId(int bookingId) {
    String sql = "SELECT voucher_id FROM Booking WHERE booking_id = ?";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, bookingId);
        ResultSet rs = ps.executeQuery();
        if (rs.next() && rs.getObject("voucher_id") != null) {
            return rs.getInt("voucher_id");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
}
    public void removeVoucherFromBooking(int bookingId) {
    String sql = "UPDATE Booking SET voucher_id = NULL WHERE booking_id = ?";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, bookingId);
        ps.executeUpdate();

    } catch (SQLException e) {
        e.printStackTrace();
    }
}

}
