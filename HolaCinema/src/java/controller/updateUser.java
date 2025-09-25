/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAL.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Date;
import model.User;

/**
 *
 * @author USER
 */
public class updateUser extends HttpServlet {

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
            out.println("<title>Servlet updateUser</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet updateUser at " + request.getContextPath() + "</h1>");
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
       UserDAO ud = new UserDAO();
       String id_raw = request.getParameter("id");
       String fix_raw = request.getParameter("fix");
       try{
           int id = Integer.parseInt(id_raw);
           int fix = (fix_raw == null) ? 0 : Integer.parseInt(fix_raw);
           User user = ud.getUserById(id);
           request.setAttribute("user", user);
           request.setAttribute("fix", fix);
           request.getRequestDispatcher("profile.jsp").forward(request, response);
       }catch(NumberFormatException e){
          e.printStackTrace();
          response.sendRedirect("home.jsp");
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
       HttpSession session = request.getSession();
    UserDAO dao = new UserDAO();
    User user = (User) session.getAttribute("user");
    String id_raw = request.getParameter("id");
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String gender_raw = request.getParameter("gender");
    String oldPassword =request.getParameter("oldPassword");
    String newPassword = request.getParameter("newPassword");
    String confirmPassword = request.getParameter("confirmPassword");
    try{
        int id = Integer.parseInt(id_raw);
        User c = dao.getUserById(id);
        if(newPassword != null  && !newPassword.isEmpty() ){
            if(!c.getPassword().equals(oldPassword)){
                request.setAttribute("error", "Mật khẩu hiện tại không đúng");
                request.setAttribute("user", c);
                request.setAttribute("fix", 1);
                request.getRequestDispatcher("profile.jsp").forward(request, response);
                return;
            }
        if(!newPassword.equals(confirmPassword)){
            request.setAttribute("error", "Xác nhận mật khẩu mới sai");
            request.setAttribute("user", c);
            request.setAttribute("fix", 1);
            request.getRequestDispatcher("profile.jsp").forward(request, response);
            return;
        }
        c.setPassword(newPassword);
    }
        c.setName(name);
        c.setEmail(email);
        c.setPhone(phone);
        c.setGender(Boolean.parseBoolean(gender_raw));
        c.setUpdateAt(new java.util.Date());
         dao.updateUser(c);
         session.setAttribute("user", c);
         request.setAttribute("user", c);
         request.setAttribute("message", "cập nhật thành công");
         request.getRequestDispatcher("profile.jsp").forward(request, response);
    }catch(Exception e){
        e.printStackTrace();
        request.setAttribute("error", "Có lỗi khi cập nhật");
        request.getRequestDispatcher("profile.jsp").forward(request, response);
    }
    
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
