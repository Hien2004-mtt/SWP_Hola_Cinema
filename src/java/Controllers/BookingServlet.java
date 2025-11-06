package Controllers;

import Controller.Util.AutoCancelTask;
import DAL.*;
import Models.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class BookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // ====== KIỂM TRA ĐĂNG NHẬP ======
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // ====== LẤY DỮ LIỆU TỪ FORM ======
        String[] selectedSeats = request.getParameterValues("selectedSeats");
        if (selectedSeats == null || selectedSeats.length == 0) {
            request.setAttribute("message", "Bạn chưa chọn ghế nào!");
            request.getRequestDispatcher("Views/Seat.jsp").forward(request, response);
            return;
        }

        double basePrice = Double.parseDouble(request.getParameter("basePrice"));
        double totalPrice = Double.parseDouble(request.getParameter("totalPrice"));
        int showtimeId = Integer.parseInt(request.getParameter("showtimeId"));

        // ====== KHAI BÁO DAO ======
        BookingDAO bookingDAO = new BookingDAO();
        BookingItemDAO itemDAO = new BookingItemDAO();
        SeatDAO seatDAO = new SeatDAO();
        ShowtimeDAO showtimeDAO = new ShowtimeDAO();

        int auditoriumId = showtimeDAO.getAuditoriumIdByShowtime(showtimeId);

        try (Connection conn = DAL.DBContext.getConnection()) {
            conn.setAutoCommit(false);
            conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);

            List<BookingItem> items = new ArrayList<>();

            // ====== LOCK GHẾ ======
            for (String seatCode : selectedSeats) {
                Seat seat = seatDAO.getSeatByCode(seatCode, auditoriumId);
                if (seat == null) continue;

                boolean locked = seatDAO.lockSeat(conn, seat.getSeatId());
                if (!locked) {
                    conn.rollback();
                    session.setAttribute("seatMessage", "⚠️ Ghế " + seatCode + " đã được người khác đặt trước!");
                    response.sendRedirect("seat?showtimeId=" + showtimeId);
                    return;
                }

                double seatPrice = basePrice;
                if (seat.getSeatType().equalsIgnoreCase("VIP")) seatPrice += 70000;
                else if (seat.getSeatType().equalsIgnoreCase("SweetBox")) seatPrice += 100000;

                BookingItem item = new BookingItem();
                item.setSeatId(seat.getSeatId());
                item.setPrice(seatPrice);
                items.add(item);
            }

            // ====== TẠO BOOKING ======
            int bookingId = bookingDAO.addBooking(conn, user.getUserId(), showtimeId, totalPrice);
            if (bookingId == -1) {
                conn.rollback();
                response.sendRedirect("seat?showtimeId=" + showtimeId + "&error=bookingFailed");
                return;
            }

            // ====== LƯU BOOKING ITEM ======
            itemDAO.addBookingItems(conn, bookingId, showtimeId, items);

            // ====== COMMIT GIAO DỊCH ======
            conn.commit();
            
java.util.concurrent.ExecutorService executor = java.util.concurrent.Executors.newSingleThreadExecutor();
executor.submit(new AutoCancelTask(bookingId));
executor.shutdown();

            // ====== LƯU SESSION ĐỂ APPLY VOUCHER KHÔNG MẤT ======
            session.setAttribute("bookingId", bookingId);
            session.setAttribute("bookedSeats", selectedSeats);
            session.setAttribute("totalPrice", totalPrice);

            // ====== THREAD TỰ HỦY SAU 10 PHÚT (NẾU CHƯA THANH TOÁN) ======
           

            // ====== LẤY THÔNG TIN HIỂN THỊ CHO PAYMENT ======
            String customerName = user.getName();
            String movieTitle = showtimeDAO.getMovieTitleByShowtime(showtimeId);
            String auditoriumName = showtimeDAO.getAuditoriumNameByShowtime(showtimeId);
            String hashCode = bookingDAO.hashBookingId(bookingId);
            Timestamp startTime = bookingDAO.getShowtimeStartByBookingId(bookingId);

            request.setAttribute("booking_code", hashCode);
            request.setAttribute("customer_name", customerName);
            request.setAttribute("movie_title", movieTitle);
            request.setAttribute("auditorium_name", auditoriumName);
            request.setAttribute("seat_code", selectedSeats);
            request.setAttribute("start_time", startTime);
            request.setAttribute("total_price", totalPrice);

            // ====== LƯU SESSION THÊM (CHO HIỂN THỊ PAYMENT) ======
            session.setAttribute("customer_name", customerName);
            session.setAttribute("movie_title", movieTitle);
            session.setAttribute("auditorium_name", auditoriumName);
            session.setAttribute("start_time", startTime);

            // ====== CHUYỂN SANG TRANG THANH TOÁN ======
            request.getRequestDispatcher("Views/payment.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("seat?showtimeId=" + showtimeId + "&error=system");
        }
    }
}
