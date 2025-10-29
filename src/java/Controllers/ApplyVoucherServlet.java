package Controllers;

import Controllers.Services.BookingService;
import Controllers.Services.VoucherService;
import DAL.BookingDAO;
import DAL.DBContext;
import DAO.VoucherDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

public class ApplyVoucherServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("bookingId") == null) {
            req.setAttribute("msg", "️ Phiên giao dịch đã hết hạn. Vui lòng đặt vé lại!");
            req.getRequestDispatcher("/Views/confirm.jsp").forward(req, resp);
            return;
        }

        int bookingId = (int) session.getAttribute("bookingId");
        Double totalPrice = (Double) session.getAttribute("totalPrice");
        if (totalPrice == null) totalPrice = 0.0;

        String voucherCode = req.getParameter("voucherCode");
        if (voucherCode == null || voucherCode.trim().isEmpty()) {
            req.setAttribute("msg", "️ Vui lòng nhập mã voucher!");
            req.setAttribute("msgType", "error");
            restoreBookingInfo(req, session);
            req.setAttribute("total_price", totalPrice);
            req.setAttribute("discountedTotal", session.getAttribute("discountedTotal"));
            req.getRequestDispatcher("/Views/payment.jsp").forward(req, resp);
            return;
        }

        try (Connection conn = new DBContext().getConnection()) {

            VoucherService vs = new VoucherService(conn);
            BookingService bs = new BookingService(conn);
            BookingDAO bd = new BookingDAO();
            VoucherDAO vd = new VoucherDAO(conn);

            int userId = bd.getUserIdByBookingId(bookingId);
            if (userId == 0) {
                throw new Exception("Không tìm thấy người dùng cho booking này!");
            }

            // ⚠️ Kiểm tra user đã dùng voucher chưa
            if (!vd.canUserUseVoucher(voucherCode.trim(), userId)) {
                req.setAttribute("msg", " Bạn đã sử dụng voucher này rồi!");
                req.setAttribute("msgType", "error");
                restoreBookingInfo(req, session);
                req.setAttribute("total_price", totalPrice);
                req.setAttribute("discountedTotal", session.getAttribute("discountedTotal"));
                req.getRequestDispatcher("/Views/payment.jsp").forward(req, resp);
                return;
            }

            // ✅ Nếu hợp lệ → áp dụng voucher
            double discountedTotal = vs.applyVoucher(voucherCode.trim(), totalPrice);
            session.setAttribute("discountedTotal", discountedTotal);
            session.setAttribute("voucherCode", voucherCode.trim());

            restoreBookingInfo(req, session);
            req.setAttribute("total_price", totalPrice);
            req.setAttribute("discountedTotal", discountedTotal);
            req.setAttribute("appliedVoucher", voucherCode.trim());
            req.setAttribute("msg", " Voucher đã được áp dụng thành công!");
            req.setAttribute("msgType", "success");

            req.getRequestDispatcher("/Views/payment.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("msg", " Lỗi áp dụng voucher: " + e.getMessage());
            req.setAttribute("msgType", "error");

            // ⚙️ Giữ nguyên dữ liệu cũ (rất quan trọng)
            restoreBookingInfo(req, session);
            req.setAttribute("total_price", session.getAttribute("totalPrice"));
            req.setAttribute("discountedTotal", session.getAttribute("discountedTotal"));
            req.setAttribute("appliedVoucher", session.getAttribute("voucherCode"));

            req.getRequestDispatcher("/Views/payment.jsp").forward(req, resp);
        }
    }

    private void restoreBookingInfo(HttpServletRequest req, HttpSession session) {
        req.setAttribute("booking_id", session.getAttribute("bookingId"));
        req.setAttribute("customer_name", session.getAttribute("customer_name"));
        req.setAttribute("movie_title", session.getAttribute("movie_title"));
        req.setAttribute("auditorium_name", session.getAttribute("auditorium_name"));
        req.setAttribute("seat_code", session.getAttribute("bookedSeats"));
        req.setAttribute("start_time", session.getAttribute("start_time"));
    }
}
