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
import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.List;

/**
 *
 * @author Admin
 */
public class ListAuditoriumServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ListAuditoriumServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ListAuditoriumServlet at " + request.getContextPath() + "</h1>");
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
        List<Auditorium> list = aud.getAll();

        String q = request.getParameter("q");
        if (q != null && !q.trim().isEmpty()) {
            q = q.trim().toLowerCase();
            List<Auditorium> filtered = new ArrayList<>();
            for (Auditorium a : list) {
                if (String.valueOf(a.getAuditoriumId()).contains(q) || (a.getName() != null && a.getName().toLowerCase().contains(q))) {
                    filtered.add(a);
                }
            }
            list = filtered;
        }
        String sort = request.getParameter("sort");
        String dir = request.getParameter("dir");
        if (sort != null && dir != null) {
            Comparator<Auditorium> comp = null;
            switch (sort) {
                case "id":
                    comp = Comparator.comparingInt(Auditorium::getAuditoriumId);
                    break;
                case "name":
                    //lấy tên phòng rồi so sánh từng phần tử tên phòng trong list auditorium
                    comp = Comparator.comparing(a -> a.getName() == null ? "" : a.getName(), String.CASE_INSENSITIVE_ORDER);
                    break;
                case "layout":
                    //lấy layout rồi so sánh từng phần tử layout trong list auditorium
                    comp = Comparator.comparing(a -> a.getSeatLayoutMeta() == null ? "" : a.getSeatLayoutMeta(), String.CASE_INSENSITIVE_ORDER);
                    break;
                default:
                    comp = Comparator.comparingInt(Auditorium::getAuditoriumId);
                    break;
            }
            if (comp != null) {
                if ("desc".equalsIgnoreCase(dir)) {
                    comp = comp.reversed();
                }
                list.sort(comp);
            }
        }
        request.setAttribute("sort", sort == null ? "" : sort);
        request.setAttribute("dir", dir == null ? "" : dir);
        request.setAttribute("list", list);
        request.setAttribute("q", q == null ? "" : q);
        request.getRequestDispatcher("Views/Auditorium.jsp").forward(request, response);

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
        processRequest(request, response);
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
