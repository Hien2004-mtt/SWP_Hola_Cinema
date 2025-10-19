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
        String sortField = request.getParameter("sortField");
        String sortOrder = request.getParameter("sortOrder");
        String roleParam = request.getParameter("role");

        int pageSize = 10; // số lượng user mỗi trang
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }
        List<User> allUsers = new DAO().getAllUsers(search, sortField, sortOrder, roleParam);
        int totalUsers = allUsers.size();
        int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
        if (totalPages == 0) totalPages = 1;
        int fromIndex = (currentPage - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalUsers);
        List<User> userList;
        if (fromIndex < totalUsers) {
            userList = allUsers.subList(fromIndex, toIndex);
        } else {
            userList = new java.util.ArrayList<>();
        }

        request.setAttribute("userList", userList);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("sortField", sortField);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("roleFilter", roleParam);
        request.getRequestDispatcher("/Views/admin/accountList.jsp").forward(request, response);
    }

    // Phương thức kiểm tra quyền admin (giả sử lưu thông tin người dùng trong session)
    private boolean isAdmin(HttpServletRequest request) {
        // Giả sử thông tin người dùng được lưu trong session với key "user"
        User loggedInUser = (User) request.getSession().getAttribute("user");
        return loggedInUser != null && loggedInUser.getRole() == 0; // 0 là role admin
    }
}