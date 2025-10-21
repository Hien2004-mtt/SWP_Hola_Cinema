/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAL;

import Models.UserAccount;
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

//    // dang ky nguoi dung
//    public boolean register(User user) {
//        String sql = "INSERT INTO Users (email, password_hash, name, phone, dob, gender, role, created_at, updated_at) "
//                   + "VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
//        try (Connection conn = DBContext.getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setString(1, user.getEmail());
//            ps.setString(2, user.getPasswordHash());
//            ps.setString(3, user.getName());
//            ps.setString(4, user.getPhone());
//            ps.setDate(5, Date.valueOf(user.getDob()));
//            ps.setBoolean(6, user.isGender());
//            ps.setInt(7, user.getRole());
//
//            return ps.executeUpdate() > 0;
//        } catch (SQLException e) {
//            e.printStackTrace();
//            return false;
//        }
//    }
    // Tìm người dùng theo số điện thoại
    public UserAccount findByPhone(String phone) {
        String sql = "SELECT * FROM Users WHERE phone = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                UserAccount u = new UserAccount();
                u.setUserId(rs.getInt("user_id"));
                u.setEmail(rs.getString("email"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setName(rs.getString("name"));
                u.setPhone(rs.getString("phone"));
                Date dob = rs.getDate("dob");
                if (dob != null) {
                    u.setDob(dob.toLocalDate());
                }
                u.setGender(rs.getBoolean("gender"));
                u.setRole(rs.getInt("role"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setUpdatedAt(rs.getTimestamp("updated_at"));
                u.setStatus(rs.getBoolean("status"));
                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // tim nguoi dung theo email
    public UserAccount findByEmail(String email) {
        String sql = "SELECT * FROM Users WHERE email = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                UserAccount u = new UserAccount();
                u.setUserId(rs.getInt("user_id"));
                u.setEmail(rs.getString("email"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setName(rs.getString("name"));
                u.setPhone(rs.getString("phone"));
                Date dob = rs.getDate("dob");
                if (dob != null) {
                    u.setDob(dob.toLocalDate());
                }
                u.setGender(rs.getBoolean("gender"));
                u.setRole(rs.getInt("role"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setUpdatedAt(rs.getTimestamp("updated_at"));
                u.setStatus(rs.getBoolean("status"));
                return u;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy danh sách người dùng, có thể tìm kiếm theo tên, email hoặc sđt
    public java.util.List<UserAccount> getAllUsers(String search) {
        return getAllUsers(search, null, null, null);
    }

    // Overload hỗ trợ sort và lọc role
    public java.util.List<UserAccount> getAllUsers(String search, String sortField, String sortOrder, String roleParam) {
        java.util.List<UserAccount> userList = new java.util.ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append(
                "SELECT user_id, email, password_hash, name, phone, dob, gender, role, status, created_at, updated_at FROM Users");
        boolean hasSearch = search != null && !search.trim().isEmpty();
        boolean hasRole = roleParam != null && !roleParam.equals("") && !roleParam.equals("all");
        if (hasSearch || hasRole) {
            sql.append(" WHERE ");
            if (hasSearch) {
                sql.append("(email LIKE ? OR name LIKE ? OR phone LIKE ?)");
            }
            if (hasSearch && hasRole) {
                sql.append(" AND ");
            }
            if (hasRole) {
                sql.append("role = ?");
            }
        }
        // Validate sortField and sortOrder
        String field = "user_id";
        if ("role".equalsIgnoreCase(sortField)) {
            field = "role";
        }
        String order = "ASC";
        if ("desc".equalsIgnoreCase(sortOrder)) {
            order = "DESC";
        }
        sql.append(" ORDER BY " + field + " " + order);
        try (java.sql.Connection conn = DBContext.getConnection(); java.sql.PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (hasSearch) {
                ps.setString(idx++, "%" + search + "%"); // email
                ps.setString(idx++, "%" + search + "%"); // name
                ps.setString(idx++, "%" + search + "%"); // phone
            }
            if (hasRole) {
                ps.setInt(idx++, Integer.parseInt(roleParam));
            }
            java.sql.ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                UserAccount u = new UserAccount();
                u.setUserId(rs.getInt("user_id"));
                u.setEmail(rs.getString("email"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setName(rs.getString("name"));
                u.setPhone(rs.getString("phone"));
                java.sql.Date dob = rs.getDate("dob");
                if (dob != null) {
                    u.setDob(dob.toLocalDate());
                }
                u.setGender(rs.getBoolean("gender"));
                u.setRole(rs.getInt("role"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setUpdatedAt(rs.getTimestamp("updated_at"));
                u.setStatus(rs.getBoolean("status"));
                userList.add(u);
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
        return userList;
    }

    // Cập nhật role cho user
    public boolean updateUserRole(int userId, int role) {
        // Kiểm tra nếu user hiện tại là admin thì không cho đổi role
        String checkSql = "SELECT role FROM Users WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement checkPs = conn.prepareStatement(checkSql)) {
            checkPs.setInt(1, userId);
            ResultSet rs = checkPs.executeQuery();
            if (rs.next() && rs.getInt("role") == 0) {
                // Nếu là admin thì không cho đổi role
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
        String sql = "UPDATE Users SET role = ?, updated_at = GETDATE() WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, role);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateUserStatus(int userId, boolean status) {
        String sql = "UPDATE Users SET status = ?, updated_at = GETDATE() WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, status);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
