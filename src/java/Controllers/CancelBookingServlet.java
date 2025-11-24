package Controllers;

import Dao.BookingDAO;
import Dao.BookingItemDAO;
import Dao.SeatDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class CancelBookingServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) return; // nothing to do

        Integer bookingId = (Integer) session.getAttribute("bookingId");
        if (bookingId == null) return;

        try {
            BookingDAO bookingDAO = new BookingDAO();
            BookingItemDAO itemDAO = new BookingItemDAO();
            SeatDAO seatDAO = new SeatDAO();

            // chỉ hủy khi vẫn "pending"
            Models.Booking b = bookingDAO.getBookingById(bookingId);
            if (b != null && b.getStatus().equalsIgnoreCase("pending")) {

                bookingDAO.updateBookingStatus(bookingId, "cancelled");

                List<Models.BookingItem> items = itemDAO.getItemsByBookingId(bookingId);
                List<Integer> seatIds = new ArrayList<>();
                for (Models.BookingItem it : items) {
                    seatIds.add(it.getSeatId());
                }

                seatDAO.unlockSeats(seatIds);
                System.out.println(" Booking #" + bookingId + " đã bị hủy do timeout");
            }

            session.invalidate(); // xóa session
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
