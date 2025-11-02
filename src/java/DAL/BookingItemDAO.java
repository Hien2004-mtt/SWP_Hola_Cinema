package DAL;

import java.sql.*;
import Models.BookingItem;
import java.util.List;
import java.util.ArrayList;

public class BookingItemDAO {

   
    public void addBookingItems(Connection conn,int bookingId, int showtimeId, List<BookingItem> items) {
        String sql = "INSERT INTO BookingItem (booking_id, showtime_id, seat_id, price) VALUES (?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            for (BookingItem item : items) {
                ps.setInt(1, bookingId);
                ps.setInt(2, showtimeId); 
                ps.setInt(3, item.getSeatId());
                ps.setDouble(4, item.getPrice());
                ps.addBatch();
            }

            ps.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

   
    public List<BookingItem> getItemsByBookingId(int bookingId) {
        List<BookingItem> list = new ArrayList<>();
        String sql = "SELECT * FROM BookingItem WHERE booking_id = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                BookingItem bi = new BookingItem();
                bi.setBookingItemId(rs.getInt("booking_item_id"));
                bi.setBookingId(rs.getInt("booking_id"));
                bi.setSeatId(rs.getInt("seat_id"));
                bi.setPrice(rs.getDouble("price"));
                // ❌ Không còn seat_type ở bảng này, nên bỏ dòng setSeatType()
                list.add(bi);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
