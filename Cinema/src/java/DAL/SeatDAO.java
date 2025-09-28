/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAL;

import Models.Seat;
import java.util.AbstractList;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;
/**
 *
 * @author USER
 */
public class SeatDAO {
    public List<Seat>  getAllSeat() throws SQLException{
        List<Seat> seat = new ArrayList<>();  
        String sql = "SELECT * FROM Seat";
        try(PreparedStatement ps = DBContext.getConnection().prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while(rs.next()){
                Seat s = new Seat();
                s.setSeatId(rs.getInt("seat_id"));
                s.setAuditoriumId(rs.getInt("auditorium_id"));
                s.setRow(rs.getString("row"));
                s.setNumber(rs.getInt("number"));
                s.setSeatType(rs.getString("seat_type"));
                s.setIsActivate(rs.getBoolean("is_active"));
                seat.add(s);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
     return seat;
    }
}
