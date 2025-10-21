package Filters;

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

        Integer role = (session != null) ? (Integer) session.getAttribute("role") : null;
        String path = request.getRequestURI();

        // 🚫 Bỏ qua kiểm tra cho các trang/public resource
        if (path.endsWith("/login")
                || path.contains("/Views/login.jsp")
                || path.contains("/register")
                || path.contains("/unauthorized")
                || path.contains("/css/")
                || path.contains("/js/")
                || path.contains("/images/")
                || path.contains("/fonts/")
                || path.contains("selectionShowtime")
                || path.contains("confirmShowtime")) {
            chain.doFilter(req, res);
            return;
        }

        // ⛔ Nếu chưa đăng nhập
        if (session == null || role == null) {
            System.out.println("⛔ Chưa đăng nhập: " + path);
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (path.contains("listAuditorium")
                || path.contains("addAuditorium")
                || path.contains("updateAuditorium")
                || path.contains("deleteAuditorium")) {

            if (role != 1) {
                request.getRequestDispatcher("Views/Unauthorized.jsp").forward(request, response);
                return;
            }
            System.out.println(role);

        }

        // ✅ Cho phép đi tiếp nếu hợp lệ
        chain.doFilter(req, res);
    }
}
