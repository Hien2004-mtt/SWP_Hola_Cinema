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
                req.getRequestDispatcher("/admin/voucher/list.jsp").forward(req, resp);
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                dao.delete(id);
                resp.sendRedirect("voucher?action=list");
            } else if ("add".equals(action)) {
                req.getRequestDispatcher("/admin/voucher/add.jsp").forward(req, resp);
            } else {
                resp.sendRedirect("voucher?action=list");
            }
        } catch (Exception e) { throw new ServletException(e); }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        try (Connection conn = new DBContext().getConnection()) {
            VoucherDAO dao = new VoucherDAO(conn);
            if ("add".equals(action)) {
                String code = req.getParameter("code");
                String type = req.getParameter("type");
                double value = Double.parseDouble(req.getParameter("value"));
                Date validFrom = java.sql.Date.valueOf(req.getParameter("validFrom"));
                Date validTo = java.sql.Date.valueOf(req.getParameter("validTo"));
                int usageLimit = Integer.parseInt(req.getParameter("usageLimit"));
                int perUserLimit = Integer.parseInt(req.getParameter("perUserLimit"));

                Voucher v = new Voucher(0, code, type, value, validFrom, validTo, usageLimit, perUserLimit);
                dao.insert(v);
                resp.sendRedirect("voucher?action=list");
            }
        } catch (Exception e) { throw new ServletException(e); }
    }
}
