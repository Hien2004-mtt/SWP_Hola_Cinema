package Controllers;

import DAL.UserDAO;
import Models.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nếu đã đăng nhập → redirect theo role
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user != null) {
            switch (user.getRole()) {
                case 0: response.sendRedirect("dashboard"); return;
                case 1: response.sendRedirect("dashboard"); return;
                case 2: response.sendRedirect("home"); return;
                default: response.sendRedirect("home"); return;
            }
        }

        // Nếu chưa đăng nhập → hiển thị form login
        request.getRequestDispatcher("Views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Kiểm tra đầu vào
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập email và mật khẩu!");
            request.getRequestDispatcher("Views/login.jsp").forward(request, response);
            return;
        }

        try {
            User user = userDAO.login(email, password);
            if (user != null) {
                // Xóa session cũ nếu có
                HttpSession oldSession = request.getSession(false);
                if (oldSession != null) oldSession.invalidate();

                // Tạo session mới
                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);

                // Redirect theo role
                switch (user.getRole()) {
                    case 0: response.sendRedirect("dashboard"); break;
                    case 1: response.sendRedirect("staff-home"); break;
                    case 2: response.sendRedirect("home"); break;
                    default: response.sendRedirect("home"); break;
                }
            } else {
                request.setAttribute("error", "Email hoặc mật khẩu không đúng!");
                request.getRequestDispatcher("Views/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Đã xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("Views/login.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "LoginServlet handles user authentication and redirects based on role.";
    }
}
