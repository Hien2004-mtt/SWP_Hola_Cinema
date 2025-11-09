/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controllers;

import DAL.NewsAndPromotionDAO;
import Models.NewsAndPromotion;
import Models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/manageNewsAndPromotion")
public class NewsAndPromotionManageController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private NewsAndPromotionDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new NewsAndPromotionDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User loggedInUser = (User) request.getSession().getAttribute("user");
        // Uncomment for authentication check
        // if (loggedInUser == null || loggedInUser.getRole() != 0) {
        //     response.sendRedirect("login.jsp");
        //     return;
        // }

        try {
            String action = request.getParameter("action");
            String filter = request.getParameter("filter");
            String search = request.getParameter("search");

            // Lấy danh sách news và promotions
            java.util.List<NewsAndPromotion> list;
            if (filter != null && !filter.equals("all")) {
                if (filter.equals("active")) {
                    list = dao.getActive();
                } else {
                    list = dao.getByType(filter);
                }
            } else {
                list = dao.getAll();
            }

            // Tìm kiếm
            if (search != null && !search.trim().isEmpty()) {
                String searchLower = search.trim().toLowerCase();
                java.util.List<NewsAndPromotion> searchedList = new java.util.ArrayList<>();
                for (NewsAndPromotion item : list) {
                    boolean match = false;
                    if (item.getTitle() != null && item.getTitle().toLowerCase().contains(searchLower)) {
                        match = true;
                    }
                    if (item.getContent() != null && item.getContent().toLowerCase().contains(searchLower)) {
                        match = true;
                    }
                    if (item.getType() != null && item.getType().toLowerCase().contains(searchLower)) {
                        match = true;
                    }
                    if (match) {
                        searchedList.add(item);
                    }
                }
                list = searchedList;
            }

            request.setAttribute("newsList", list);
            request.setAttribute("currentFilter", filter != null ? filter : "all");
            request.setAttribute("currentSearch", search != null ? search : "");
            request.getRequestDispatcher("Views/manageNewsAndPromotion.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu: " + e.getMessage());
            try {
                request.setAttribute("newsList", dao.getAll());
                request.getRequestDispatcher("Views/manageNewsAndPromotion.jsp").forward(request, response);
            } catch (SQLException | ClassNotFoundException ex) {
                Logger.getLogger(NewsAndPromotionManageController.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User loggedInUser = (User) request.getSession().getAttribute("user");
        // Uncomment for authentication check
        // if (loggedInUser == null || loggedInUser.getRole() != 0) {
        //     response.sendRedirect("login.jsp");
        //     return;
        // }

        try {
            String action = request.getParameter("action");
            if (action == null) {
                action = "add";
            }

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            SimpleDateFormat datetimeFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            dateFormat.setLenient(false);
            datetimeFormat.setLenient(false);

            switch (action) {
                case "add": {
                    String title = request.getParameter("title");
                    String content = request.getParameter("content");
                    String imageUrl = request.getParameter("imageUrl");
                    String type = request.getParameter("type");
                    String startDateStr = request.getParameter("startDate");
                    String endDateStr = request.getParameter("endDate");
                    String isActiveStr = request.getParameter("isActive");

                    if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()
                            || type == null || type.trim().isEmpty()) {
                        request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc!");
                        break;
                    }

                    NewsAndPromotion news = new NewsAndPromotion();
                    news.setTitle(title.trim());
                    news.setContent(content.trim());
                    news.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
                    news.setType(type.trim());
                    news.setActive(isActiveStr != null && isActiveStr.equals("1"));

                    // Parse dates
                    try {
                        if (startDateStr != null && !startDateStr.trim().isEmpty()) {
                            news.setStartDate(new Timestamp(datetimeFormat.parse(startDateStr.trim()).getTime()));
                        }
                        if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                            news.setEndDate(new Timestamp(datetimeFormat.parse(endDateStr.trim()).getTime()));
                        }
                    } catch (ParseException e) {
                        request.setAttribute("error", "Định dạng ngày tháng không hợp lệ!");
                        break;
                    }

                    // Tạm thời bỏ qua đăng nhập - sử dụng user_id = 1 làm mặc định
                    news.setCreatedBy(loggedInUser != null ? loggedInUser.getUserId() : 1);

                    int newId = dao.add(news);
                    if (newId > 0) {
                        request.setAttribute("success", "Thêm " + (type.equals("news") ? "tin tức" : "khuyến mãi") + " thành công!");
                    } else {
                        request.setAttribute("error", "Không thể thêm " + (type.equals("news") ? "tin tức" : "khuyến mãi") + "!");
                    }
                    break;
                }
                case "update": {
                    String idStr = request.getParameter("id");
                    String title = request.getParameter("title");
                    String content = request.getParameter("content");
                    String imageUrl = request.getParameter("imageUrl");
                    String type = request.getParameter("type");
                    String startDateStr = request.getParameter("startDate");
                    String endDateStr = request.getParameter("endDate");
                    String isActiveStr = request.getParameter("isActive");

                    if (idStr == null || title == null || title.trim().isEmpty()
                            || content == null || content.trim().isEmpty() || type == null || type.trim().isEmpty()) {
                        request.setAttribute("error", "Vui lòng điền đầy đủ thông tin!");
                        break;
                    }

                    int id = Integer.parseInt(idStr.trim());
                    NewsAndPromotion news = dao.getById(id);
                    if (news == null) {
                        request.setAttribute("error", "Không tìm thấy " + (type.equals("news") ? "tin tức" : "khuyến mãi") + "!");
                        break;
                    }

                    news.setTitle(title.trim());
                    news.setContent(content.trim());
                    news.setImageUrl(imageUrl != null ? imageUrl.trim() : "");
                    news.setType(type.trim());
                    news.setActive(isActiveStr != null && isActiveStr.equals("1"));

                    // Parse dates
                    try {
                        if (startDateStr != null && !startDateStr.trim().isEmpty()) {
                            news.setStartDate(new Timestamp(datetimeFormat.parse(startDateStr.trim()).getTime()));
                        } else {
                            news.setStartDate(null);
                        }
                        if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                            news.setEndDate(new Timestamp(datetimeFormat.parse(endDateStr.trim()).getTime()));
                        } else {
                            news.setEndDate(null);
                        }
                    } catch (ParseException e) {
                        request.setAttribute("error", "Định dạng ngày tháng không hợp lệ!");
                        break;
                    }

                    boolean ok = dao.update(news);
                    if (ok) {
                        request.setAttribute("success", "Cập nhật " + (type.equals("news") ? "tin tức" : "khuyến mãi") + " thành công!");
                    } else {
                        request.setAttribute("error", "Không thể cập nhật " + (type.equals("news") ? "tin tức" : "khuyến mãi") + "!");
                    }
                    break;
                }
                case "delete": {
                    String idStr = request.getParameter("id");
                    if (idStr == null) {
                        request.setAttribute("error", "Thiếu ID để xóa!");
                        break;
                    }
                    int id = Integer.parseInt(idStr.trim());
                    boolean ok = dao.delete(id);
                    if (ok) {
                        request.setAttribute("success", "Xóa thành công!");
                    } else {
                        request.setAttribute("error", "Không thể xóa!");
                    }
                    break;
                }
                case "toggleActive": {
                    String idStr = request.getParameter("id");
                    if (idStr == null) {
                        request.setAttribute("error", "Thiếu ID!");
                        break;
                    }
                    int id = Integer.parseInt(idStr.trim());
                    boolean ok = dao.toggleActive(id);
                    if (ok) {
                        request.setAttribute("success", "Cập nhật trạng thái thành công!");
                    } else {
                        request.setAttribute("error", "Không thể cập nhật trạng thái!");
                    }
                    break;
                }
            }

            // Reload data
            request.setAttribute("newsList", dao.getAll());
            request.getRequestDispatcher("Views/manageNewsAndPromotion.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            try {
                e.printStackTrace();
                request.setAttribute("error", "Giá trị số không hợp lệ: " + e.getMessage());
                request.setAttribute("newsList", dao.getAll());
                request.getRequestDispatcher("Views/manageNewsAndPromotion.jsp").forward(request, response);
            } catch (SQLException | ClassNotFoundException ex) {
                Logger.getLogger(NewsAndPromotionManageController.class.getName()).log(Level.SEVERE, null, ex);
            }
        } catch (SQLException | ClassNotFoundException  e) {
            try {
                e.printStackTrace();
                request.setAttribute("error", "Lỗi khi xử lý: " + e.getMessage());
                request.setAttribute("newsList", dao.getAll());
                request.getRequestDispatcher("Views/manageNewsAndPromotion.jsp").forward(request, response);
            } catch (SQLException | ClassNotFoundException ex) {
                Logger.getLogger(NewsAndPromotionManageController.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
}

