/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAL;
import Models.ShowtimeSchedule;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;


public class ScheduleDAO {

    // Các phương thức hiện có (updateUserStatus, getRevenueByMovie, v.v.) giữ nguyên

    public List<ShowtimeSchedule> getUpcomingMovies() throws SQLException, ClassNotFoundException {
        List<ShowtimeSchedule> movies = new ArrayList<>();
        String sql = "SELECT m.movie_id, m.movie_name FROM Movie m WHERE m.status = 'upcoming' AND m.release_date >= ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    movies.add(new ShowtimeSchedule(0, rs.getInt("movie_id"), rs.getString("movie_name"), 0, null, null, null, 0.0));
                }
            }
        }
        return movies;
    }

    public List<ShowtimeSchedule> getActiveAuditoriums() throws SQLException, ClassNotFoundException {
        List<ShowtimeSchedule> auditoriums = new ArrayList<>();
        String sql = "SELECT auditorium_id, name FROM Auditorium WHERE is_active = 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                auditoriums.add(new ShowtimeSchedule(0, 0, null, rs.getInt("auditorium_id"), rs.getString("name"), null, null, 0.0));
            }
        }
        return auditoriums;
    }

    public boolean checkTimeConflict(int auditoriumId, Timestamp startTime, Timestamp endTime) throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM Showtime WHERE auditorium_id = ? AND ((start_time <= ? AND end_time > ?) OR (start_time < ? AND end_time >= ?))";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, auditoriumId);
            stmt.setTimestamp(2, startTime);
            stmt.setTimestamp(3, startTime);
            stmt.setTimestamp(4, endTime);
            stmt.setTimestamp(5, endTime);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return true; // Có xung đột
                }
            }
        }
        return false;
    }

    public int addShowtime(int movieId, int auditoriumId, Timestamp startTime, Timestamp endTime, double price) throws SQLException, ClassNotFoundException {
        if (checkTimeConflict(auditoriumId, startTime, endTime)) {
            return -1; // Trả về -1 nếu có xung đột
        }
        String sql = "INSERT INTO Showtime (movie_id, auditorium_id, start_time, end_time, price, created_at, updated_at) VALUES (?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, movieId);
            stmt.setInt(2, auditoriumId);
            stmt.setTimestamp(3, startTime);
            stmt.setTimestamp(4, endTime);
            stmt.setDouble(5, price);
            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1); // Trả về showtime_id
                    }
                }
            }
        }
        return -1; // Lỗi nếu không thêm được
    }
}

