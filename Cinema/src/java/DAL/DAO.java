/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAL;

import Models.User;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import java.sql.*;
import java.time.LocalDate;

public class DAO {
    
    //ma hoa mat khau
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes(StandardCharsets.UTF_8));

            // Convert bytes to hex string
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString(); // Trả về chuỗi hex
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }

    // dang ky nguoi dung
    public boolean register(User user) {
        String sql = "INSERT INTO Users (email, password_hash, name, phone, dob, gender, role, created_at, updated_at) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPasswordHash());
            ps.setString(3, user.getName());
            ps.setString(4, user.getPhone());
            ps.setDate(5, Date.valueOf(user.getDob()));
            ps.setBoolean(6, user.isGender());
            ps.setInt(7, user.getRole());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // tim nguoi dung theo email
    public User findByEmail(String email) {
        String sql = "SELECT * FROM Users WHERE email = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User u = new User();
                u.setUserId(rs.getInt("user_id"));
                u.setEmail(rs.getString("email"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setName(rs.getString("name"));
                u.setPhone(rs.getString("phone"));
                Date dob = rs.getDate("dob");
                if (dob != null) u.setDob(dob.toLocalDate());
                u.setGender(rs.getBoolean("gender"));
                u.setRole(rs.getInt("role"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setUpdatedAt(rs.getTimestamp("updated_at"));
                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    // Lấy danh sách người dùng, có thể tìm kiếm theo tên hoặc email
        public java.util.List<User> getAllUsers(String search) {
            return getAllUsers(search, null, null);
        }

        // Overload hỗ trợ sort
        public java.util.List<User> getAllUsers(String search, String sortField, String sortOrder) {
            java.util.List<User> userList = new java.util.ArrayList<>();
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT user_id, email, password_hash, name, phone, dob, gender, role, created_at, updated_at FROM Users");
            boolean hasSearch = search != null && !search.trim().isEmpty();
            if (hasSearch) {
                sql.append(" WHERE email LIKE ? OR name LIKE ?");
            }
            // Validate sortField and sortOrder
            String field = "user_id";
            if ("role".equalsIgnoreCase(sortField)) field = "role";
            String order = "ASC";
            if ("desc".equalsIgnoreCase(sortOrder)) order = "DESC";
            sql.append(" ORDER BY " + field + " " + order);
            try (java.sql.Connection conn = DBContext.getConnection();
                 java.sql.PreparedStatement ps = conn.prepareStatement(sql.toString())) {
                if (hasSearch) {
                    ps.setString(1, "%" + search + "%");
                    ps.setString(2, "%" + search + "%");
                }
                java.sql.ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    User u = new User();
                    u.setUserId(rs.getInt("user_id"));
                    u.setEmail(rs.getString("email"));
                    u.setPasswordHash(rs.getString("password_hash"));
                    u.setName(rs.getString("name"));
                    u.setPhone(rs.getString("phone"));
                    java.sql.Date dob = rs.getDate("dob");
                    if (dob != null) u.setDob(dob.toLocalDate());
                    u.setGender(rs.getBoolean("gender"));
                    u.setRole(rs.getInt("role"));
                    u.setCreatedAt(rs.getTimestamp("created_at"));
                    u.setUpdatedAt(rs.getTimestamp("updated_at"));
                    userList.add(u);
                }
            } catch (java.sql.SQLException e) {
                e.printStackTrace();
            }
            return userList;
        }
    // Xóa user theo id
    public boolean deleteUserById(int userId) {
        String sql = "DELETE FROM Users WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

        // Cập nhật role cho user
        public boolean updateUserRole(int userId, int role) {
            String sql = "UPDATE Users SET role = ? WHERE user_id = ?";
            try (Connection conn = DBContext.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, role);
                ps.setInt(2, userId);
                return ps.executeUpdate() > 0;
            } catch (SQLException e) {
                e.printStackTrace();
                return false;
            }
        }
}
