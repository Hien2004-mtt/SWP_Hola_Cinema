package Controllers;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import DAO.PaymentDAO;
import Models.Payment;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.file.*;
import java.util.*;

public class VNPayReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Lấy các tham số trả về từ VNPay
        String vnp_Amount = req.getParameter("vnp_Amount");
        String vnp_ResponseCode = req.getParameter("vnp_ResponseCode");
        String vnp_TxnRef = req.getParameter("vnp_TxnRef");
        String vnp_TransactionNo = req.getParameter("vnp_TransactionNo");
        String vnp_OrderInfo = req.getParameter("vnp_OrderInfo");

        try {
            if ("00".equals(vnp_ResponseCode)) { //  Thanh toán thành công

                // --- Chuẩn bị nội dung QR ---
                String qrText = "VNPAY#" + vnp_TxnRef
                        + "|AMOUNT=" + vnp_Amount
                        + "|TRANS=" + vnp_TransactionNo
                        + "|TS=" + System.currentTimeMillis();

                // --- Tạo thư mục uploads/qrcode ---
                String qrFolder = getServletContext().getRealPath("/uploads/qrcode/");
                File dir = new File(qrFolder);
                if (!dir.exists()) dir.mkdirs();

                // --- Sinh QR code ---
                String qrFileName = "qr_vnpay_" + vnp_TxnRef + ".png";
                Path qrPath = Paths.get(qrFolder, qrFileName);
                Map<EncodeHintType, Object> hints = new HashMap<>();
                hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");

                QRCodeWriter writer = new QRCodeWriter();
                BitMatrix matrix = writer.encode(qrText, BarcodeFormat.QR_CODE, 300, 300, hints);
                MatrixToImageWriter.writeToPath(matrix, "PNG", qrPath);

                // --- Lưu thông tin thanh toán ---
                Payment payment = new Payment();
                payment.setBookingId(Integer.parseInt(vnp_TxnRef)); // giả sử booking_id chính là mã đơn
                payment.setAmount(Double.parseDouble(vnp_Amount) / 100); // VNPay trả *100
                payment.setMethod("VNPay"); // 2 = VNPay
                payment.setTransactionRef(vnp_TransactionNo);
                payment.setStatus("Success");
                payment.setPaidAt(new Date());
                payment.setQrCodeUrl("uploads/qrcode/" + qrFileName);

                new PaymentDAO().save(payment);

                // --- Chuyển hướng hiển thị QR ---
                resp.sendRedirect(req.getContextPath() + "/qrcode?text=" +
                        URLEncoder.encode(qrText, "UTF-8") + "&size=300");

            } else {
                //  Thanh toán thất bại
                req.setAttribute("msg", "Thanh toán VNPay thất bại (Mã: " + vnp_ResponseCode + ")");
                req.getRequestDispatcher("/Views/payment.jsp?page=fail").forward(req, resp);
            }

        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath()
                    + "/Views/payment.jsp?page=fail&msg=" +
                    URLEncoder.encode("Lỗi xử lý VNPay Return: " + e.getMessage(), "UTF-8"));
        }
    }
}
