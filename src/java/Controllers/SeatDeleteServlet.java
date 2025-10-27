package Controllers;

import DAL.SeatDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class SeatDeleteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int auditoriumId = Integer.parseInt(request.getParameter("auditoriumId"));
            String row = request.getParameter("row").trim().toUpperCase();
            int number = Integer.parseInt(request.getParameter("number"));

            SeatDAO dao = new SeatDAO();

            // ✅ Gọi hàm delete theo row + number + auditoriumId
            boolean deleted = dao.updateSeatShowingStatus(auditoriumId, row, number);

            if (deleted) {
                // Xóa thành công -> reload lại danh sách ghế
                response.sendRedirect("seatDetail?auditoriumId=" + auditoriumId);
            } else {
                // Không tìm thấy ghế -> báo lỗi
                request.setAttribute("error",
                        " Không tìm thấy ghế " + row + number + " trong phòng:" + auditoriumId);
                request.getRequestDispatcher("Views/SeatDetail.jsp").forward(request, response);
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "⚠️ Dữ liệu nhập không hợp lệ! Vui lòng kiểm tra lại.");
            request.getRequestDispatcher("Views/SeatDetail.jsp").forward(request, response);
        } 
    }
}
