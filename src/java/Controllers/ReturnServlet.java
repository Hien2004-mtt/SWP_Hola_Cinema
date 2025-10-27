package Controllers;

import DAL.BookingDAO;
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
import java.net.URLEncoder;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.*;

public class ReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String resultCode = req.getParameter("resultCode"); // MoMo: 0 = success
        String orderId = req.getParameter("orderId");
        String amount = req.getParameter("amount");
        String transId = req.getParameter("transId");

        try {
            if ("0".equals(resultCode)) { // ✅ Thanh toán thành công
                int bookingId = Integer.parseInt(orderId);

                //  Lấy thông tin booking từ DB
                BookingDAO bookingDAO = new BookingDAO();
                Map<String, Object> info = bookingDAO.getBookingInfo(bookingId);

                //  Chuẩn bị nội dung QR
                SimpleDateFormat sdf = new SimpleDateFormat("HH:mm dd/MM/yyyy");
                String qrText =
                        "?️ Vé xem phim HolaCinema\n" +
                        "-----------------------------\n" +
                        "Mã đặt vé: " + bookingId + "\n" +
                        "Khách hàng: " + info.get("customer_name") + "\n" +
                        "Phim: " + info.get("movie_title") + "\n" +
                        "Ghế: " + info.get("seat_code") + "\n" +
                        "Phòng: " + info.get("auditorium_name") + "\n" +
                        "Suất chiếu: " + sdf.format(info.get("start_time")) + "\n" +
                        "Giá vé: " + String.format("%,.0f VND", info.get("base_price")) + "\n" +
                        "Thời gian thanh toán: " + sdf.format(new Date()) + "\n" +
                        "Mã giao dịch: " + transId;

                // ✅ Tạo thư mục uploads/qrcode nếu chưa có
                String qrFolder = getServletContext().getRealPath("/uploads/qrcode/");
                File dir = new File(qrFolder);
                if (!dir.exists()) {
                    dir.mkdirs();
                }

                // ✅ Tạo file PNG
                String qrFileName = "qr_" + bookingId + "_" + System.currentTimeMillis() + ".png";
                Path qrPath = Paths.get(qrFolder, qrFileName);

                Map<EncodeHintType, Object> hints = new HashMap<>();
                hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");

                QRCodeWriter writer = new QRCodeWriter();
                BitMatrix matrix = writer.encode(qrText, BarcodeFormat.QR_CODE, 400, 400, hints);
                MatrixToImageWriter.writeToPath(matrix, "PNG", qrPath);

                System.out.println("✅ QR file saved at: " + qrPath);

                // ✅ Lưu thông tin thanh toán vào DB
                Payment payment = new Payment();
                payment.setBookingId(bookingId);
                payment.setAmount(Double.parseDouble(amount));
                payment.setMethod("MoMo");
                payment.setTransactionRef(transId);
                payment.setStatus("success");
                payment.setPaidAt(new Date());
                payment.setQrCodeUrl("uploads/qrcode/" + qrFileName);

                new PaymentDAO().save(payment);

                // ✅ Hiển thị QR cho người dùng (dùng QRCodeServlet)
                resp.sendRedirect(req.getContextPath() + "/Views/payment_success.jsp?file=" + qrFileName);

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
