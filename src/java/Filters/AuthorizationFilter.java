package Filters;

import Models.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AuthorizationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        String path = request.getRequestURI();
        System.out.println("🔍 Path detected: " + path);


        // 🟢 Các đường dẫn public (không cần đăng nhập)
        if (isPublicPath(path)) {
            System.out.println("✅ Public path allowed: " + path);

            chain.doFilter(req, res);
            return;
        }

        // 🔒 Kiểm tra đăng nhập
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        Integer role = (session != null) ? (Integer) session.getAttribute("role") : null;

        if (user == null || role == null) {
            System.out.println("⛔ Chưa đăng nhập: " + path);
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 🔐 Kiểm tra phân quyền (chỉ ví dụ)
        if (path.contains("addAuditorium") || path.contains("updateAuditorium") || path.contains("deleteAuditorium") || path.contains("listAuditorium")) {
            if (role != 1) { // 1 = admin
                request.getRequestDispatcher("Views/Unauthorized.jsp").forward(request, response);
                return;
            }
        }

        // ✅ Cho phép đi tiếp nếu hợp lệ
        chain.doFilter(req, res);
    }

    // 🧩 Danh sách đường dẫn công khai
    private boolean isPublicPath(String path) {
        return path.endsWith("/login")
                || path.contains("/register")
                || path.contains("/unauthorized")
                || path.contains("/home")
                || path.contains("/selectionShowtime")
                || path.contains("/confirmShowtime")
                || path.contains("/css/")
                || path.contains("/js/")
                || path.contains("/images/")
                || path.contains("/fonts/");
    }
}
