package Controllers;

import DAL.BookingDAO;
import DAL.BookingItemDAO;
import DAL.SeatDAO;
import Models.Booking;
import Models.BookingItem;
import Models.Seat;
import Models.User;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * BookingServlet: xử lý việc lưu đơn đặt vé và các ghế đã chọn
 */
public class BookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        //Lấy session hiện tại (để biết user đang đăng nhập)
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Nếu chưa login thì redirect về trang login
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // Lấy thông tin ghế và tổng tiền từ form confirmSeat.jsp
        String[] selectedSeats = request.getParameterValues("selectedSeats");
//        System.out.println(">>> totalPrice param: " + request.getParameter("totalPrice"));
//        System.out.println(">>> basePrice param: " + request.getParameter("basePrice"));

        double basePrice = Double.parseDouble(request.getParameter("basePrice"));
        double totalPrice = Double.parseDouble(request.getParameter("totalPrice"));
        int showtimeId = Integer.parseInt(request.getParameter("showtimeId"));

        if (selectedSeats == null || selectedSeats.length == 0) {
            request.setAttribute("message", "Bạn chưa chọn ghế nào!");
            request.getRequestDispatcher("Views/confirm.jsp").forward(request, response);
            return;
        }

        //Tạo đối tượng BookingDAO để thêm booking mới
        BookingDAO bookingDAO = new BookingDAO();
        int bookingId = bookingDAO.addBooking(user.getUserId(), showtimeId, totalPrice);

        // Nếu không tạo được booking
        if (bookingId == -1) {
            request.setAttribute("message", "Lỗi khi tạo đơn đặt vé. Vui lòng thử lại!");
            request.getRequestDispatcher("Views/confirm.jsp").forward(request, response);
            return;
        }

        // Chuẩn bị danh sách BookingItem từ ghế đã chọn
        SeatDAO seatDAO = new SeatDAO();
        List<BookingItem> items = new ArrayList<>();

        for (String seatCode : selectedSeats) {
            Seat s = seatDAO.getSeatByCode(seatCode);

            if (s == null) {
                continue;
            }

            double seatPrice = basePrice;
            if (s.getSeatType().equalsIgnoreCase("VIP")) {
                seatPrice += 70000;
            } else if (s.getSeatType().equalsIgnoreCase("SweetBox")) {
                seatPrice += 100000;
            }

            BookingItem item = new BookingItem();
            item.setBookingId(bookingId);
            item.setSeatId(s.getSeatId());
            item.setPrice(seatPrice);
            item.setSeatType(s.getSeatType());
            items.add(item);
        }

        // Lưu tất cả các ghế vào bảng BookingItem
        BookingItemDAO itemDAO = new BookingItemDAO();
        itemDAO.addBookingItems(bookingId, items);

        // Cập nhật session để hiển thị thông tin thành công
        session.setAttribute("bookingId", bookingId);
        session.setAttribute("bookedSeats", selectedSeats);
        session.setAttribute("totalPrice", totalPrice);
//        response.getWriter().println("Total Price from form = " + request.getParameter("totalPrice"));
        //Nếu k thanh toán sau 10p thì booking tự động chuyển từ pending sang cancel
        new Thread(() -> {
            try {
                Thread.sleep(600000);//10phut
                BookingDAO bd = new BookingDAO();
                Booking b = bd.getBookingById(bookingId);
                if(b != null && b.getStatus().equalsIgnoreCase("pending")){
                    bd.updateBookingStatus(bookingId, "cancel");
                    System.out.println("Vui lòng reload lại trang ");
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }).start();
        // Chuyển hướng sang trang thanh toán
        response.sendRedirect("Views/payment.jsp");
    }
}
