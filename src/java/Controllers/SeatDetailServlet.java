package Controllers;

import DAL.SeatDAO;
import Models.Seat;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


public class SeatDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String auditoriumParam = request.getParameter("auditoriumId");

        try {
            // 🔸 Kiểm tra tham số
            if (auditoriumParam == null || auditoriumParam.isEmpty()) {
                request.setAttribute("error", "❌ Thiếu auditoriumId! Vui lòng quay lại trang trước.");
                request.getRequestDispatcher("Views/Error.jsp").forward(request, response);
                return;
            }

            int auditoriumId = Integer.parseInt(auditoriumParam);

            SeatDAO seatDAO = new SeatDAO();
            List<Seat> seats = seatDAO.getSeatByAuditoriumIdForManager(auditoriumId);

            if (seats == null || seats.isEmpty()) {
                request.setAttribute("message", "⚠️ Phòng này hiện chưa có ghế nào.");
            }

            request.setAttribute("auditoriumId", auditoriumId);
            request.setAttribute("seats", seats);

            // ✅ Chuyển hướng về trang JSP
            request.getRequestDispatcher("Views/SeatDetail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "⚠️ Giá trị auditoriumId không hợp lệ!");
            request.getRequestDispatcher("Views/Error.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "❌ Đã xảy ra lỗi khi tải danh sách ghế!");
            request.getRequestDispatcher("Views/Error.jsp").forward(request, response);
        }
    }
}
