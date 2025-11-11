///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//package Controllers;
//
//import DAL.BookingItemDAO;
//import DAL.SeatDAO;
//import Models.BookingItem;
//import Models.Seat;
//import Models.User;
//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//
///**
// *
// * @author Admin
// */
//public class BookingItemServlet extends HttpServlet {
//
//    /**
//     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
//     * methods.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        response.setContentType("text/html;charset=UTF-8");
//        try (PrintWriter out = response.getWriter()) {
//            /* TODO output your page here. You may use following sample code. */
//            out.println("<!DOCTYPE html>");
//            out.println("<html>");
//            out.println("<head>");
//            out.println("<title>Servlet BookingItemServlet</title>");
//            out.println("</head>");
//            out.println("<body>");
//            out.println("<h1>Servlet BookingItemServlet at " + request.getContextPath() + "</h1>");
//            out.println("</body>");
//            out.println("</html>");
//        }
//    }
//
//    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
//    /**
//     * Handles the HTTP <code>GET</code> method.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        processRequest(request, response);
//    }
//
//    /**
//     * Handles the HTTP <code>POST</code> method.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        // khoi tao session
//        HttpSession session = request.getSession(false);
//        // kiem tra xem user co null hay la k
//        User user = (session != null) ? (User) session.getAttribute("user") : null;
//
//        if (user == null) { //neu ma null thi tra ve login
//            response.sendRedirect("Views/login.jsp");
//            return;
//        }
//        //lay session ghe da chon
//        String[] selectedSeats = request.getParameterValues("selectedSeats");
//        //lay session cua showtimId da chon
//        String showtimId_raw = request.getParameter("showtimeId");
//        //lay session cua bookingId
//        String bookingId_raw = request.getParameter("bookingId");
//        //lay session cua basePrice
//        String basePriceRaw = request.getParameter("basePrice");
//        //kiem tra xem cac bien lay ra tu session co null k. Neu null thi tra ve buoc chon ghe
//        if (selectedSeats == null || showtimId_raw == null || bookingId_raw == null) {
//            response.sendRedirect("Seat?showtimeId=?" + showtimId_raw);
//            return;
//        }
//        int showtimeId = Integer.parseInt(showtimId_raw);
//        double basePrice = Double.parseDouble(basePriceRaw);
//        int bookingId = Integer.parseInt(bookingId_raw);
//        BookingItemDAO b = new BookingItemDAO();
//        SeatDAO s = new SeatDAO();
//        double totalPrice = 0;
//        for (String seatCode : selectedSeats) {
//            Seat seat = s.getSeatByCode(seatCode, auditoriumId);
//            double price = basePrice;
//            String type = seat.getSeatType();
//            switch (type.toLowerCase()) {
//                case "vip":
//                    price = price + 70000;
//                    break;
//                case "sweetbox":
//                    price = price + 100000;
//                    break;
//                default:
//                    break;
//            }
//        BookingItem item = new BookingItem();
//        item.setBookingId(bookingId);
//        
//        item.setSeatId(seat.getSeatId());
//        item.setPrice(price);
//        item.setTicketType(type);
//        b.addBookingItems(item);
//        totalPrice = totalPrice + price;
//        }
//        session.setAttribute("bookingTotal", totalPrice);
//        response.sendRedirect("home");
//
//    }
//
//    /**
//     * Returns a short description of the servlet.
//     *
//     * @return a String containing servlet description
//     */
//    @Override
//    public String getServletInfo() {
//        return "Short description";
//    }// </editor-fold>
//
//}
