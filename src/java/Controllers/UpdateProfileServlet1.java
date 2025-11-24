package Controllers;

import Dao.UserDAO;
import Models.User;
import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet to handle user profile update
 * @author Acer
 */
@WebServlet(name = "UpdateProfileServlet", urlPatterns = {"/updateProfile"})
public class UpdateProfileServlet1 extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO(); // Initialize UserDAO
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        // Forward to update profile page with current user info
        User user = (User) session.getAttribute("user");
        request.setAttribute("user", user);
        request.getRequestDispatcher("/Views/updateProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String email = currentUser.getEmail(); // Email not updatable, use from session

        // Get form parameters
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String dobStr = request.getParameter("dob");
        String genderStr = request.getParameter("gender");

        // Map to store validation errors
        Map<String, String> errors = new HashMap<>();

        // Validate fields
        if (password != null && !password.trim().isEmpty()) {
            if (password.length() < 6) {
                errors.put("password", "Mật khẩu phải có ít nhất 6 ký tự!");
            }
            if (confirmPassword == null || !confirmPassword.equals(password)) {
                errors.put("confirmPassword", "Xác nhận mật khẩu không khớp!");
            }
        } else if (confirmPassword != null && !confirmPassword.trim().isEmpty()) {
            errors.put("password", "Vui lòng nhập mật khẩu nếu muốn thay đổi!");
        }

        if (name == null || name.trim().isEmpty()) {
            errors.put("name", "Họ và tên không được để trống!");
        } else if (!name.matches("^[\\p{L} ]+$")) {
            errors.put("name", "Họ và tên chỉ được chứa chữ cái và khoảng trắng!");
        }

        if (phone != null && !phone.trim().isEmpty() && !phone.matches("^0[0-9]{9,10}$")) {
            errors.put("phone", "Số điện thoại phải bắt đầu bằng 0 và có 10-11 số!");
        }

        if (dobStr != null && !dobStr.trim().isEmpty()) {
            try {
                Date dob = Date.valueOf(dobStr); // Sử dụng java.sql.Date.valueOf
                // Nếu không lỗi, dob đã được tạo thành công
            } catch (IllegalArgumentException e) {
                errors.put("dob", "Ngày sinh không hợp lệ! (Định dạng: yyyy-MM-dd)");
            }
        }

        if (genderStr == null) {
            errors.put("gender", "Vui lòng chọn giới tính!");
        }

        // If there are validation errors, return to form with errors
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("name", name);
            request.setAttribute("phone", phone);
            request.setAttribute("dob", dobStr);
            request.setAttribute("gender", genderStr);
            request.setAttribute("user", currentUser);
            request.getRequestDispatcher("/Views/updateProfile.jsp").forward(request, response);
            return;
        }

        try {
            // Parse date and gender
            java.sql.Date dob = (dobStr != null && !dobStr.trim().isEmpty()) ? Date.valueOf(dobStr) : null;
            boolean gender = (genderStr != null && genderStr.equals("1")) ? true : false;

            // Password: If not provided, keep current; else update
            String passwordHash = (password != null && !password.trim().isEmpty()) ? password : currentUser.getPasswordHash();

            // Update user profile (role not updated)
            boolean success = userDAO.updateProfile(email, passwordHash, name, phone, dob, gender);
            if (success) {
                // Update session with new info
                User updatedUser = userDAO.getUserByEmail(email);
                session.setAttribute("user", updatedUser);
                request.setAttribute("message", "Cập nhật hồ sơ thành công! Bạn sẽ được chuyển về trang chủ sau 3 giây.");
                request.getRequestDispatcher("/Views/updateSuccess.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Cập nhật hồ sơ thất bại. Vui lòng thử lại!");
                request.setAttribute("user", currentUser);
                request.getRequestDispatcher("/Views/updateProfile.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            request.setAttribute("user", currentUser);
            request.getRequestDispatcher("/Views/updateProfile.jsp").forward(request, response);
        }
    }
}