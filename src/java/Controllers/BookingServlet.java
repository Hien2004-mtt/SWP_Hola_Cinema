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
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class BookingServlet extends HttpServlet {

    private static final ScheduledExecutorService scheduler = Executors.newScheduledThreadPool(2);

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

        BookingDAO bookingDAO = new BookingDAO();
        BookingItemDAO itemDAO = new BookingItemDAO();
        SeatDAO seatDAO = new SeatDAO();
        ShowtimeDAO showtimeDAO = new ShowtimeDAO();

        int auditoriumId = showtimeDAO.getAuditoriumIdByShowtime(showtimeId);

        try (Connection conn = DAL.DBContext.getConnection()) {
            conn.setAutoCommit(false);
            conn.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);

            // Lấy danh sách ghế từ code
            List<Seat> seatList = new ArrayList<>();
            List<Integer> seatIds = new ArrayList<>();
            for (String seatCode : selectedSeats) {
                Seat seat = seatDAO.getSeatByCode(seatCode, auditoriumId);
                if (seat != null) {
                    seatList.add(seat);
                    seatIds.add(seat.getSeatId());
                }
            }

            if (seatIds.isEmpty()) {
                request.setAttribute("message", "Không tìm thấy ghế hợp lệ!");
                request.getRequestDispatcher("Views/Seat.jsp").forward(request, response);
                return;
            }

            // Gọi DAO để lock nhiều ghế
            boolean locked = seatDAO.lockSeats(conn, seatIds);
            if (!locked) {
                conn.rollback();
                session.setAttribute("seatMessage", "Một hoặc nhiều ghế đã được người khác đặt trước!");
                response.sendRedirect("seat?showtimeId=" + showtimeId);
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
            List<BookingItem> items = new ArrayList<>();
            for (Seat seat : seatList) {
                double seatPrice = basePrice;
                if (seat.getSeatType().equalsIgnoreCase("VIP")) seatPrice += 70000;
                else if (seat.getSeatType().equalsIgnoreCase("SweetBox")) seatPrice += 100000;

                BookingItem item = new BookingItem();
                item.setSeatId(seat.getSeatId());
                item.setPrice(seatPrice);
                items.add(item);
            }

            itemDAO.addBookingItems(conn, bookingId, showtimeId, items);
            conn.commit();

            session.setAttribute("bookingId", bookingId);
            session.setAttribute("bookedSeats", selectedSeats);
            session.setAttribute("totalPrice", totalPrice);

            // Hủy tự động sau 10 phút
            scheduler.schedule(() -> {
                try {
                    Booking booking = bookingDAO.getBookingById(bookingId);
                    if (booking != null && booking.getStatus().equalsIgnoreCase("pending")) {
                        bookingDAO.updateBookingStatus(bookingId, "cancelled");
                        List<BookingItem> bookedItems = itemDAO.getItemsByBookingId(bookingId);
                        List<Integer> ids = new ArrayList<>();
                        for (BookingItem bi : bookedItems) {
                            ids.add(bi.getSeatId());
                        }
                        seatDAO.unlockSeats(ids);
                        System.out.println("Booking #" + bookingId + " đã bị hủy do quá hạn thanh toán.");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }, 10, TimeUnit.MINUTES);

            response.sendRedirect("Views/payment.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("seat?showtimeId=" + showtimeId + "&errorSeat=system");
        }
    }
}
