package Controllers;

import DAL.BookingDAO;
import DAL.BookingItemDAO;
import DAL.SeatDAO;
import DAL.ShowtimeDAO;
import Models.Booking;
import Models.BookingItem;
import Models.Seat;
import Models.User;
import java.io.IOException;

import java.sql.Timestamp;
import java.util.*;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class BookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // ====== LẤY DỮ LIỆU TỪ FORM ======
        String[] selectedSeats = request.getParameterValues("selectedSeats");
        String[] selectedSeats = request.getParameterValues("selectedSeats");
        if (selectedSeats == null || selectedSeats.length == 0) {
            request.setAttribute("message", "Bạn chưa chọn ghế nào!");
            request.getRequestDispatcher("Views/Seat.jsp").forward(request, response);
            return;
        }

        double basePrice = Double.parseDouble(request.getParameter("basePrice"));
        double totalPrice = Double.parseDouble(request.getParameter("totalPrice"));
        int showtimeId = Integer.parseInt(request.getParameter("showtimeId"));

        // Thêm để redirect đúng nếu ghế bị trùng
        String seatConflictCode = null;

        // ====== TẠO BOOKING ======
        BookingDAO bookingDAO = new BookingDAO();
        int bookingId = bookingDAO.addBooking(user.getUserId(), showtimeId, totalPrice);

        if (bookingId == -1) {
            request.setAttribute("message", "Lỗi khi tạo đơn đặt vé. Vui lòng thử lại!");
            request.getRequestDispatcher("Views/confirm.jsp").forward(request, response);
            return;
        }

        // ====== TẠO DANH SÁCH BOOKING ITEM ======
        SeatDAO seatDAO = new SeatDAO();
        ShowtimeDAO showtimeDAO = new ShowtimeDAO();
        int auditoriumId = showtimeDAO.getAuditoriumIdByShowtime(showtimeId);

        List<BookingItem> items = new ArrayList<>();
        for (String seatCode : selectedSeats) {
            Seat s = seatDAO.getSeatByCode(seatCode, auditoriumId);
            if (s == null) continue;

            double seatPrice = basePrice;
            if (s.getSeatType().equalsIgnoreCase("VIP")) seatPrice += 70000;
            else if (s.getSeatType().equalsIgnoreCase("SweetBox")) seatPrice += 100000;

            BookingItem item = new BookingItem();
            item.setBookingId(bookingId);
            item.setSeatId(s.getSeatId());
            item.setPrice(seatPrice);
            items.add(item);
        }

        // ====== LƯU VÀO BOOKING ITEM ======
        if (!items.isEmpty()) {
            BookingItemDAO itemDAO = new BookingItemDAO();
            itemDAO.addBookingItems(bookingId, showtimeId, items);
        }

        // ====== KHÓA GHẾ ======
        for (String seatCode : selectedSeats) {
            seatDAO.updateSeatStatusByCode(seatCode, false, auditoriumId);
        }

        // ====== TỰ HỦY SAU 10 PHÚT ======
        session.setMaxInactiveInterval(10 * 60);
        new Thread(() -> {
            try {
                Thread.sleep(10 * 60 * 1000);
                BookingDAO bd = new BookingDAO();
                Booking b = bd.getBookingById(bookingId);
                if (b != null && b.getStatus().equalsIgnoreCase("pending")) {
                    bd.updateBookingStatus(bookingId, "cancelled");
                    BookingItemDAO it = new BookingItemDAO();
                    List<BookingItem> booked = it.getItemsByBookingId(bookingId);
                    SeatDAO sd = new SeatDAO();
                    for (BookingItem bi : booked) {
                        sd.updateSeatStatusById(bi.getSeatId(), true);
                    }
                    System.out.println("️ Booking #" + bookingId + " bị hủy do quá hạn thanh toán!");
        BookingDAO bookingDAO = new BookingDAO();
        BookingItemDAO itemDAO = new BookingItemDAO();
        SeatDAO seatDAO = new SeatDAO();
        ShowtimeDAO showtimeDAO = new ShowtimeDAO();

        int auditoriumId = showtimeDAO.getAuditoriumIdByShowtime(showtimeId);

        try (Connection conn = DAL.DBContext.getConnection()) {
            conn.setAutoCommit(false);
            conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);

            List<BookingItem> items = new ArrayList<>();

            //Lock từng ghế
            for (String seatCode : selectedSeats) {
                Seat seat = seatDAO.getSeatByCode(seatCode, auditoriumId);
                if (seat == null) {
                    continue;
                }

                boolean locked = seatDAO.lockSeat(conn, seat.getSeatId());
                if (!locked) {
                    conn.rollback();

                    // 🔹 Lưu thông báo vào session
                    session.setAttribute("seatMessage", "⚠️ Ghế " + seatCode + " đã được người khác đặt trước!");

                    // 🔹 Quay lại trang seat (SeatServlet) với showtimeId hiện tại
                    response.sendRedirect("seat?showtimeId=" + showtimeId);
                    return;
                }

                double seatPrice = basePrice;
                if (seat.getSeatType().equalsIgnoreCase("VIP")) {
                    seatPrice += 70000;
                } else if (seat.getSeatType().equalsIgnoreCase("SweetBox")) {
                    seatPrice += 100000;
                }

                BookingItem item = new BookingItem();
                item.setSeatId(seat.getSeatId());
                item.setPrice(seatPrice);
                items.add(item);
            }
        }).start();

        // ====== CHUẨN BỊ THÔNG TIN HIỂN THỊ ======
        String customerName = user.getName();
        String movieTitle = new ShowtimeDAO().getMovieTitleByShowtime(showtimeId);
        String auditoriumName = new ShowtimeDAO().getAuditoriumNameByShowtime(showtimeId);
        Timestamp startTime = bookingDAO.getShowtimeStartByBookingId(bookingId);

        // ====== LƯU SESSION ĐỂ APPLY VOUCHER KHÔNG MẤT ======
        session.setAttribute("bookingId", bookingId);
        session.setAttribute("bookedSeats", selectedSeats);
        session.setAttribute("totalPrice", totalPrice);
        session.setAttribute("customer_name", customerName);
        session.setAttribute("movie_title", movieTitle);
        session.setAttribute("auditorium_name", auditoriumName);
        session.setAttribute("start_time", startTime);
        
        // ====== HIỂN THỊ PAYMENT ======
        request.setAttribute("booking_id", bookingId);
        request.setAttribute("customer_name", customerName);
        request.setAttribute("movie_title", movieTitle);
        request.setAttribute("auditorium_name", auditoriumName);
        request.setAttribute("seat_code", selectedSeats);
        request.setAttribute("start_time", startTime);
        request.setAttribute("total_price", totalPrice);
        request.getRequestDispatcher("Views/payment.jsp").forward(request, response);

            // Nếu có ghế trùng, redirect về trang seat
            if (seatConflictCode != null) {
                // rollback đã thực hiện ở trên rồi
                response.sendRedirect("seat?showtimeId=" + showtimeId + "&errorSeat=" + seatConflictCode);
                return;
            }

            // Tạo booking
            int bookingId = bookingDAO.addBooking(conn, user.getUserId(), showtimeId, totalPrice);
            if (bookingId == -1) {
                conn.rollback();
                response.sendRedirect("seat?showtimeId=" + showtimeId + "&errorSeat=unknown");
                return;
            }

            // Lưu BookingItem
            itemDAO.addBookingItems(conn, bookingId, showtimeId, items);

            //  Commit giao dịch
            conn.commit();

            session.setAttribute("bookingId", bookingId);
            session.setAttribute("bookedSeats", selectedSeats);
            session.setAttribute("totalPrice", totalPrice);

            //  Thread tự động hủy sau 10 phút
            new Thread(() -> {
                try {
                    Thread.sleep(10 * 60 * 1000);
                    Booking b = bookingDAO.getBookingById(bookingId);
                    if (b != null && b.getStatus().equalsIgnoreCase("pending")) {
                        bookingDAO.updateBookingStatus(bookingId, "cancelled");
                        List<BookingItem> booked = itemDAO.getItemsByBookingId(bookingId);
                        for (BookingItem bi : booked) {
                            seatDAO.unlockSeat(bi.getSeatId());
                        }
                        System.out.println("Booking #" + bookingId + " đã bị hủy do quá hạn thanh toán.");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }).start();

            response.sendRedirect("Views/payment.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("seat?showtimeId=" + request.getParameter("showtimeId") + "&errorSeat=system");
        }
    }
}
