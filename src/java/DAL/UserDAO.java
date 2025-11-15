package DAL;

import Models.User;
import Util.PasswordUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    private static final String SELECT_USER_BY_EMAIL = "SELECT * FROM [dbo].[Users] WHERE email = ?";
    private static final String INSERT_USER = "INSERT INTO [dbo].[Users] (email, password_hash, name, phone, dob, gender, role) VALUES (?, ?, ?, ?, ?, ?, 2)";
    private static final String UPDATE_PROFILE = "UPDATE [dbo].[Users] SET password_hash = ?, name = ?, phone = ?, dob = ?, gender = ?, updated_at = GETDATE() WHERE email = ?";
    private static final String SELECT_USER_BY_EMAIL_FULL = "SELECT * FROM [dbo].[Users] WHERE email = ?";

    public User login(String email, String password) {
        User user = null;
        try (Connection conn = DBContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(SELECT_USER_BY_EMAIL)) {
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                String storedHash = rs.getString("password_hash");
                String statusStr = rs.getString("status");
                boolean isActive = statusStr != null && statusStr.equalsIgnoreCase("active");

                // Check if account is banned
                if (!isActive) {
                    return null; // Account is banned, cannot login
                }

                // Verify password using BCrypt
                // Support both BCrypt hashed passwords and legacy plain text passwords
                boolean passwordMatches = false;
                if (storedHash.startsWith("$2a$") || storedHash.startsWith("$2b$") || storedHash.startsWith("$2y$")) {
                    // BCrypt hash detected
                    passwordMatches = PasswordUtil.verifyPassword(password, storedHash);
                } else {
                    // Legacy plain text password (for backward compatibility)
                    passwordMatches = password.equals(storedHash);
                }

                if (passwordMatches) {
                    user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setEmail(rs.getString("email"));
                    user.setPasswordHash(storedHash);
                    user.setName(rs.getString("name"));
                    user.setPhone(rs.getString("phone"));
                    user.setDob(rs.getDate("dob"));
                    user.setGender(rs.getBoolean("gender"));
                    user.setRole(rs.getInt("role"));
                    user.setStatus(isActive);
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    user.setUpdatedAt(rs.getTimestamp("updated_at"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("❌ Lỗi khi truy vấn dữ liệu người dùng: " + e.getMessage(), e);
        }
        return user;
    }

    public User getUserById(int userId) {
        User user = null;
        String query = "SELECT * FROM [dbo].[Users] WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setEmail(rs.getString("email"));
                user.setPasswordHash(rs.getString("password_hash"));
                user.setName(rs.getString("name"));
                user.setPhone(rs.getString("phone"));
                user.setDob(rs.getDate("dob"));
                user.setGender(rs.getBoolean("gender"));
                user.setRole(rs.getInt("role"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setUpdatedAt(rs.getTimestamp("updated_at"));
            }
        } catch (SQLException e) {
            throw new RuntimeException("❌ Lỗi khi truy vấn người dùng theo ID: " + e.getMessage(), e);
        }
        return user;
    }

    // dang ki
    public boolean registerUser(String email, String passwordHash, String name, String phone, java.sql.Date dob, boolean gender) {
        try (Connection conn = DBContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(INSERT_USER)) {
            pstmt.setString(1, email);
            pstmt.setString(2, passwordHash);
            pstmt.setString(3, name);
            pstmt.setString(4, phone);
            pstmt.setDate(5, dob);
            pstmt.setBoolean(6, gender);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw new RuntimeException("❌ Lỗi khi đăng ký người dùng: " + e.getMessage(), e);
        }
    }

    public boolean updateProfile(String email, String passwordHash, String name, String phone, java.sql.Date dob, boolean gender) {
        try (Connection conn = DBContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(UPDATE_PROFILE)) {
            pstmt.setString(1, passwordHash);
            pstmt.setString(2, name);
            pstmt.setString(3, phone);
            pstmt.setDate(4, dob);
            pstmt.setBoolean(5, gender);
            pstmt.setString(6, email);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            throw new RuntimeException("❌ Lỗi khi cập nhật profile: " + e.getMessage(), e);
        }
    }

    public User getUserByEmail(String email) {
        User user = null;
        try (Connection conn = DBContext.getConnection(); PreparedStatement pstmt = conn.prepareStatement(SELECT_USER_BY_EMAIL_FULL)) {
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setEmail(rs.getString("email"));
                user.setPasswordHash(rs.getString("password_hash"));
                user.setName(rs.getString("name"));
                user.setPhone(rs.getString("phone"));
                user.setDob(rs.getDate("dob"));
                user.setGender(rs.getBoolean("gender"));
                user.setRole(rs.getInt("role"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                user.setUpdatedAt(rs.getTimestamp("updated_at"));
            }
        } catch (SQLException e) {
            throw new RuntimeException("❌ Lỗi khi lấy user theo email: " + e.getMessage(), e);
        }
        return user;
    }
}
