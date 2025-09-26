package Filter;

import Models.Users;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getRequestURI();

        // Cho phép truy cập login, register, file tĩnh mà không cần session
        if (path.contains("Login") || path.contains("Register") 
                || path.endsWith(".css") || path.endsWith(".js") 
                || path.contains("Auth.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        // Check session
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/Views/Auth.jsp");
            return;
        }

        // Nếu đã login thì cho đi tiếp
        chain.doFilter(request, response);
    }
}
