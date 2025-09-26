package DAL;

import model.User;
import DAL.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.ResultSet;
public class UserDAO {

    public void updateUser(User u) throws Exception {
        String sql = "UPDATE [dbo].[Users]\n"
                + "SET [name] = ?,\n"
                + "    [phone] = ?,\n"
                + "    [gender] = ?,\n"
                + "    [updated_at] = ?,\n"
                + "    [password_hash] = ?\n"
                + "WHERE [user_id] = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, u.getName());
            ps.setString(2, u.getPhone());
            ps.setBoolean(3, u.isGender());
            ps.setTimestamp(4, new Timestamp(u.getUpdateAt().getTime()));
            ps.setString(5, u.getPassword());
            ps.setInt(6, u.getUserId());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

   public User getUserById(int id) {
    String sql = "SELECT [user_id]"
               + ", [email]"
               + ", [password_hash]"
               + ", [name]"
               + ", [phone]"
               + ", [dob]"
               + ", [gender]"
               + ", [role]"
               + ", [created_at]"
               + ", [updated_at]"
               + " FROM [dbo].[Users] WHERE [user_id] = ?";
    try (Connection conn = new DBContext().getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setInt(1, id);
        try(ResultSet rs = ps.executeQuery()){
        if (rs.next()) {
            User u = new User();
            u.setUserId(rs.getInt("user_id"));
            u.setEmail(rs.getString("email"));
            u.setPassword(rs.getString("password_hash"));
            u.setName(rs.getString("name"));
            u.setPhone(rs.getString("phone"));
            u.setDob(rs.getDate("dob"));
            u.setGender(rs.getBoolean("gender"));
            u.setRole(rs.getInt("role"));
            u.setCreateAt(rs.getTimestamp("created_at"));
            u.setUpdateAt(rs.getTimestamp("updated_at"));
            return u;
        }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}


    
}
   


