package Controllers;

import DAL.DBContext;
import DAO.VoucherDAO;
import Models.Voucher;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.Date;

public class VoucherServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try (Connection conn = new DBContext().getConnection()) {
            VoucherDAO dao = new VoucherDAO(conn);

            if ("list".equals(action)) {
                req.setAttribute("list", dao.getAll());
                req.getRequestDispatcher("/Views/listVoucher.jsp").forward(req, resp);


            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.setActive(id, false); // soft delete → set isActive = 0
                resp.sendRedirect("voucher?action=list");

            } else if ("activate".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.setActive(id, true);
                resp.sendRedirect("voucher?action=list");

            } else if ("add".equals(action)) {
                req.getRequestDispatcher("/Views/addVoucher.jsp").forward(req, resp);

            }
            else if ("edit".equals(action)) {
    int id = Integer.parseInt(req.getParameter("id"));
    Voucher v = dao.getById(id);
    req.setAttribute("voucher", v);
    req.getRequestDispatcher("/Views/editVoucher.jsp").forward(req, resp);
}
            else if ("update".equals(action)) {
    int id = Integer.parseInt(req.getParameter("voucher_id"));
    String type = req.getParameter("type");
    double value = Double.parseDouble(req.getParameter("value"));
    Date validFrom = java.sql.Date.valueOf(req.getParameter("valid_from"));
    Date validTo = java.sql.Date.valueOf(req.getParameter("valid_to"));
    int usageLimit = Integer.parseInt(req.getParameter("usage_limit"));
    int perUserLimit = Integer.parseInt(req.getParameter("per_user_limit"));

    dao.update(id, type, value, validFrom, validTo, usageLimit, perUserLimit);
    resp.sendRedirect("voucher?action=list");
}else {
                resp.sendRedirect("voucher?action=list");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

     @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        try (Connection conn = new DBContext().getConnection()) {
            VoucherDAO dao = new VoucherDAO(conn);

            // 🟢 ADD
            if ("add".equals(action)) {
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
                Voucher v = new Voucher(0, code, type, value, validFrom, validTo, usageLimit, perUserLimit, isActive);
                dao.insert(v);
                resp.sendRedirect("voucher?action=list");
            }

            //  UPDATE
            else if ("update".equals(action)) {
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
            req.setAttribute("error", " Error: " + e.getMessage());
            req.getRequestDispatcher("/Views/addVoucher.jsp").forward(req, resp);
        }
    }
}

