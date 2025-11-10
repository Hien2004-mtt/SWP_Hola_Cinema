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
        if (path.equals(request.getContextPath() + "/") // 👈 cho phép trang gốc (homepage)
                || path.endsWith("/home") // nếu bạn gọi servlet /home
                || path.contains("/Views/home.jsp") // nếu mở trực tiếp file JSP
                || path.endsWith("/login")
                || path.contains("/Views/login.jsp")
                || path.contains("/register")
                || path.contains("/unauthorized")
                || path.contains("/css/")
                || path.contains("/js/")
                || path.contains("/images/")
                || path.contains("/movieDetail")
                || path.contains("/fonts/")
                || path.contains("/forgotPassword")
                || path.contains("/Views/forgotPassword.jsp")
                || path.contains("/EnterOtp.jsp")
                || path.contains("/resetPassword")
                || path.contains("/Views/resetPassword.jsp")
                || path.contains("/changePassword.jsp")
                || path.contains("/ValidateOtp")
                || path.contains("/newPassword")
                || path.contains("/movies")
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

                if (path.contains("accountList")) {
            if (role != 0) {  // Only allow admin (role 0) to access
                request.getRequestDispatcher("Views/Unauthorized.jsp").forward(request, response);
                return;
            }
            System.out.println(role);
        }
        
        if (path.contains("listAuditorium")
                || path.contains("addAuditorium")
                || path.contains("updateAuditorium")
                || path.contains("deleteAuditorium")
                || path.contains("movie_management")
                || path.contains("add_movie")
                || path.contains("edit_movie")) {

            if (role != 1) {
                request.getRequestDispatcher("Views/Unauthorized.jsp").forward(request, response);
                return;
            }
            System.out.println(role);

        }
        if (path.contains("seatList")
                || path.contains("seatAddRowForm")
                || path.contains("seatEdit")
                || path.contains("seatDelete")) {

            if (role != 1) {
                request.getRequestDispatcher("Views/Unauthorized.jsp").forward(request, response);
                return;
            }
            System.out.println(role);

        }
        
        // Quản lý lịch chiếu
        if (path.contains("manageSchedule")
                || path.contains("agenda")) {

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
