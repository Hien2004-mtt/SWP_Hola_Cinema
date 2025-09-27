package DAO;

import DAL.DBContext;
import Models.Users;
import java.sql.*;
import java.time.LocalDateTime;
import org.mindrot.jbcrypt.BCrypt;

public class UserDAO {

//    private boolean isValidPassword(String password) {
//        if (password == null || password.length() < 6) return false;
//        boolean hasUpper = false;
//        boolean hasDigit = false;
//        for (char c : password.toCharArray()) {
//            if (Character.isUpperCase(c)) hasUpper = true;
//            if (Character.isDigit(c)) hasDigit = true;
//        }
//        return hasUpper && hasDigit;
//    }
//
//    // Register trả về Users thay vì String
//    public Users register(String name, String email, String password,
//                          String phone, String dob, boolean gender) {
//        try (Connection conn = new DBContext().getConnection()) {
//
//            if (!isValidPassword(password)) {
//                return null; // sai password rule
//            }
//
//            // Check unique email
//            try (PreparedStatement checkEmail = conn.prepareStatement("SELECT user_id FROM Users WHERE email=?")) {
//                checkEmail.setString(1, email);
//                ResultSet rsEmail = checkEmail.executeQuery();
//                if (rsEmail.next()) return null; // email tồn tại
//            }
//
//            // Check unique phone
//            if (phone != null && !phone.trim().isEmpty()) {
//                try (PreparedStatement checkPhone = conn.prepareStatement("SELECT user_id FROM Users WHERE phone=?")) {
//                    checkPhone.setString(1, phone);
//                    ResultSet rsPhone = checkPhone.executeQuery();
//                    if (rsPhone.next()) return null; // phone tồn tại
//                }
//            }
//
//            // Hash password
//            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
//
//            // Insert + lấy ID mới
//            String sql = "INSERT INTO Users (email, password_hash, name, phone, dob, gender, role, created_at, updated_at) " +
//                         "OUTPUT INSERTED.user_id VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
//            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
//                stmt.setString(1, email);
//                stmt.setString(2, hashedPassword);
//                stmt.setString(3, name);
//                stmt.setString(4, phone);
//                stmt.setString(5, dob); // yyyy-MM-dd
//                stmt.setBoolean(6, gender);
//                stmt.setInt(7, 2); // role mặc định customer
//                stmt.setTimestamp(8, Timestamp.valueOf(LocalDateTime.now()));
//                stmt.setTimestamp(9, Timestamp.valueOf(LocalDateTime.now()));
//
//                ResultSet rs = stmt.executeQuery();
//                if (rs.next()) {
//                    int userId = rs.getInt("user_id");
//                    return new Users(userId, email, name, 2);
//                }
//            }
//
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null; // lỗi
//    }

//    // Login by phone
//    public Users loginByPhone(String phone, String password) {
//        try (Connection conn = new DBContext().getConnection()) {
//            String sql = "SELECT user_id, email, name, password_hash, role FROM Users WHERE phone=?";
//            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
//                stmt.setString(1, phone);
//                ResultSet rs = stmt.executeQuery();
//                if (rs.next()) {
//                    String hashedPassword = rs.getString("password_hash");
//                    if (BCrypt.checkpw(password, hashedPassword)) {
//                        return new Users(
//                            rs.getInt("user_id"),
//                            rs.getString("email"),
//                            rs.getString("name"),
//                            rs.getInt("role")
//                        );
//                    }
//                }
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return null; // login fail
//    }
    
    
}
