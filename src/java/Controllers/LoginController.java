/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controllers;

import DAO.UserDAO;
import Models.Users;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author dhnga
 */
public class LoginController extends HttpServlet {
   
   

   
    @Override
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        Users user = dao.loginByPhone(phone, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole()); // lấy role từ DB

            // chuyển hướng theo role
            switch (user.getRole()) {
                case 0 -> response.sendRedirect("admin/dashboard.jsp");
                case 1 -> response.sendRedirect("manager/dashboard.jsp");
                default -> response.sendRedirect("customer/home.jsp");
            }
        } else {
            request.setAttribute("loginError", "Invalid phone or password.");
            request.setAttribute("activeTab", "login");
            request.getRequestDispatcher("/Views/Auth.jsp").forward(request, response);
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
