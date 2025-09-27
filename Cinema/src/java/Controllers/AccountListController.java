package Controllers;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import DAL.DAO;
import Models.User;
import java.util.List;

public class AccountListController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra quyền truy cập (giả sử chỉ admin có thể truy cập)
//        if (!isAdmin(request)) {
//            response.sendRedirect("login.jsp");
//            return;
//        }

        String search = request.getParameter("search");
        List<User> userList = new DAO().getAllUsers(search);

        request.setAttribute("userList", userList);
        request.getRequestDispatcher("/Views/admin/accountList.jsp").forward(request, response);
    }

    // Phương thức kiểm tra quyền admin (giả sử lưu thông tin người dùng trong session)
    private boolean isAdmin(HttpServletRequest request) {
        // Giả sử thông tin người dùng được lưu trong session với key "user"
        User loggedInUser = (User) request.getSession().getAttribute("user");
        return loggedInUser != null && loggedInUser.getRole() == 0; // 0 là role admin
    }
}