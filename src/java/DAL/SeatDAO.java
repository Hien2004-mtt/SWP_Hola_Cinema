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

    public Seat getSeatByCode(String seatCode, int auditoriumId) {
        Seat seat = null;
        try {
            String row = seatCode.substring(0, 1); // Ví dụ: "A" từ "A10"
            int number = Integer.parseInt(seatCode.substring(1)); // Ví dụ: 10

            String sql = "SELECT * FROM Seat WHERE row = ? AND number = ? AND auditorium_id = ?";
            try (PreparedStatement ps = DBContext.getConnection().prepareStatement(sql)) {
                ps.setString(1, row);
                ps.setInt(2, number);
                ps.setInt(3, auditoriumId);

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

    public boolean updateSeatStatusById(int seatId, boolean isActive) { // set trường is_active theo id ghế
        String sql = "UPDATE Seat SET is_active = ? WHERE seat_id = ?";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, seatId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateSeatStatusByCode(String seatCode, boolean isActive, int auditoriumId) {
        try {
            // Tách row và number từ seatCode (VD: "B10" -> row = "B", number = 10)
            String row = seatCode.substring(0, 1);
            int number = Integer.parseInt(seatCode.substring(1));

            String sql = "UPDATE Seat SET is_active = ? WHERE row = ? AND number = ? AND auditorium_id = ?";
            try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setBoolean(1, isActive);
                ps.setString(2, row);
                ps.setInt(3, number);
                ps.setInt(4, auditoriumId);

                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean addMultipleSeats(List<Seat> seats) {
        String sql = "INSERT INTO Seat (auditorium_id, row, number, seat_type, is_active) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            for (Seat s : seats) {
                ps.setInt(1, s.getAuditoriumId());
                ps.setString(2, s.getRow());
                ps.setInt(3, s.getNumber());
                ps.setString(4, s.getSeatType());
                ps.setBoolean(5, s.isIsActivate());
                ps.addBatch();
            }

            ps.executeBatch();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateSeat(Seat seat) {
        String sql = "UPDATE Seat SET "
                + ", row = ?"
                + ", number = ?"
                + ",seat_type = ?"
                + "is_update = ?"
                + "WHERE auditorium_id = ? AND seat_id = ?";
        try (PreparedStatement ps = DBContext.getConnection().prepareStatement(sql)) {
            ps.setString(1, seat.getRow());
            ps.setInt(2, seat.getNumber());
            ps.setString(3, seat.getSeatType());
            ps.setBoolean(4, seat.isIsActivate());
            ps.setInt(5, seat.getAuditoriumId());
            ps.setInt(6, seat.getSeatId());

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Seat> getSeatByAuditoriumId(int auditoriumId) {
        List<Seat> list = new ArrayList<>();
        String sql = "SELECT * FROM Seat WHERE auditorium_id = ?";
        try (PreparedStatement ps = DBContext.getConnection().prepareStatement(sql);) {
            ps.setInt(1, auditoriumId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Seat s = new Seat();
                s.setSeatId(rs.getInt("seat_id"));
                s.setRow(rs.getString("row"));
                s.setNumber(rs.getInt("number"));
                s.setSeatType(rs.getString("seat_type"));
                s.setIsActivate(rs.getBoolean("is_active"));
                s.setIsShowing(rs.getBoolean("is_showing"));

                s.setAuditoriumId(auditoriumId);
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Seat getSeatById(int seatId) {
        String sql = "SELECT * FROM Seat WHERE seat_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, seatId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Seat seat = new Seat();
                seat.setSeatId(rs.getInt("seat_id"));
                seat.setAuditoriumId(rs.getInt("auditorium_id"));
                seat.setRow(rs.getString("row"));
                seat.setNumber(rs.getInt("number"));
                seat.setSeatType(rs.getString("seat_type"));
                seat.setIsActivate(rs.getBoolean("is_active"));
                return seat;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Seat> getSeatByRow(int auditoriumId, String row) {
        List<Seat> list = new ArrayList<>();
        String sql = "SELECT * FROM Seat WHERE auditorium_id = ? AND row = ? ORDER BY number";
        try (PreparedStatement ps = DBContext.getConnection().prepareStatement(sql)) {
            ps.setInt(1, auditoriumId);
            ps.setString(2, row);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Seat s = new Seat();
                s.setSeatId(rs.getInt("seat_id"));
                s.setAuditoriumId(rs.getInt("auditorium_id"));
                s.setRow(rs.getString("row"));
                s.setNumber(rs.getInt("number"));
                s.setSeatType(rs.getString("seat_type"));
                s.setIsActivate(rs.getBoolean("is_active"));
                s.setIsShowing(rs.getBoolean("is_showing"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean isSeatExists(int auditoriumId, String row, int number) {
        String sql = "SELECT 1 FROM Seat WHERE auditorium_id = ? AND row = ? AND number = ?";
        try (PreparedStatement ps = DBContext.getConnection().prepareStatement(sql)) {
            ps.setInt(1, auditoriumId);
            ps.setString(2, row);
            ps.setInt(3, number);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateSeatShowingStatus(int auditoriumId, String row, int number, boolean isShowing) {
        String sql = "UPDATE Seat SET is_showing = ? WHERE auditorium_id = ? AND [row] = ? AND [number] = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isShowing);
            ps.setInt(2, auditoriumId);
            ps.setString(3, row);
            ps.setInt(4, number);

            int affected = ps.executeUpdate();
            return affected > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean restoreSeat(int auditoriumId, String row, int number) {
        String sql = "UPDATE Seat SET is_showing = 1 WHERE auditorium_id = ? AND [row] = ? AND [number] = ? AND is_showing = 0";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, auditoriumId);
            ps.setString(2, row);
            ps.setInt(3, number);

            return ps.executeUpdate() > 0; // trả về true nếu có ghế được cập nhật

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    // Cập nhật loại ghế

    public boolean updateSeatType(int auditoriumId, String row, int number, String newType) {
        String sql = "UPDATE Seat SET seat_type = ? WHERE auditorium_id = ? AND [row] = ? AND [number] = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newType);
            ps.setInt(2, auditoriumId);
            ps.setString(3, row);
            ps.setInt(4, number);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}
