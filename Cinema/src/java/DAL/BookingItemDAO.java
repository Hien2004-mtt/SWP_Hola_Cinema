/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAL;
import Models.BookingItem;
import java.sql.*;
/**
 *
 * @author Admin
 */
public class BookingItemDAO {
    public boolean createBookingItem(BookingItem item){
        String sql = "INSERT INTO BookingItemBookingItem ("
                + "booking_id, "
                + "showtime_id, "
                + "seat_id, "
                + "price, "
                + "ticket_type) "
                + "VALUES (?, ?, ?, ?, ?)\"; ";
        try(PreparedStatement ps = DBContext.getConnection().prepareStatement(sql);
                ResultSet rs = ps.executeQuery())  {
            ps.setInt(1, item.getBookingId());
            ps.setInt(2, item.getShowtimeId());
            ps.setInt(3, item.getSeat_id());
            ps.setDouble(4, item.getPrice());
            ps.setString(5, item.getTicketType());
            return ps.executeUpdate() >0 ;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public void insert(BookingItem item){
        String sql ="INSERT INTO BookingItem("
                +"booking_id,"
                +"showtime_id,"
                +"seat_id,"
                +"price,"
                +"ticket_type"
                + ")";
                try(PreparedStatement ps = DBContext.getConnection().prepareStatement(sql)){
                    ps.setInt(1, item.getBookingId());
                    ps.setInt(2, item.getBookingItemId());
                    ps.setInt(3, item.getSeat_id());
                    ps.setDouble(4, item.getPrice());
                    ps.setString(5, item.getTicketType());
                    ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
