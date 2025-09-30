package Controllers;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import com.google.gson.JsonObject;

public class ReturnServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String resultCode = req.getParameter("resultCode");
        String orderId = req.getParameter("orderId");
        String message = req.getParameter("message");

        if ("0".equals(resultCode)) {
            // Thanh toán thành công
            // TODO: update booking status trong DB
            req.setAttribute("msg", "Thanh toán MoMo thành công cho đơn #" + orderId);
            req.getRequestDispatcher("/Views/payment.jsp?page=success").forward(req, resp);
        } else {
            // Thanh toán thất bại
            req.setAttribute("msg", "Thanh toán MoMo thất bại: " + message);
            req.getRequestDispatcher("/Views/payment.jsp?page=fail").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp); // MoMo có thể gọi POST hoặc GET
    }
}
