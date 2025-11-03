/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAL;

import DAL.DBContext;
import Models.Showtime;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;

/**
 *
 * @author USER
 */
public class ShowtimeDAO {

    public List<Showtime> getAllShowtimeByMovieId(int movieId) {
        List<Showtime> list = new ArrayList<>();
        String sql = """
        SELECT * FROM Showtime
        WHERE movie_id = ?
        AND DATEADD(MINUTE, -20, start_time) > GETDATE()
        ORDER BY start_time ASC
    """;
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, movieId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Showtime s = new Showtime();
                s.setShowtimeId(rs.getInt("showtime_id"));
                s.setMovieId(rs.getInt("movie_id"));
                s.setAuditoriumId(rs.getInt("auditorium_id"));
                s.setStartTime(rs.getTimestamp("start_time"));
                s.setEndTime(rs.getTimestamp("end_time"));
                s.setBasePrice(rs.getDouble("base_price"));
                list.add(s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;

    }

    public Showtime getShowtimeById(int id) {
        String sql = "SELECT * FROM Showtime WHERE showtime_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Showtime st = new Showtime();
                st.setShowtimeId(rs.getInt("showtime_id"));
                st.setMovieId(rs.getInt("movie_id"));
                st.setAuditoriumId(rs.getInt("auditorium_id"));
                st.setStartTime(rs.getTimestamp("start_time"));
                st.setBasePrice(rs.getDouble("base_price"));
                return st;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int getAuditoriumIdByShowtime(int showtimeId) {
        int auditoriumId = -1;
        String sql = "SELECT auditorium_id FROM Showtime WHERE showtime_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, showtimeId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    auditoriumId = rs.getInt("auditorium_id");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return auditoriumId;
    }
     public String getMovieTitleByShowtime(int showtimeId) {
        String sql = "SELECT m.title FROM Showtime s JOIN Movie m ON s.movie_id = m.movie_id WHERE s.showtime_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, showtimeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("title");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 🟠 Lấy tên phòng chiếu (auditorium_name) theo showtime_id
    public String getAuditoriumNameByShowtime(int showtimeId) {
        String sql = "SELECT a.name FROM Showtime s JOIN Auditorium a ON s.auditorium_id = a.auditorium_id WHERE s.showtime_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, showtimeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("name");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
