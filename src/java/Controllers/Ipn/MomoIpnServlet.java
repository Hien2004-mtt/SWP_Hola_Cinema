package Controllers.Ipn;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import com.google.gson.JsonObject;

public class MomoIpnServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String orderId = req.getParameter("orderId");
        String resultCode = req.getParameter("resultCode");
        String message = req.getParameter("message");

        JsonObject response = new JsonObject();
        if ("0".equals(resultCode)) {
            // TODO: update booking status = confirmed
            response.addProperty("status", "success");
            response.addProperty("message", "Thanh toán MoMo thành công cho đơn " + orderId);
        } else {
            // TODO: update booking status = failed
            response.addProperty("status", "fail");
            response.addProperty("message", "Thanh toán MoMo thất bại: " + message);
        }

        resp.setContentType("application/json");
        resp.getWriter().write(response.toString());
    }
}
