/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controllers;

import Dao.NewsAndPromotionDAO;
import Models.NewsAndPromotion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/viewNews")
public class NewsAndPromotionViewController extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private NewsAndPromotionDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new NewsAndPromotionDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String type = request.getParameter("type"); // "news" hoặc "promotion"
            String idParam = request.getParameter("id"); // Xem chi tiết một item

            // Nếu có id, hiển thị chi tiết
            if (idParam != null && !idParam.trim().isEmpty()) {
                try {
                    int id = Integer.parseInt(idParam.trim());
                    NewsAndPromotion item = dao.getById(id);
                    if (item != null && item.isActive()) {
                        // Kiểm tra thời gian hiệu lực
                        java.sql.Timestamp now = new java.sql.Timestamp(System.currentTimeMillis());
                        boolean isValid = true;
                        if (item.getStartDate() != null && item.getStartDate().after(now)) {
                            isValid = false;
                        }
                        if (item.getEndDate() != null && item.getEndDate().before(now)) {
                            isValid = false;
                        }
                        
                        if (isValid) {
                            request.setAttribute("item", item);
                            request.getRequestDispatcher("Views/newsDetail.jsp").forward(request, response);
                            return;
                        }
                    }
                } catch (NumberFormatException e) {
                    // Invalid ID, fall through to list view
                }
            }

            // Lấy danh sách active news/promotions
            List<NewsAndPromotion> allItems = dao.getActive();
            
            // Lọc theo type nếu có
            List<NewsAndPromotion> newsList = new java.util.ArrayList<>();
            List<NewsAndPromotion> promotionList = new java.util.ArrayList<>();
            
            for (NewsAndPromotion item : allItems) {
                if ("news".equals(item.getType())) {
                    newsList.add(item);
                } else if ("promotion".equals(item.getType())) {
                    promotionList.add(item);
                }
            }

            // Nếu có filter type, chỉ hiển thị loại đó
            if (type != null && !type.trim().isEmpty()) {
                if ("news".equals(type)) {
                    request.setAttribute("newsList", newsList);
                    request.setAttribute("promotionList", new java.util.ArrayList<>());
                } else if ("promotion".equals(type)) {
                    request.setAttribute("newsList", new java.util.ArrayList<>());
                    request.setAttribute("promotionList", promotionList);
                } else {
                    request.setAttribute("newsList", newsList);
                    request.setAttribute("promotionList", promotionList);
                }
            } else {
                request.setAttribute("newsList", newsList);
                request.setAttribute("promotionList", promotionList);
            }

            request.setAttribute("currentType", type != null ? type : "all");
            request.getRequestDispatcher("Views/viewNews.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            Logger.getLogger(NewsAndPromotionViewController.class.getName()).log(Level.SEVERE, null, e);
            request.setAttribute("error", "Lỗi khi tải dữ liệu. Vui lòng thử lại sau.");
            try {
                request.setAttribute("newsList", new java.util.ArrayList<>());
                request.setAttribute("promotionList", new java.util.ArrayList<>());
                request.getRequestDispatcher("Views/viewNews.jsp").forward(request, response);
            } catch (ServletException | IOException ex) {
                Logger.getLogger(NewsAndPromotionViewController.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }
}

