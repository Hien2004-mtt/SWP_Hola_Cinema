package Controllers;

import Controllers.Services.BookingService;
import Controllers.Services.VoucherService;
import DAL.DBContext;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

public class ApplyVoucherServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String bookingIdParam = req.getParameter("bookingId");
        String code = req.getParameter("voucherCode");

        // 🧱 Validate bookingId
        if (bookingIdParam == null || bookingIdParam.trim().isEmpty()) {
            req.setAttribute("msg", "Thiếu thông tin mã đặt vé (bookingId).");
            req.getRequestDispatcher("/Views/payment.jsp").forward(req, resp);
            return;
        }

        int bookingId;
        try {
            bookingId = Integer.parseInt(bookingIdParam.trim());
        } catch (NumberFormatException e) {
            req.setAttribute("msg", "Mã booking không hợp lệ!");
            req.getRequestDispatcher("/Views/payment.jsp").forward(req, resp);
            return;
        }

        // 🧱 Validate voucherCode
        if (code == null || code.trim().isEmpty()) {
            req.setAttribute("msg", "Vui lòng nhập mã voucher!");
            req.getRequestDispatcher("/Views/payment.jsp").forward(req, resp);
            return;
        }

        try (Connection conn = new DBContext().getConnection()) {
            BookingService bs = new BookingService(conn);
            VoucherService vs = new VoucherService(conn);

            double originalTotal = bs.calculateTotalPrice(bookingId);
            double discountedTotal = vs.applyVoucher(code.trim(), originalTotal);

            req.setAttribute("bookingId", bookingId);
            req.setAttribute("originalTotal", originalTotal);
            req.setAttribute("discountedTotal", discountedTotal);
            req.getRequestDispatcher("/Views/payment.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("msg", "Lỗi áp dụng voucher: " + e.getMessage());
            req.getRequestDispatcher("/Views/payment.jsp").forward(req, resp);
        }
    }
}
