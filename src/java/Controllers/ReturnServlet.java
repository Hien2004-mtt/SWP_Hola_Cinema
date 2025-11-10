package Controllers;

import Controllers.Util.EmailUtil;
import DAL.BookingDAO;
import DAO.PaymentDAO;
import Models.Payment;
import com.google.zxing.*;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.file.*;
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
        String extraData = req.getParameter("extraData"); // chính là bookingId

        try {
            if (!"0".equals(resultCode)) {
                throw new Exception("Thanh toán thất bại (resultCode=" + resultCode + ")");
            }

            // Lấy bookingId thực từ extraData
            int bookingId = Integer.parseInt(extraData);

            BookingDAO bookingDAO = new BookingDAO();
            Map<String, Object> info = bookingDAO.getBookingInfo(bookingId);

            // Cập nhật trạng thái vé
            bookingDAO.updateBookingStatus(bookingId, "confirmed");

            // Lấy dữ liệu an toàn, tránh NullPointerException
            String customerName = (String) info.getOrDefault("customer_name", "Khách hàng");
            String customerEmail = (String) info.getOrDefault("customer_email", "");
            String movieTitle = (String) info.getOrDefault("movie_title", "Không rõ");
            String seatCode = (String) info.getOrDefault("seat_code", "N/A");
            String auditorium = (String) info.getOrDefault("auditorium_name", "N/A");
            String startTime = info.get("start_time") != null
                    ? new SimpleDateFormat("HH:mm dd/MM/yyyy").format(info.get("start_time"))
                    : "N/A";
            double total = info.get("total_price") != null
                    ? (double) info.get("total_price")
                    : 0.0;
            String hashCode = bookingDAO.hashBookingId(bookingId);
            // ✅ Chuẩn bị nội dung QR
            SimpleDateFormat sdf = new SimpleDateFormat("HH:mm dd/MM/yyyy");
            String qrText =
                    " Vé xem phim HolaCinema\n" +
                    "-----------------------------\n" +
                    "Mã đặt vé: " + hashCode + "\n" +
                    "Khách hàng: " + customerName + "\n" +
                    "Phim: " + movieTitle + "\n" +
                    "Ghế: " + seatCode + "\n" +
                    "Phòng: " + auditorium + "\n" +
                    "Suất chiếu: " + startTime + "\n" +
                    "Tổng tiền: " + String.format("%,.0f VND", total) + "\n" +
                    "Mã giao dịch MoMo: " + transId + "\n" +
                    "Thời gian thanh toán: " + sdf.format(new Date());

            // ✅ Sinh QR code
            String qrFolder = getServletContext().getRealPath("/uploads/qrcode/");
            File dir = new File(qrFolder);
            if (!dir.exists()) dir.mkdirs();

            String qrFileName = "qr_" + bookingId + "_" + System.currentTimeMillis() + ".png";
            Path qrPath = Paths.get(qrFolder, qrFileName);

            Map<EncodeHintType, Object> hints = new HashMap<>();
            hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");

            QRCodeWriter writer = new QRCodeWriter();
            BitMatrix matrix = writer.encode(qrText, BarcodeFormat.QR_CODE, 400, 400, hints);
            MatrixToImageWriter.writeToPath(matrix, "PNG", qrPath);

            System.out.println(" QR generated: " + qrPath);

            // Lưu vào bảng payment
            Payment payment = new Payment();
            payment.setBookingId(bookingId);
            payment.setAmount(Double.parseDouble(amount));
            payment.setMethod("MoMo");
            payment.setTransactionRef(transId);
            payment.setStatus("success");
            payment.setPaidAt(new Date());
            payment.setQrCodeUrl("uploads/qrcode/" + qrFileName);
            new PaymentDAO().save(payment);

            // ✅ Gửi email (nếu có)
            if (customerEmail != null && !customerEmail.isEmpty()) {
                String subject = " Vé xem phim HolaCinema #" + bookingId;
                String body =
                        "Xin chào " + customerName + ",\n\n" +
                        "Cảm ơn bạn đã thanh toán thành công vé xem phim tại HolaCinema!\n\n" +
                        "Thông tin vé của bạn:\n" +
                        qrText + "\n\n" +
                        "Mã QR đính kèm có thể dùng để nhận vé tại quầy.\n\n" +
                        "Trân trọng,\nHolaCinema Center";
                EmailUtil.sendEmailWithQRCode(customerEmail, subject, body, qrPath.toString());
                System.out.println(" Email sent to " + customerEmail);
            }

            // ✅ Điều hướng sang trang success hiển thị QR
            resp.sendRedirect(req.getContextPath() + "/Views/payment_success.jsp?file=" + qrFileName);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath()
                    + "/Views/payment.jsp?page=fail&msg=" +
                    URLEncoder.encode("Lỗi xử lý return: " + e.getMessage(), "UTF-8"));
        }
    }
}
