package Controllers;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.*;

public class VNPayReturnServlet extends HttpServlet {
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

            if (signValue.equals(vnp_SecureHash) && "00".equals(fields.get("vnp_ResponseCode"))) {
                // Thành công
                String txnRef = fields.get("vnp_TxnRef");
                // TODO: update booking status trong DB
                req.setAttribute("msg", "Thanh toán VNPay thành công cho đơn #" + txnRef);
                req.getRequestDispatcher("/Views/payment.jsp?page=success").forward(req, resp);
            } else {
                req.setAttribute("msg", "Thanh toán VNPay thất bại!");
                req.getRequestDispatcher("/Views/payment.jsp?page=fail").forward(req, resp);
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/Views/payment.jsp?page=fail&msg=" +
                    URLEncoder.encode("Lỗi kiểm tra chữ ký VNPay: " + e.getMessage(), "UTF-8"));
        }
    }
}
