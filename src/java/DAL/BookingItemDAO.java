package DAL;

import java.sql.*;
import Models.BookingItem;
import java.util.List;

public class BookingItemDAO {

    /**
     *  Thêm danh sách ghế vào bảng BookingItem
     */
    public void addBookingItems(int bookingId, List<BookingItem> items) {
        String sql = "INSERT INTO BookingItem (booking_id, seat_id, price, seat_type, created_at) VALUES (?, ?, ?, ?, GETDATE())";

        try (
                Connection conn = DBContext.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);) {
            for (BookingItem item : items) {
                ps.setInt(1, bookingId);
                ps.setInt(2, item.getSeatId());
                ps.setDouble(3, item.getPrice());
                ps.setString(4, item.getSeatType());
                ps.addBatch(); // gom nhiều ghế lại insert 1 lần
            }

            ps.executeBatch(); // thực thi toàn bộ insert 1 lượt

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     *  Lấy danh sách ghế trong một booking (để hiển thị chi tiết đơn hàng)
     */
    public List<BookingItem> getItemsByBookingId(int bookingId) {
        List<BookingItem> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM BookingItem WHERE booking_id = ?";

        try (
                Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql);) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                BookingItem bi = new BookingItem();
                bi.setBookingItemId(rs.getInt("booking_item_id"));
                bi.setBookingId(rs.getInt("booking_id"));
                bi.setSeatId(rs.getInt("seat_id"));
                bi.setPrice(rs.getDouble("price"));
                bi.setSeatType(rs.getString("seat_type"));
                bi.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(bi);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
