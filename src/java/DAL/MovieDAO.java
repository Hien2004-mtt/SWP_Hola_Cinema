package DAL;

import Models.Movie;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MovieDAO {

    /**
     * Lấy thông tin chi tiết 1 phim theo ID
     */
    public Movie getMovieById(int id) {
        String sql = """
            SELECT *
            FROM Movie
            WHERE movie_id = ?
        """;

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return extractMovie(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy danh sách phim theo trạng thái (now showing / coming soon / archived)
     */
    private List<Movie> getMoviesByStatus(String status) {
        List<Movie> list = new ArrayList<>();
        String sql = """
            SELECT *
            FROM Movie
            WHERE status = ?
            ORDER BY release_date DESC
        """;

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractMovie(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Lấy danh sách phim đang chiếu */
    public List<Movie> getNowShowingMovies() {
        return getMoviesByStatus("now showing");
    }

    /** Lấy danh sách phim sắp chiếu */
    public List<Movie> getComingSoonMovies() {
        return getMoviesByStatus("coming soon");
    }

    /** Lấy danh sách phim đã lưu trữ */
    public List<Movie> getArchivedMovies() {
        return getMoviesByStatus("archived");
    }

    /**
     * Lấy toàn bộ phim (dành cho admin)
     */
    public List<Movie> getAllMovies() {
        List<Movie> list = new ArrayList<>();
        String sql = """
            SELECT *
            FROM Movie
            ORDER BY movie_id DESC
        """;

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(extractMovie(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Tìm kiếm phim theo tên (LIKE)
     */
    public List<Movie> searchMoviesByTitle(String keyword) {
        List<Movie> list = new ArrayList<>();
        String sql = """
            SELECT *
            FROM Movie
            WHERE title LIKE ?
            ORDER BY release_date DESC
        """;

        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractMovie(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Hàm hỗ trợ: Tạo đối tượng Movie từ ResultSet
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
        m.setDirectorName(rs.getString("director_name")); // trong DB có cột này
        m.setPosterUrl(rs.getString("poster_url"));
        m.setTrailerUrl(rs.getString("trailer_url"));
        m.setStatus(rs.getString("status"));
        return m;
    }

    // =========================
    // MAIN TEST
    // =========================
    public static void main(String[] args) {
        MovieDAO dao = new MovieDAO();

        System.out.println("=== TEST getAllMovies() ===");
        List<Movie> all = dao.getAllMovies();
        for (Movie m : all) {
            System.out.printf("%d | %s | %s | %s%n",
                    m.getMovieId(), m.getTitle(), m.getDirectorName(), m.getStatus());
        }

        System.out.println("\n=== TEST getMovieById(1) ===");
        Movie movie = dao.getMovieById(1);
        if (movie != null) {
            System.out.println("Title: " + movie.getTitle());
            System.out.println("Director: " + movie.getDirectorName());
            System.out.println("Language: " + movie.getLanguage());
        } else {
            System.out.println("Không tìm thấy phim ID=1");
        }

        System.out.println("\n=== TEST getNowShowingMovies() ===");
        for (Movie m : dao.getNowShowingMovies()) {
            System.out.println(m.getTitle() + " - " + m.getStatus());
        }

        System.out.println("\n=== TEST searchMoviesByTitle('Man') ===");
        for (Movie m : dao.searchMoviesByTitle("Man")) {
            System.out.println(m.getTitle());
        }
    }
}
