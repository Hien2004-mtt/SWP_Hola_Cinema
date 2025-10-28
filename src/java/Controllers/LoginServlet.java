/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controllers;

import DAL.UserDAO;
import Models.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author Acer
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO(); // Initialize UserDAO
    }

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

    }

 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/Views/login.jsp").forward(request, response);
    }

 
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Validate input
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Please enter your email and password!");
            request.getRequestDispatcher("/Views/login.jsp").forward(request, response);
            return;
        }

        try {
            // Authenticate user
            User user = userDAO.login(email, password);
            if (user != null) {
                // Login successful, store user in session
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("role", user.getRole());
                // Redirect based on role
                switch (user.getRole()) {
                    case 0: // Admin
                        response.sendRedirect("admin-home");
                        break;
                    case 1: // Staff
                        response.sendRedirect("staff-home");
                        break;
                    case 2: // Customer
                        response.sendRedirect("home");
                        break;
                    default:
                        response.sendRedirect("home");
                }
            } else {
                // Login failed
                request.setAttribute("error", "Incorrect email or password!");
                request.getRequestDispatcher("/Views/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "An error has occurred: " + e.getMessage());
            request.getRequestDispatcher("/Views/login.jsp").forward(request, response);
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
