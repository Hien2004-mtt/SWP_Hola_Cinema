package Controllers;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;

public class MomoIpnServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Các tham số MoMo gửi về
        String orderId    = req.getParameter("orderId");
        String requestId  = req.getParameter("requestId");
        String amount     = req.getParameter("amount");
        String resultCode = req.getParameter("resultCode"); // 0 = thành công
        String transId    = req.getParameter("transId");

        // Log ra console để debug
        System.out.println("=== MoMo IPN Callback ===");
        System.out.println("orderId: " + orderId);
        System.out.println("requestId: " + requestId);
        System.out.println("amount: " + amount);
        System.out.println("resultCode: " + resultCode);
        System.out.println("transId: " + transId);

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        try {
            if ("0".equals(resultCode)) {
                
                String jsonResp = "{"
                        + "\"partnerCode\":\"" + MomoConfig.partnerCode + "\","
                        + "\"orderId\":\"" + orderId + "\","
                        + "\"requestId\":\"" + requestId + "\","
                        + "\"errorCode\":0,"
                        + "\"message\":\"Success\""
                        + "}";
                out.print(jsonResp);

            } else {
                
                String jsonResp = "{"
                        + "\"partnerCode\":\"" + MomoConfig.partnerCode + "\","
                        + "\"orderId\":\"" + orderId + "\","
                        + "\"requestId\":\"" + requestId + "\","
                        + "\"errorCode\":1,"
                        + "\"message\":\"Payment Failed\""
                        + "}";
                out.print(jsonResp);
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/Views/payment.jsp?page=fail&msg=" +
                    URLEncoder.encode("IPN Error: " + e.getMessage(), "UTF-8"));
        }
    }
}
