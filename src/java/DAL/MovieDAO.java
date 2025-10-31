package DAL;

import Models.Movie;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MovieDAO {

    /**
     * Lấy thông tin chi tiết 1 phim (bao gồm đạo diễn)
     */
    public Movie getMovieById(int id) {
        String sql = """
            SELECT m.*, 
                   d.name AS director_name, 
                   d.bio AS director_bio, 
                   d.photo_url AS director_photo
            FROM Movie m
            LEFT JOIN Director d ON m.director_id = d.director_id
            WHERE m.movie_id = ?
        """;

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Movie m = extractMovie(rs);
                // Gán thêm thông tin đạo diễn
                m.setDirectorName(rs.getString("director_name"));
                m.setDirectorBio(rs.getString("director_bio"));
                m.setDirectorPhoto(rs.getString("director_photo"));
                return m;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy danh sách phim đang chiếu
     */
    public List<Movie> getNowShowingMovies() {
        return getMoviesByStatus("now showing");
    }

    /**
     * Lấy danh sách phim sắp chiếu
     */
    public List<Movie> getComingSoonMovies() {
        return getMoviesByStatus("coming soon");
    }

    /**
     * Hàm chung lấy danh sách phim theo trạng thái
     */
    private List<Movie> getMoviesByStatus(String status) {
        List<Movie> list = new ArrayList<>();
        String sql = """
            SELECT m.*, 
                   d.name AS director_name
            FROM Movie m
            LEFT JOIN Director d ON m.director_id = d.director_id
            WHERE m.status = ?
            ORDER BY m.release_date DESC
        """;

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Movie m = extractMovie(rs);
                m.setDirectorName(rs.getString("director_name"));
                list.add(m);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Hàm hỗ trợ: tạo đối tượng Movie từ ResultSet
     */
    private Movie extractMovie(ResultSet rs) throws SQLException {
        Movie m = new Movie();
        m.setMovieId(rs.getInt("movie_id"));
        m.setTitle(rs.getString("title"));
        m.setDescription(rs.getString("description"));
        m.setDurationMinutes(rs.getInt("duration_minutes"));
        m.setLanguage(rs.getString("language"));
        m.setReleaseDate(rs.getDate("release_date"));
        m.setRating(rs.getString("rating"));
        m.setPosterUrl(rs.getString("poster_url"));
        m.setStatus(rs.getString("status"));
        m.setDirectorId(rs.getInt("director_id"));
        return m;
    }

    /**
     * Lấy toàn bộ danh sách phim (dành cho admin hoặc quản lý)
     */
    public List<Movie> getAllMovies() {
        List<Movie> list = new ArrayList<>();
        String sql = """
            SELECT m.*, 
                   d.name AS director_name
            FROM Movie m
            LEFT JOIN Director d ON m.director_id = d.director_id
            ORDER BY m.movie_id DESC
        """;

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Movie m = extractMovie(rs);
                m.setDirectorName(rs.getString("director_name"));
                list.add(m);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Tìm kiếm phim theo từ khóa (tên phim)
     */
    public List<Movie> searchMoviesByTitle(String keyword) {
        List<Movie> list = new ArrayList<>();
        String sql = """
        SELECT m.*, d.name AS director_name
        FROM Movie m
        LEFT JOIN Director d ON m.director_id = d.director_id
        WHERE m.title LIKE ?
        ORDER BY m.release_date DESC
    """;

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%"); // tìm gần đúng
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Movie m = extractMovie(rs);
                m.setDirectorName(rs.getString("director_name"));
                list.add(m);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

}
