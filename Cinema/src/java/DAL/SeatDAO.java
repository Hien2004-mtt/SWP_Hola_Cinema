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

    public List<Seat> getAllSeat() throws SQLException {
        List<Seat> seat = new ArrayList<>();
        String sql = "SELECT * FROM Seat";
        try (PreparedStatement ps = DBContext.getConnection().prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
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

    public Seat getSeatByCode(String seatCode) {
        Seat seat = null;
        try {
            String row = seatCode.substring(0, 1); // lay chu cai lam row
            int number = Integer.parseInt(seatCode.substring(1)); // lay so dung sau row

            String sql = "SELECT * FROM Seat WHERE row = ? AND number = ?";
            try (PreparedStatement ps = DBContext.getConnection().prepareStatement(sql)) {
                ps.setString(1, row);
                ps.setInt(2, number);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        seat = new Seat();
                        seat.setSeatId(rs.getInt("seat_id"));
                        seat.setAuditoriumId(rs.getInt("auditorium_id"));
                        seat.setRow(rs.getString("row"));
                        seat.setNumber(rs.getInt("number"));
                        seat.setSeatType(rs.getString("seat_type"));
                        seat.setIsActivate(rs.getBoolean("is_active"));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return seat;
    }

}
