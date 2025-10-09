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
            if (fieldValue != null && !fieldValue.isEmpty()) {
                fields.put(fieldName, fieldValue);
            }
        }

        // Lấy chữ ký VNPay gửi về
        String vnp_SecureHash = fields.remove("vnp_SecureHash");

        // Chuẩn bị để kiểm tra hash
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
                //  Thanh toán thành công
                String txnRef = fields.get("vnp_TxnRef");
                String amount = fields.get("vnp_Amount");

                //  Tạo nội dung QR code
                String qrText = "VNPAY#" + txnRef
                        + "|AMOUNT=" + amount
                        + "|TS=" + System.currentTimeMillis();

                //  Redirect trực tiếp sang servlet QR để hiển thị QR code
                resp.sendRedirect(req.getContextPath()
                        + "/qrcode?text=" + URLEncoder.encode(qrText, "UTF-8")
                        + "&size=300");

            } else {
                //  Thanh toán thất bại
                String msg = "Thanh toán VNPay thất bại! (ResponseCode=" + fields.get("vnp_ResponseCode") + ")";
                resp.sendRedirect(req.getContextPath()
                        + "/Views/payment.jsp?page=fail&msg=" + URLEncoder.encode(msg, "UTF-8"));
            }

        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath()
                    + "/Views/payment.jsp?page=fail&msg=" +
                    URLEncoder.encode("Lỗi kiểm tra chữ ký VNPay: " + e.getMessage(), "UTF-8"));
        }
    }
}
