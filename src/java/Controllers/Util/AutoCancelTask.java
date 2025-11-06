package Controller.Util;

import DAL.*;
import Models.*;
import java.util.List;

public class AutoCancelTask implements Runnable {
    private final int bookingId;

    public AutoCancelTask(int bookingId) {
        this.bookingId = bookingId;
    }

    @Override
    public void run() {
        try {
            Thread.sleep(10 * 60 * 1000);
            BookingDAO bookingDAO = new BookingDAO();
            BookingItemDAO itemDAO = new BookingItemDAO();
            SeatDAO seatDAO = new SeatDAO();

            Booking b = bookingDAO.getBookingById(bookingId);
            if (b != null && "pending".equalsIgnoreCase(b.getStatus())) {
                bookingDAO.updateBookingStatus(bookingId, "cancelled");
                List<BookingItem> booked = itemDAO.getItemsByBookingId(bookingId);
                for (BookingItem bi : booked) {
                    seatDAO.unlockSeat(bi.getSeatId());
                }
                System.out.println("Booking #" + bookingId + " bị hủy do quá hạn thanh toán!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
