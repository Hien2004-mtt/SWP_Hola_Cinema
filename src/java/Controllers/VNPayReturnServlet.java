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

public class VNPayReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ✅ Thông tin từ VNPay callback
        String vnp_Amount = req.getParameter("vnp_Amount");
        String vnp_ResponseCode = req.getParameter("vnp_ResponseCode");
        String vnp_TxnRef = req.getParameter("vnp_TxnRef"); // bookingId thật (nếu gửi đúng từ Checkout)
        String vnp_TransactionNo = req.getParameter("vnp_TransactionNo");
        String vnp_OrderInfo = req.getParameter("vnp_OrderInfo");

        try {
            // ✅ Kiểm tra kết quả thanh toán
            if (!"00".equals(vnp_ResponseCode)) {
                throw new Exception("Thanh toán thất bại (Mã phản hồi: " + vnp_ResponseCode + ")");
            }

            // ✅ Lấy bookingId thật
            int bookingId = Integer.parseInt(vnp_TxnRef);

            // ✅ Lấy thông tin vé từ DB
            BookingDAO bookingDAO = new BookingDAO();
            Map<String, Object> info = bookingDAO.getBookingInfo(bookingId);

            // ✅ Cập nhật trạng thái sang "confirmed"
            bookingDAO.updateBookingStatus(bookingId, "confirmed");

            // ✅ Định dạng dữ liệu an toàn (tránh null)
            String customerName = (String) info.getOrDefault("customer_name", "Khách hàng");
            String customerEmail = (String) info.getOrDefault("customer_email", "");
            String movieTitle = (String) info.getOrDefault("movie_title", "Không rõ");
            String seatCode = (String) info.getOrDefault("seat_code", "N/A");
            String auditorium = (String) info.getOrDefault("auditorium_name", "N/A");
            String startTime = info.get("start_time") != null
                    ? new SimpleDateFormat("HH:mm dd/MM/yyyy").format(info.get("start_time"))
                    : "N/A";
            double total = Double.parseDouble(vnp_Amount) / 100; // VNPay trả *100
            String hashCode = bookingDAO.hashBookingId(bookingId);
            // ✅ Sinh nội dung QR code
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
                    "Mã giao dịch VNPay: " + vnp_TransactionNo + "\n" +
                    "Thời gian thanh toán: " + sdf.format(new Date());

            // ✅ Tạo file QR code
            String qrFolder = getServletContext().getRealPath("/uploads/qrcode/");
            File dir = new File(qrFolder);
            if (!dir.exists()) dir.mkdirs();

            String qrFileName = "qr_vnpay_" + bookingId + "_" + System.currentTimeMillis() + ".png";
            Path qrPath = Paths.get(qrFolder, qrFileName);

            Map<EncodeHintType, Object> hints = new HashMap<>();
            hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
            BitMatrix matrix = new QRCodeWriter().encode(qrText, BarcodeFormat.QR_CODE, 400, 400, hints);
            MatrixToImageWriter.writeToPath(matrix, "PNG", qrPath);

            System.out.println("✅ QR code saved: " + qrPath);

            //  Lưu vào bảng Payment
            Payment payment = new Payment();
            payment.setBookingId(bookingId);
            payment.setAmount(total);
            payment.setMethod("VNPay");
            payment.setTransactionRef(vnp_TransactionNo);
            payment.setStatus("success");
            payment.setPaidAt(new Date());
            payment.setQrCodeUrl("uploads/qrcode/" + qrFileName);
            new PaymentDAO().save(payment);

            // ✅ Gửi email có QR code (nếu có email)
            if (customerEmail != null && !customerEmail.isEmpty()) {
                String subject = " Vé xem phim HolaCinema #" + bookingId;
                String body =
                        "Xin chào " + customerName + ",\n\n" +
                        "Cảm ơn bạn đã thanh toán thành công vé xem phim tại HolaCinema!\n\n" +
                        "Thông tin vé của bạn:\n" +
                        "Phim: " + movieTitle + "\n" +
                        "Ghế: " + seatCode + "\n" +
                        "Phòng: " + auditorium + "\n" +
                        "Suất chiếu: " + startTime + "\n" +
                        "Tổng tiền: " + String.format("%,.0f VND", total) + "\n\n" +
                        "Mã QR đính kèm trong email này dùng để nhận vé tại quầy.\n\n" +
                        "Trân trọng,\nHolaCinema Center";

                EmailUtil.sendEmailWithQRCode(customerEmail, subject, body, qrPath.toString());
                System.out.println(" Email sent to " + customerEmail);
            }

            // ✅ Điều hướng sang trang success
            resp.sendRedirect(req.getContextPath() + "/Views/payment_success.jsp?file=" + qrFileName);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath()
                    + "/Views/payment.jsp?page=fail&msg=" +
                    URLEncoder.encode("Lỗi xử lý VNPay Return: " + e.getMessage(), "UTF-8"));
        }
    }
}
