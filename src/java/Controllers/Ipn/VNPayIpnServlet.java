package Controllers.Ipn;

import Controllers.VNPayConfig;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.*;

public class VNPayIpnServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = req.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = req.getParameter(fieldName);
            if (fieldValue != null && fieldValue.length() > 0) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = fields.remove("vnp_SecureHash");
        List<String> fieldNames = new ArrayList<>(fields.keySet());
        Collections.sort(fieldNames);

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < fieldNames.size(); i++) {
            String name = fieldNames.get(i);
            String value = fields.get(name);
            sb.append(name).append("=").append(value);
            if (i < fieldNames.size() - 1) sb.append("&");
        }

        try {
            String signValue = VNPayConfig.hmacSHA512(VNPayConfig.vnp_HashSecret, sb.toString());
            String orderId = fields.get("vnp_TxnRef");
            String responseCode = fields.get("vnp_ResponseCode");

            if (signValue.equals(vnp_SecureHash) && "00".equals(responseCode)) {
                // TODO: update booking status = confirmed
                resp.getWriter().print("IPN success: Thanh toán VNPay thành công cho đơn " + orderId);
            } else {
                // TODO: update booking status = failed
                resp.getWriter().print("IPN fail: Thanh toán VNPay thất bại cho đơn " + orderId);
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/Views/payment.jsp?page=fail&msg=" +
                    URLEncoder.encode("Lỗi IPN VNPay: " + e.getMessage(), "UTF-8"));
        }
    }
}
