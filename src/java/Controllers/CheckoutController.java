package Controllers;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.http.*;
import jakarta.servlet.*;

import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;

public class CheckoutController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String method = req.getParameter("method"); // cod | momo | vnpay

        if ("cod".equals(method)) {
            resp.sendRedirect(req.getContextPath() + "/Views/payment.jsp?page=success");
        }
        else if ("momo".equals(method)) {
            processMomo(req, resp);
        }
        else if ("vnpay".equals(method)) {
            processVNPay(req, resp);
        }
    }

    private void processMomo(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String orderId    = req.getParameter("orderId");
            String orderInfo  = req.getParameter("orderInfo");
            String amount     = req.getParameter("amount");
            String redirectUrl= req.getParameter("redirectUrl");
            String ipnUrl     = req.getParameter("ipnUrl");
            String extraData  = req.getParameter("extraData");

            String requestId  = String.valueOf(System.currentTimeMillis());
            String requestType= "payWithATM";

//            // giả sử bạn đã có bookingId sau khi lưu đơn
//int bookingId = 123;  
//
//// lấy connection (tùy project bạn dùng JDBC, DataSource hoặc DBContext)
//Connection conn = DBContext.getConnection();
//BookingService bookingService = new BookingService(conn);
//
//// Tính tổng tiền từ DB
//double amount = bookingService.calculateTotalPrice(bookingId);
//
//// chuyển sang long/int nếu cần
//long amountLong = Math.round(amount);
//
//// Dùng amountLong để đưa vào request gửi MoMo
//String rawHash = "accessKey=" + MomoConfig.accessKey +
//        "&amount=" + amountLong +
//        "&extraData=" + extraData +
//        "&ipnUrl=" + MomoConfig.ipnUrl +
//        "&orderId=" + bookingId +
//        "&orderInfo=" + "Thanh toan ve phim #" + bookingId +
//        "&partnerCode=" + MomoConfig.partnerCode +
//        "&redirectUrl=" + MomoConfig.redirectUrl +
//        "&requestId=" + requestId +
//        "&requestType=" + requestType;

            
            
            String rawHash = "accessKey=" + MomoConfig.accessKey +
                    "&amount=" + amount +
                    "&extraData=" + extraData +
                    "&ipnUrl=" + ipnUrl +
                    "&orderId=" + orderId +
                    "&orderInfo=" + orderInfo +
                    "&partnerCode=" + MomoConfig.partnerCode +
                    "&redirectUrl=" + redirectUrl +
                    "&requestId=" + requestId +
                    "&requestType=" + requestType;

            String signature = Controllers.Util.HmacUtil.hmacSha256(rawHash, MomoConfig.secretKey);

            JsonObject body = new JsonObject();
            body.addProperty("partnerCode", MomoConfig.partnerCode);
            body.addProperty("partnerName", "Test");
            body.addProperty("storeId", "MomoTestStore");
            body.addProperty("requestId", requestId);
            body.addProperty("amount", amount);
            body.addProperty("orderId", orderId);
            body.addProperty("orderInfo", orderInfo);
            body.addProperty("redirectUrl", redirectUrl);
            body.addProperty("ipnUrl", ipnUrl);
            body.addProperty("lang", "vi");
            body.addProperty("extraData", extraData);
            body.addProperty("requestType", requestType);
            body.addProperty("signature", signature);

            String result = HttpUtil.execPostRequest(MomoConfig.endpoint, new Gson().toJson(body));
            JsonObject json = new Gson().fromJson(result, JsonObject.class);

            if (json.has("payUrl")) {
                resp.sendRedirect(json.get("payUrl").getAsString());
            } else {
                resp.sendRedirect(req.getContextPath() + "/Views/payment.jsp?page=fail&msg=MoMo Error");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/Views/payment.jsp?page=fail&msg=" +
                    URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    private void processVNPay(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String vnp_Version = "2.1.0";
            String vnp_Command = "pay";
            String vnp_OrderInfo = req.getParameter("orderInfo");
            String orderType = "billpayment";
            String vnp_TxnRef = VNPayConfig.getRandomNumber(8);
            String vnp_IpAddr = VNPayConfig.getIpAddress(req);
            String vnp_TmnCode = VNPayConfig.vnp_TmnCode;

            int amount = Integer.parseInt(req.getParameter("amount")) * 100;
            Map<String,String> vnp_Params = new HashMap<>();
            vnp_Params.put("vnp_Version", vnp_Version);
            vnp_Params.put("vnp_Command", vnp_Command);
            vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
            vnp_Params.put("vnp_Amount", String.valueOf(amount));
            vnp_Params.put("vnp_CurrCode", "VND");
            vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
            vnp_Params.put("vnp_OrderInfo", vnp_OrderInfo);
            vnp_Params.put("vnp_OrderType", orderType);
            vnp_Params.put("vnp_Locale", "vn");
            vnp_Params.put("vnp_ReturnUrl", VNPayConfig.vnp_Returnurl);
            vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

            Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            String vnp_CreateDate = formatter.format(cld.getTime());
            cld.add(Calendar.MINUTE, 15);
            String vnp_ExpireDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
            vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

            List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
            Collections.sort(fieldNames);
            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();
            for (int i = 0; i < fieldNames.size(); i++) {
                String fieldName = fieldNames.get(i);
                String fieldValue = vnp_Params.get(fieldName);
                if (fieldValue != null && !fieldValue.isEmpty()) {
                    hashData.append(fieldName).append('=')
                            .append(URLEncoder.encode(fieldValue, "US-ASCII"));
                    query.append(URLEncoder.encode(fieldName, "US-ASCII")).append('=')
                            .append(URLEncoder.encode(fieldValue, "US-ASCII"));
                    if (i < fieldNames.size() - 1) {
                        hashData.append('&');
                        query.append('&');
                    }
                }
            }

            String vnp_SecureHash = VNPayConfig.hmacSHA512(VNPayConfig.vnp_HashSecret, hashData.toString());
            String paymentUrl = VNPayConfig.vnp_PayUrl + "?" + query + "&vnp_SecureHash=" + vnp_SecureHash;

            resp.sendRedirect(paymentUrl);
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/Views/payment.jsp?page=fail&msg=" +
                    URLEncoder.encode("VNPay Error: "+e.getMessage(), "UTF-8"));
        }
    }
}
