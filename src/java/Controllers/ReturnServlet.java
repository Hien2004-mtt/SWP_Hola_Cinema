package Controllers;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;

public class ReturnServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String resultCode = req.getParameter("resultCode"); // 0 = success
        String orderId = req.getParameter("orderId");
        String amount = req.getParameter("amount");

        try {
            if ("0".equals(resultCode)) { // Thành công
                // Tạo chuỗi QR code chứa thông tin thanh toán
                String qrText = "BOOKING#" + orderId
                        + "|AMOUNT=" + (amount != null ? amount : "0")
                        + "|TS=" + System.currentTimeMillis();

                // Gửi sang JSP để render QR
                resp.sendRedirect(req.getContextPath() + "/qrcode?text=" + URLEncoder.encode(qrText, "UTF-8") + "&size=300");
            } else {
                // Thanh toán thất bại
                req.setAttribute("msg", "Thanh toán MoMo thất bại! (resultCode=" + resultCode + ")");
                req.getRequestDispatcher("/Views/payment.jsp?page=fail").forward(req, resp);
            }

        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath()
                    + "/Views/payment.jsp?page=fail&msg=" +
                    URLEncoder.encode("Lỗi xử lý return: " + e.getMessage(), "UTF-8"));
        }
    }
}
