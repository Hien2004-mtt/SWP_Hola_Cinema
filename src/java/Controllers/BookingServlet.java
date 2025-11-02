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
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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
