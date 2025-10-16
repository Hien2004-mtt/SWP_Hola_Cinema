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
        String sql = "SELECT movie_id, title AS movieTitle FROM Movie WHERE status = 'coming soon' AND release_date >= ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    movies.add(new ShowtimeSchedule(0, rs.getInt("movie_id"), rs.getString("movieTitle"), 0, null, null, null, 0.0));
                }
            }
        }
        return movies;
    }

    public List<ShowtimeSchedule> getActiveAuditoriums() throws SQLException, ClassNotFoundException {
        List<ShowtimeSchedule> auditoriums = new ArrayList<>();
        String sql = "SELECT auditorium_id, name AS auditoriumName FROM Auditorium WHERE is_active = 1";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                auditoriums.add(new ShowtimeSchedule(0, 0, null, rs.getInt("auditorium_id"), rs.getString("auditoriumName"), null, null, 0.0));
            }
        }
        return auditoriums;
    }

    public boolean checkTimeConflict(int auditoriumId, Timestamp startTime, Timestamp endTime) throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM Showtime WHERE auditorium_id = ? AND ((start_time <= ? AND end_time > ?) OR (start_time < ? AND end_time >= ?))";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
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

    public boolean checkTimeConflictExcept(int showtimeId, int auditoriumId, Timestamp startTime, Timestamp endTime) throws SQLException, ClassNotFoundException {
        String sql = "SELECT COUNT(*) FROM Showtime WHERE auditorium_id = ? AND showtime_id <> ? AND ((start_time <= ? AND end_time > ?) OR (start_time < ? AND end_time >= ?))";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, auditoriumId);
            stmt.setInt(2, showtimeId);
            stmt.setTimestamp(3, startTime);
            stmt.setTimestamp(4, startTime);
            stmt.setTimestamp(5, endTime);
            stmt.setTimestamp(6, endTime);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return true;
                }
            }
        }
        return false;
    }

    public int addShowtime(int movieId, int auditoriumId, Timestamp startTime, Timestamp endTime, double basePrice) throws SQLException, ClassNotFoundException {
        if (checkTimeConflict(auditoriumId, startTime, endTime)) {
            return -1; // Trả về -1 nếu có xung đột
        }
        String sql = "INSERT INTO Showtime (movie_id, auditorium_id, start_time, end_time, base_price) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, movieId);
            stmt.setInt(2, auditoriumId);
            stmt.setTimestamp(3, startTime);
            stmt.setTimestamp(4, endTime);
            stmt.setDouble(5, basePrice);
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

    public List<ShowtimeSchedule> getAllShowtimes() throws SQLException, ClassNotFoundException {
        List<ShowtimeSchedule> schedules = new ArrayList<>();
        String sql = "SELECT s.showtime_id, s.movie_id, m.title AS movieTitle, s.auditorium_id, a.name AS auditoriumName, s.start_time, s.end_time, s.base_price "
                + "FROM Showtime s "
                + "JOIN Movie m ON s.movie_id = m.movie_id "
                + "JOIN Auditorium a ON s.auditorium_id = a.auditorium_id";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                schedules.add(new ShowtimeSchedule(
                        rs.getInt("showtime_id"),
                        rs.getInt("movie_id"),
                        rs.getString("movieTitle"),
                        rs.getInt("auditorium_id"),
                        rs.getString("auditoriumName"),
                        rs.getTimestamp("start_time"),
                        rs.getTimestamp("end_time"),
                        rs.getDouble("base_price")
                ));
            }
        }
        return schedules;
    }

    public boolean updateShowtime(int showtimeId, int movieId, int auditoriumId, Timestamp startTime, Timestamp endTime, double basePrice) throws SQLException, ClassNotFoundException {
        if (checkTimeConflictExcept(showtimeId, auditoriumId, startTime, endTime)) {
            return false;
        }
        String sql = "UPDATE Showtime SET movie_id = ?, auditorium_id = ?, start_time = ?, end_time = ?, base_price = ? WHERE showtime_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, movieId);
            stmt.setInt(2, auditoriumId);
            stmt.setTimestamp(3, startTime);
            stmt.setTimestamp(4, endTime);
            stmt.setDouble(5, basePrice);
            stmt.setInt(6, showtimeId);
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteShowtime(int showtimeId) throws SQLException, ClassNotFoundException {
        String sql = "DELETE FROM Showtime WHERE showtime_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, showtimeId);
            return stmt.executeUpdate() > 0;
        }
    }
}
