/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAL.AuditoriumDAO;
import Models.Auditorium;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Collections;
import java.util.Comparator;

/**
 *
 * @author USER
 */
public class AuditoriumServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     *
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AuditoriumServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AuditoriumServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuditoriumDAO aud = new AuditoriumDAO();
        String action = request.getParameter("action");

        if ("editForm".equals(action)) {
            // Hiển thị form sửa
            int id = Integer.parseInt(request.getParameter("id"));
            Auditorium a = aud.getById(id);
            request.setAttribute("auditorium", a);
            request.getRequestDispatcher("Views/EditAuditorium.jsp").forward(request, response);
        } else {
            // Hiển thị danh sách
            List<Auditorium> list = aud.getAll();
            //sỏrt khi bam vao cac truong tuong ung
            String sort = request.getParameter("sort"); // id | name | layout
            String dir = request.getParameter("dir");   // asc | desc
            if (sort != null && dir != null) {
                Comparator<Auditorium> cmp = null;
                switch (sort) {
                    case "id":
                        cmp = Comparator.comparingInt(Auditorium::getAuditoriumId);
                        break;
                    case "name":
                        cmp = Comparator.comparing(a1 -> a1.getName() == null ? "" : a1.getName(), String.CASE_INSENSITIVE_ORDER);
                        break;
                    case "layout":
                        cmp = Comparator.comparing(a1 -> a1.getSeatLayoutMeta() == null ? "" : a1.getSeatLayoutMeta(), String.CASE_INSENSITIVE_ORDER);
                        break;
                }
                if (cmp != null) {
                    if ("desc".equalsIgnoreCase(dir)) {
                        cmp = cmp.reversed();
                    }
                    Collections.sort(list, cmp);
                }
            }

            request.setAttribute("sort", sort == null ? "" : sort);
            request.setAttribute("dir", dir == null ? "" : dir);
            request.setAttribute("list", list);
            request.getRequestDispatcher("Views/Auditorium.jsp").forward(request, response);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AuditoriumDAO aud = new AuditoriumDAO();
        String action = request.getParameter("action");
        String name = request.getParameter("name");
        String layout = request.getParameter("layout");

        int id = -1;
        if (request.getParameter("id") != null && !request.getParameter("id").isEmpty()) {
            id = Integer.parseInt(request.getParameter("id"));
        }

        switch (action) {
            case "add":
                aud.insert(new Auditorium(0, name, layout, false));
                break;
            case "update":
                aud.update(new Auditorium(id, name, layout, false));
                break;
            case "delete":
                aud.delete(id);
                break;
        }
        response.sendRedirect("auditorium");

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
