package Controllers;

import DAL.DBContext;
import DAO.VoucherDAO;
import Models.User;
import Models.Voucher;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.Date;
import java.util.List;

public class VoucherServlet extends HttpServlet {

     @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) action = "list";

        try (Connection conn = new DBContext().getConnection()) {
            VoucherDAO dao = new VoucherDAO(conn);
            dao.autoUpdateVoucherStatus();

            if ("list".equalsIgnoreCase(action)) {

                int page = 1;
                int recordsPerPage = 15;
                String sortColumn = req.getParameter("sortColumn");
                String sortOrder = req.getParameter("sortOrder");
                 String keyword = req.getParameter("q");

                if (req.getParameter("page") != null) {
                    page = Integer.parseInt(req.getParameter("page"));
                }
                if (sortColumn == null || sortColumn.isEmpty()) sortColumn = "voucher_id";
                if (sortOrder == null || sortOrder.isEmpty()) sortOrder = "ASC";

                List<Voucher> list;
                int totalRecords;
                int totalPages;

                  if (user.getRole() == 2) {
        if (keyword != null && !keyword.trim().isEmpty()) {
            totalRecords = dao.getActiveVoucherCountByKeyword(keyword);
            totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            list = dao.searchActiveVouchersByPageSorted(keyword, (page - 1) * recordsPerPage, recordsPerPage, sortColumn, sortOrder);
        } else {
            totalRecords = dao.getActiveVoucherCount();
            totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            list = dao.getActiveVouchersByPageSorted((page - 1) * recordsPerPage, recordsPerPage, sortColumn, sortOrder);
        }
    } else {
        if (keyword != null && !keyword.trim().isEmpty()) {
            totalRecords = dao.getTotalVoucherCountByKeyword(keyword);
            totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            list = dao.searchVouchersByPageSorted(keyword, (page - 1) * recordsPerPage, recordsPerPage, sortColumn, sortOrder);
        } else {
            totalRecords = dao.getTotalVoucherCount();
            totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);
            list = dao.getVouchersByPageSorted((page - 1) * recordsPerPage, recordsPerPage, sortColumn, sortOrder);
        }
    }

    req.setAttribute("list", list);
    req.setAttribute("currentPage", page);
    req.setAttribute("totalPages", totalPages);
    req.setAttribute("sortColumn", sortColumn);
    req.setAttribute("sortOrder", sortOrder);
    req.setAttribute("q", keyword);

                req.getRequestDispatcher("/Views/listVoucher.jsp").forward(req, resp);
                return;
            }

            // Các hành động khác (add, edit, delete, activate)
            switch (action) {
                case "delete":
                    int idDel = Integer.parseInt(req.getParameter("id"));
                    dao.setActive(idDel, false);
                    resp.sendRedirect("voucher?action=list");
                    break;

                case "activate":
                    int idAct = Integer.parseInt(req.getParameter("id"));
                    dao.setActive(idAct, true);
                    resp.sendRedirect("voucher?action=list");
                    break;

                case "add":
                    req.getRequestDispatcher("/Views/addVoucher.jsp").forward(req, resp);
                    break;

                case "edit":
                    int id = Integer.parseInt(req.getParameter("id"));
                    Voucher v = dao.getById(id);
                    req.setAttribute("voucher", v);
                    req.getRequestDispatcher("/Views/editVoucher.jsp").forward(req, resp);
                    break;

                default:
                    resp.sendRedirect("voucher?action=list");
                    break;
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        //  Nếu chưa đăng nhập → quay lại login
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        //  Khách hàng không được thêm hoặc sửa voucher
        if (user.getRole() == 2) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Bạn không có quyền thực hiện hành động này.");
            return;
        }

        String action = req.getParameter("action");

        try (Connection conn = new DBContext().getConnection()) {
            VoucherDAO dao = new VoucherDAO(conn);

            if ("add".equalsIgnoreCase(action)) {
                String code = req.getParameter("code");
                String type = req.getParameter("type");
                double value = Double.parseDouble(req.getParameter("value"));
                Date validFrom = java.sql.Date.valueOf(req.getParameter("valid_from"));
                Date validTo = java.sql.Date.valueOf(req.getParameter("valid_to"));
                int usageLimit = Integer.parseInt(req.getParameter("usage_limit"));
                int perUserLimit = Integer.parseInt(req.getParameter("per_user_limit"));

                if (code == null || code.trim().isEmpty()) {
                    code = dao.generateCode(10);
                }

                boolean isActive = true;
                Voucher v = new Voucher(0, code, type, value, validFrom, validTo,
                        usageLimit, perUserLimit, isActive);
                dao.insert(v);
                resp.sendRedirect("voucher?action=list");

            } else if ("update".equalsIgnoreCase(action)) {
                int id = Integer.parseInt(req.getParameter("voucher_id"));
                String type = req.getParameter("type");
                double value = Double.parseDouble(req.getParameter("value"));
                Date validFrom = java.sql.Date.valueOf(req.getParameter("valid_from"));
                Date validTo = java.sql.Date.valueOf(req.getParameter("valid_to"));
                int usageLimit = Integer.parseInt(req.getParameter("usage_limit"));
                int perUserLimit = Integer.parseInt(req.getParameter("per_user_limit"));

                dao.update(id, type, value, validFrom, validTo, usageLimit, perUserLimit);
                resp.sendRedirect("voucher?action=list");
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error: " + e.getMessage());
            req.getRequestDispatcher("/Views/addVoucher.jsp").forward(req, resp);
        }
    }
}
