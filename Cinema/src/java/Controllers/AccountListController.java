import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


@WebServlet("/accountList")
public class AccountListController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Thông tin kết nối cơ sở dữ liệu
    private static final String JDBC_URL = "jdbc:sqlserver://localhost:1433;databaseName=cinema";
    private static final String JDBC_USER = "quyennb"; // Thay bằng username của bạn
    private static final String JDBC_PASSWORD = "123456"; // Thay bằng password của bạn

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Kiểm tra quyền truy cập (giả sử chỉ admin có thể truy cập)
//        if (!isAdmin(request)) {
//            response.sendRedirect("login.jsp");
//            return;
//        }

        String search = request.getParameter("search");
        List<User> userList = new ArrayList<>();

        try {
            // Kết nối cơ sở dữ liệu
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD)) {
                String sql;
                PreparedStatement stmt;

                if (search != null && !search.trim().isEmpty()) {
                    // Tìm kiếm theo email hoặc tên
                    sql = "SELECT user_id, email, name, phone, dob, gender, role, created_at, updated_at " +
                          "FROM Users WHERE email LIKE ? OR name LIKE ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, "%" + search + "%");
                    stmt.setString(2, "%" + search + "%");
                } else {
                    // Lấy toàn bộ danh sách người dùng
                    sql = "SELECT user_id, email, name, phone, dob, gender, role, created_at, updated_at FROM Users";
                    stmt = conn.prepareStatement(sql);
                }

                ResultSet rs = stmt.executeQuery();
                while (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setEmail(rs.getString("email"));
                    user.setName(rs.getString("name"));
                    user.setPhone(rs.getString("phone"));
                    user.setDob(rs.getDate("dob"));
                    user.setGender(rs.getBoolean("gender"));
                    user.setRole(rs.getInt("role"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    user.setUpdatedAt(rs.getTimestamp("updated_at"));
                    userList.add(user);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi lấy dữ liệu người dùng: " + e.getMessage());
        }

        // Chuyển danh sách người dùng sang JSP
        request.setAttribute("userList", userList);
        request.getRequestDispatcher("/WEB-INF/views/admin/accountList.jsp").forward(request, response);
    }

    // Phương thức kiểm tra quyền admin (giả sử lưu thông tin người dùng trong session)
    private boolean isAdmin(HttpServletRequest request) {
        // Giả sử thông tin người dùng được lưu trong session với key "user"
        User loggedInUser = (User) request.getSession().getAttribute("user");
        return loggedInUser != null && loggedInUser.getRole() == 0; // 0 là role admin
    }

    // Lớp User để ánh xạ dữ liệu từ cơ sở dữ liệu
    public static class User {
        private int userId;
        private String email;
        private String name;
        private String phone;
        private java.sql.Date dob;
        private boolean gender;
        private int role;
        private java.sql.Timestamp createdAt;
        private java.sql.Timestamp updatedAt;

        // Getters và Setters
        public int getUserId() { return userId; }
        public void setUserId(int userId) { this.userId = userId; }
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        public String getName() { return name; }
        public void setName(String name) { this.name = name; }
        public String getPhone() { return phone; }
        public void setPhone(String phone) { this.phone = phone; }
        public java.sql.Date getDob() { return dob; }
        public void setDob(java.sql.Date dob) { this.dob = dob; }
        public boolean getGender() { return gender; }
        public void setGender(boolean gender) { this.gender = gender; }
        public int getRole() { return role; }
        public void setRole(int role) { this.role = role; }
        public java.sql.Timestamp getCreatedAt() { return createdAt; }
        public void setCreatedAt(java.sql.Timestamp createdAt) { this.createdAt = createdAt; }
        public java.sql.Timestamp getUpdatedAt() { return updatedAt; }
        public void setUpdatedAt(java.sql.Timestamp updatedAt) { this.updatedAt = updatedAt; }
    }
}