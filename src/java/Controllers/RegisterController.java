package Controllers;

import DAO.UserDAO;
import Models.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;


public class RegisterController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String dob = request.getParameter("dob");
        boolean gender = "Male".equals(request.getParameter("gender"));

        UserDAO dao = new UserDAO();
        Users user = dao.register(name, email, password, phone, dob, gender);

        if (user != null) {
            // tạo session lưu role mặc định = 2
            HttpSession session = request.getSession();
            session.setAttribute("role", 2);  // vì register luôn default role = 2

            request.setAttribute("regSuccess", "Register successful! Please login.");
            request.setAttribute("activeTab", "login"); // mở tab login
        } else {
            request.setAttribute("regError", "Register failed!");
            request.setAttribute("activeTab", "register");
        }
        request.getRequestDispatcher("/Views/Auth.jsp").forward(request, response);
    }
}
