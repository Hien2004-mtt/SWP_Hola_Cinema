package DAL;

import static DAL.DBContext.getConnection;
import Models.Movie;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author dinhh
 */
public class MovieDAO extends DBContext {

    // Check if movie exiests
    public boolean movieExists(String title, String directorName) {
        String sql = """
                    SELECT COUNT(*) FROM Movie
                    WHERE LOWER(TRIM(title)) = LOWER(TRIM(?))
                    AND LOWER(TRIM(director_name)) = LOWER(TRIM(?))
                """;
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, title);
            stmt.setString(2, directorName);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Method to add a new movie and return its generated ID
    public int addMovie(Movie movie) {
        String sql = """
                    INSERT INTO Movie (title, description, duration_minutes, language,
                        release_date, rating, poster_url, trailer_url, director_name, status)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;
        int movieId = -1;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setNString(1, movie.getTitle());
            ps.setNString(2, movie.getDescription());
            ps.setInt(3, movie.getDurationMinutes());
            ps.setNString(4, movie.getLanguage());
            LocalDate releaseDate = movie.getReleaseDate();
            if (releaseDate != null) {
                ps.setDate(5, Date.valueOf(releaseDate));
            } else {
                ps.setNull(5, Types.DATE);
            }

            ps.setString(6, movie.getRating());
            ps.setString(7, movie.getPosterUrl());
            ps.setString(8, movie.getTrailerUrl());
            ps.setNString(9, movie.getDirectorName());
            ps.setString(10, movie.getStatus());
            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    movieId = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return movieId;
    }

    // ===== ADD RELATIONS =====
    public void addMovieGenres(int movieId, List<Integer> genreIds) {
        String sql = "INSERT INTO Movie_Genre (movie_id, genre_id) VALUES (?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (Integer gid : genreIds) {
                ps.setInt(1, movieId);
                ps.setInt(2, gid);
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void addMovieActors(int movieId, List<Integer> actorIds) {
        String sql = "INSERT INTO Movie_Actor (movie_id, actor_id) VALUES (?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            for (Integer aid : actorIds) {
                ps.setInt(1, movieId);
                ps.setInt(2, aid);
                ps.addBatch();
            }
            ps.executeBatch();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ===== GET MOVIE BY ID =====
    public Movie getMovieById(int id) {
        String sql = "SELECT * FROM Movie WHERE movie_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Movie m = new Movie();
                m.setMovieId(rs.getInt("movie_id"));
                m.setTitle(rs.getString("title"));
                m.setDescription(rs.getString("description"));
                m.setDurationMinutes(rs.getInt("duration_minutes"));
                m.setLanguage(rs.getString("language"));
                m.setReleaseDate(rs.getDate("release_date") != null
                        ? rs.getDate("release_date").toLocalDate() : null);
                m.setRating(rs.getString("rating"));
                m.setPosterUrl(rs.getString("poster_url"));
                m.setTrailerUrl(rs.getString("trailer_url"));
                m.setDirectorName(rs.getString("director_name"));
                m.setStatus(rs.getString("status"));
                return m;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ===== UPDATE MOVIE =====
    public boolean updateMovie(Movie movie) {
        String sql = """
                    UPDATE Movie SET title=?, description=?, duration_minutes=?, language=?, 
                        release_date=?, rating=?, poster_url=?, trailer_url=?, 
                        director_name=?, status=? WHERE movie_id=?
                """;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setNString(1, movie.getTitle());
            ps.setNString(2, movie.getDescription());
            ps.setInt(3, movie.getDurationMinutes());
            ps.setNString(4, movie.getLanguage());

            if (movie.getReleaseDate() != null) {
                ps.setDate(5, Date.valueOf(movie.getReleaseDate()));
            } else {
                ps.setNull(5, Types.DATE);
            }

            ps.setString(6, movie.getRating());
            ps.setString(7, movie.getPosterUrl());
            ps.setString(8, movie.getTrailerUrl());
            ps.setNString(9, movie.getDirectorName());
            ps.setString(10, movie.getStatus());
            ps.setInt(11, movie.getMovieId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ===== DELETE RELATIONS (for update) =====
    public void deleteMovieGenres(int movieId) {
        String sql = "DELETE FROM Movie_Genre WHERE movie_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, movieId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteMovieActors(int movieId) {
        String sql = "DELETE FROM Movie_Actor WHERE movie_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, movieId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ===== GET RELATION IDs =====
    public List<Integer> getGenreIdsByMovie(int movieId) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT genre_id FROM Movie_Genre WHERE movie_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, movieId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getInt("genre_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Integer> getActorIdsByMovie(int movieId) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT actor_id FROM Movie_Actor WHERE movie_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, movieId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getInt("actor_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Movie> getAllMovies() throws SQLException {
        List<Movie> list = new ArrayList<>();
        String sql = "SELECT * FROM Movie";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Movie m = new Movie();
                m.setMovieId(rs.getInt("movie_id"));
                m.setTitle(rs.getString("title"));
                m.setRating(rs.getString("rating"));
                m.setDurationMinutes(rs.getInt("duration_minutes"));
                m.setLanguage(rs.getString("language"));
                m.setReleaseDate(rs.getDate("release_date") != null
                        ? rs.getDate("release_date").toLocalDate() : null);
                m.setStatus(rs.getString("status"));
                m.setPosterUrl(rs.getString("poster_url"));
                m.setTrailerUrl(rs.getString("trailer_url"));
                m.setDirectorName(rs.getString("director_name"));
                m.setDescription(rs.getString("description"));
                list.add(m);
            }
        }
        return list;
    }

    public List<Movie> searchMoviesByTitle(String keyword) throws SQLException {
        List<Movie> list = new ArrayList<>();
        String sql = "SELECT * FROM Movie WHERE title LIKE ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Movie m = new Movie();
                    m.setMovieId(rs.getInt("movie_id"));
                    m.setTitle(rs.getString("title"));
                    m.setRating(rs.getString("rating"));
                    m.setDurationMinutes(rs.getInt("duration_minutes"));
                    m.setLanguage(rs.getString("language"));
                    m.setReleaseDate(rs.getDate("release_date") != null
                            ? rs.getDate("release_date").toLocalDate() : null);
                    m.setStatus(rs.getString("status"));
                    m.setPosterUrl(rs.getString("poster_url"));
                    m.setTrailerUrl(rs.getString("trailer_url"));
                    m.setDirectorName(rs.getString("director_name"));
                    m.setDescription(rs.getString("description"));
                    list.add(m);
                }
            }
        }
        return list;
    }

    // Lọc phim theo nhiều tiêu chí
    public List<Movie> filterMoviesWithPaging(String keyword, String genreId, String actorId,
            String status, String rating, String director, int offset, int pageSize) throws SQLException {
        List<Movie> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
                    SELECT DISTINCT m.movie_id, m.title, m.rating, m.language, m.duration_minutes, m.release_date, 
                                    m.status, m.director_name, m.poster_url
                    FROM Movie m
                    LEFT JOIN Movie_Genre mg ON m.movie_id = mg.movie_id
                    LEFT JOIN Genre g ON mg.genre_id = g.genre_id AND g.is_active = 1
                    LEFT JOIN Movie_Actor ma ON m.movie_id = ma.movie_id
                    LEFT JOIN Actor a ON ma.actor_id = a.actor_id AND a.is_active = 1
                    WHERE 1=1
                """);

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND m.title LIKE ?");
            params.add(keyword + "%");
        }
        if (genreId != null && !genreId.isEmpty()) {
            sql.append(" AND g.genre_id = ?");
            params.add(genreId);
        }
        if (actorId != null && !actorId.isEmpty()) {
            sql.append(" AND a.actor_id = ?");
            params.add(actorId);
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND m.status = ?");
            params.add(status);
        }
        if (rating != null && !rating.isEmpty()) {
            sql.append(" AND m.rating = ?");
            params.add(rating);
        }
        if (director != null && !director.isEmpty()) {
            sql.append(" AND m.director_name LIKE ?");
            params.add(director + "%");
        }

        // ✅ Pagination for SQL Server
        sql.append(" ORDER BY m.movie_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = DBContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int index = 1;
            for (Object p : params) {
                stmt.setObject(index++, p);
            }
            stmt.setInt(index++, offset);
            stmt.setInt(index, pageSize);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Movie m = new Movie();
                m.setMovieId(rs.getInt("movie_id"));
                m.setTitle(rs.getString("title"));
                m.setRating(rs.getString("rating"));
                m.setLanguage(rs.getString("language"));
                m.setDurationMinutes(rs.getInt("duration_minutes"));
                m.setReleaseDate(rs.getDate("release_date") != null
                        ? rs.getDate("release_date").toLocalDate() : null);
                m.setStatus(rs.getString("status"));
                m.setDirectorName(rs.getString("director_name"));
                m.setPosterUrl(rs.getString("poster_url"));
                list.add(m);
            }
        }
        return list;
    }

    public int countFilteredMovies(String keyword, String genreId, String actorId,
            String status, String director) throws SQLException {
        StringBuilder sql = new StringBuilder("""
                    SELECT COUNT(DISTINCT m.movie_id)
                    FROM Movie m
                    LEFT JOIN Movie_Genre mg ON m.movie_id = mg.movie_id
                    LEFT JOIN Genre g ON mg.genre_id = g.genre_id AND g.is_active = 1
                    LEFT JOIN Movie_Actor ma ON m.movie_id = ma.movie_id
                    LEFT JOIN Actor a ON ma.actor_id = a.actor_id AND a.is_active = 1
                    WHERE 1=1
                """);

        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isEmpty()) {
            sql.append(" AND LOWER(m.title) LIKE ?");
            params.add("%" + keyword.toLowerCase() + "%");
        }
        if (genreId != null && !genreId.isEmpty()) {
            sql.append(" AND g.genre_id = ?");
            params.add(Integer.parseInt(genreId));
        }
        if (actorId != null && !actorId.isEmpty()) {
            sql.append(" AND a.actor_id = ?");
            params.add(Integer.parseInt(actorId));
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND LOWER(m.status) = ?");
            params.add(status.toLowerCase());
        }
        if (director != null && !director.trim().isEmpty()) {
            sql.append(" AND LOWER(m.director_name) LIKE ?");
            params.add("%" + director.toLowerCase() + "%");
        }

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
      private Movie extractMovieSafe(ResultSet rs) throws SQLException {
        Movie m = new Movie();
        m.setMovieId(rs.getInt("movie_id"));
        m.setTitle(rs.getString("title"));
        m.setDurationMinutes(rs.getInt("duration_minutes"));
        m.setLanguage(rs.getString("language"));
        Date date = rs.getDate("release_date");
        if (date != null) {
            m.setReleaseDate(date.toLocalDate());
        }
        m.setRating(rs.getString("rating"));
        m.setPosterUrl(rs.getString("poster_url"));
        m.setDirectorName(rs.getString("director_name"));
        m.setStatus(rs.getString("status"));
        try {
            m.setDescription(rs.getString("description"));
        } catch (SQLException ignore) {
        }
        return m;
    }

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
        String sql = "SELECT * FROM Movie WHERE status = ? ORDER BY release_date DESC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractMovieSafe(rs));
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
        m.setReleaseDate(rs.getDate("release_date") != null
                ? rs.getDate("release_date").toLocalDate() : null);
        m.setRating(rs.getString("rating"));
        m.setPosterUrl(rs.getString("poster_url"));
        m.setDirectorName(rs.getString("director_name"));
        m.setStatus(rs.getString("status"));
        return m;
    }

    /**
     * Lấy toàn bộ danh sách phim (dành cho admin hoặc quản lý)
     */
    public List<Movie> userGetAllMovies() {
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
    // ===== USER SEARCH =====
    public List<Movie> userSearchMoviesByTitle(String keyword) {
        List<Movie> list = new ArrayList<>();
        String sql = """
        SELECT * FROM Movie
        WHERE title LIKE ?
        ORDER BY release_date DESC
    """;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Movie m = new Movie();
                m.setMovieId(rs.getInt("movie_id"));
                m.setTitle(rs.getString("title"));
                m.setRating(rs.getString("rating"));
                m.setDurationMinutes(rs.getInt("duration_minutes"));
                m.setLanguage(rs.getString("language"));
                Date d = rs.getDate("release_date");
                if (d != null) {
                    m.setReleaseDate(d.toLocalDate());
                }
                m.setStatus(rs.getString("status"));
                m.setPosterUrl(rs.getString("poster_url"));
                m.setDirectorName(rs.getString("director_name"));
                try {
                    m.setDescription(rs.getString("description"));
                } catch (SQLException ignore) {
                }
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy danh sách phim đã lưu trữ
     */
    public List<Movie> getArchivedMovies() {
        return getMoviesByStatus("archived");
    }
}
