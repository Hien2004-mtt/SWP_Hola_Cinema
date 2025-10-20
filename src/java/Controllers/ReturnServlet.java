package Controllers;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import DAO.PaymentDAO;
import Models.Payment;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.*;
import java.net.URLEncoder;
import java.util.*;

public class ReturnServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String resultCode = req.getParameter("resultCode"); // 0 = success
        String orderId = req.getParameter("orderId");
        String amount = req.getParameter("amount");
        String transId = req.getParameter("transId");

        System.out.println("===[MoMo RETURN]====");
        System.out.println("resultCode=" + resultCode + ", orderId=" + orderId + ", amount=" + amount + ", transId=" + transId);

        try {
            if ("0".equals(resultCode)) {
                //  Tạo nội dung QR
                String qrText = "BOOKING#" + orderId
                        + "|AMOUNT=" + amount
                        + "|TRANS=" + transId
                        + "|TS=" + System.currentTimeMillis();

                //  Tạo thư mục uploads/qrcode
                String qrFolder = getServletContext().getRealPath("/uploads/qrcode/");
                File dir = new File(qrFolder);
                if (!dir.exists()) {
                    System.out.println("Creating directory: " + qrFolder);
                    dir.mkdirs();
                }

                //  Ghi file QR
                String qrFileName = "qr_" + orderId + ".png";
                Path qrPath = Paths.get(qrFolder, qrFileName);
                Map<EncodeHintType, Object> hints = new HashMap<>();
                hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");

                QRCodeWriter writer = new QRCodeWriter();
                BitMatrix matrix = writer.encode(qrText, BarcodeFormat.QR_CODE, 300, 300, hints);
                MatrixToImageWriter.writeToPath(matrix, "PNG", qrPath);
                System.out.println("QR generated at: " + qrPath);

                //  Lưu DB
                Payment payment = new Payment();
                payment.setBookingId(Integer.parseInt(orderId));

                payment.setAmount(Double.parseDouble(amount));
                payment.setMethod("MoMo"); // 1 = MoMo
                payment.setTransactionRef(transId);
                payment.setStatus("Success");
                payment.setPaidAt(new Date());
                payment.setQrCodeUrl("uploads/qrcode/" + qrFileName);

                new PaymentDAO().save(payment);
                System.out.println("Payment saved to DB!");

                //  Redirect sang trang hiển thị QR
                resp.sendRedirect(req.getContextPath() + "/qrcode?text=" + URLEncoder.encode(qrText, "UTF-8") + "&size=300");

            } else {
                req.setAttribute("msg", "Thanh toán thất bại (resultCode=" + resultCode + ")");
                req.getRequestDispatcher("/Views/payment.jsp?page=fail").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath()
                    + "/Views/payment.jsp?page=fail&msg=" +
                    URLEncoder.encode("Lỗi xử lý return: " + e.getMessage(), "UTF-8"));
        }
    }
}
