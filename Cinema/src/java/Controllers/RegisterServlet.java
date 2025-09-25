/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controllers;

import DAL.DAO;
import Models.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDate;

/**
 *
 * @author dinhh
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Khi người dùng vào link /register => chuyển sang trang form register.jsp
        request.getRequestDispatcher("/Views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy dữ liệu từ form
        String email = request.getParameter("email");
        String rawPassword = request.getParameter("password");
        String hashedPassword = DAO.hashPassword(rawPassword);
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String dobStr = request.getParameter("dob"); // yyyy-MM-dd
        String genderStr = request.getParameter("gender"); // "1"=male, "0"=female

        // Tạo đối tượng User
        User u = new User();
        u.setEmail(email);
        u.setPasswordHash(hashedPassword); // TODO: mã hóa mật khẩu (MD5, BCrypt...)
        u.setName(name);
        u.setPhone(phone);
        u.setDob(LocalDate.parse(dobStr));
        u.setRole(2); // mặc định customer
        u.setGender("1".equals(genderStr));

        // Gọi DAO để lưu
        DAO dao = new DAO();
        boolean success = dao.register(u);

        if (success) {
            // Đăng ký thành công → chuyển sang login
            response.sendRedirect("login.jsp");
        } else {
            // Thất bại → quay lại form + thông báo lỗi
            request.setAttribute("error", "Register failed! Please try again.");
            request.getRequestDispatcher("/Views/register.jsp").forward(request, response);
        }
    }
}