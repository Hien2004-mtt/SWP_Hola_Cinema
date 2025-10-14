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

        DAO dao = new DAO();
        // Kiểm tra trùng email
        if (dao.findByEmail(email) != null) {
            request.setAttribute("error", "Email already exists!");
            request.getRequestDispatcher("/Views/register.jsp").forward(request, response);
            return;
        }
        // Kiểm tra trùng số điện thoại
        if (dao.findByPhone(phone) != null) {
            request.setAttribute("error", "Phone number already exists!");
            request.getRequestDispatcher("/Views/register.jsp").forward(request, response);
            return;
        }

        // Tạo đối tượng User
        User u = new User();
    u.setEmail(email);
    u.setPasswordHash(hashedPassword);
    u.setName(name);
    u.setPhone(phone);
    u.setDob(LocalDate.parse(dobStr));
    u.setRole(2); // mặc định customer
    u.setGender("1".equals(genderStr));
    u.setStatus(true); // mặc định tài khoản hoạt động

        boolean success = false;
        Exception errorEx = null;
        try {
            success = dao.register(u);
        } catch (Exception ex) {
            errorEx = ex;
        }

        if (success) {
            // Đăng ký thành công → chuyển sang login
            response.sendRedirect("login.jsp");
        } else {
            // Thất bại → quay lại form + thông báo lỗi
            String errorMsg = "Register failed! Please check your input or contact admin.";
            if (errorEx != null) {
                errorMsg += "<br>" + errorEx.getMessage();
            }
            request.setAttribute("error", errorMsg);
            request.getRequestDispatcher("/Views/register.jsp").forward(request, response);
        }
    }
}