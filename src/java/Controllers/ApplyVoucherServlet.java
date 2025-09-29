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
        int bookingId = Integer.parseInt(req.getParameter("bookingId"));
        String code = req.getParameter("voucherCode");

        try (Connection conn = new DBContext().getConnection()) {
            BookingService bs = new BookingService(conn);
            VoucherService vs = new VoucherService(conn);

            double originalTotal = bs.calculateTotalPrice(bookingId);
            double discountedTotal = vs.applyVoucher(code, originalTotal);

            req.setAttribute("bookingId", bookingId);
            req.setAttribute("originalTotal", originalTotal);
            req.setAttribute("discountedTotal", discountedTotal);
            req.getRequestDispatcher("/Views/payment.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("msg", "Lỗi áp dụng voucher: " + e.getMessage());
            req.getRequestDispatcher("/Views/payment.jsp").forward(req, resp);
        }
    }
}
