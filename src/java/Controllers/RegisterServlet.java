package Controllers;

import DAL.UserDAO;
import Models.User;
import Util.PasswordUtil;
import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/Views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String dobStr = request.getParameter("dob");
        String genderStr = request.getParameter("gender");

        Map<String, String> errors = new HashMap<>();

        // Validate all fields - Server-side validation (cannot be bypassed)
        if (email == null || email.trim().isEmpty()) {
            errors.put("email", "Email cannot be empty!");
        } else if (!email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            errors.put("email", "Invalid email format!");
        }

        if (password == null || password.trim().isEmpty()) {
            errors.put("password", "Password cannot be empty!");
        } else {
            String passwordError = PasswordUtil.getPasswordValidationError(password);
            if (passwordError != null) {
                errors.put("password", passwordError);
            }
        }

        if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
            errors.put("confirmPassword", "Please confirm your password!");
        } else if (!confirmPassword.equals(password)) {
            errors.put("confirmPassword", "Password confirmation does not match!");
        }

        if (name == null || name.trim().isEmpty()) {
            errors.put("name", "Full name cannot be empty!");
        } else if (name.length() < 2) {
            errors.put("name", "Full name must be at least 2 characters!");
        } else if (!name.matches("^[\\p{L} ]+$")) {
            errors.put("name", "Full name can only contain letters and spaces!");
        }

        if (phone == null || phone.trim().isEmpty()) {
            errors.put("phone", "Phone number cannot be empty!");
        } else if (!phone.matches("^0[0-9]{9,10}$")) {
            errors.put("phone", "Phone number must start with 0 and have 10-11 digits!");
        }

        if (dobStr == null || dobStr.trim().isEmpty()) {
            errors.put("dob", "Date of birth cannot be empty!");
        } else {
            try {
                Date dob = Date.valueOf(dobStr);
                // Check if date is in the future
                Date today = new Date(System.currentTimeMillis());
                if (dob.after(today)) {
                    errors.put("dob", "Date of birth cannot be in the future!");
                }
            } catch (IllegalArgumentException e) {
                errors.put("dob", "Invalid date of birth!");
            }
        }

        if (genderStr == null || genderStr.trim().isEmpty()) {
            errors.put("gender", "Please select gender!");
        }

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("email", email);
            request.setAttribute("name", name);
            request.setAttribute("phone", phone);
            request.setAttribute("dob", dobStr);
            request.setAttribute("gender", genderStr);
            request.getRequestDispatcher("/Views/register.jsp").forward(request, response);
            return;
        }

        try {
            // Check email exists
            User existingUser = userDAO.login(email, "");
            if (existingUser != null) {
                errors.put("email", "Email is already in use!");
                request.setAttribute("errors", errors);
                request.setAttribute("email", email);
                request.setAttribute("name", name);
                request.setAttribute("phone", phone);
                request.setAttribute("dob", dobStr);
                request.setAttribute("gender", genderStr);
                request.getRequestDispatcher("/Views/register.jsp").forward(request, response);
                return;
            }

            // Hash password with BCrypt before storing
            String passwordHash = PasswordUtil.hashPassword(password);

            // Parse date
            java.sql.Date dob = (dobStr != null && !dobStr.trim().isEmpty()) ? Date.valueOf(dobStr) : null;
            boolean gender = (genderStr != null && genderStr.equals("1")) ? true : false;

            // Register user with default role 2 (customer)
            boolean success = userDAO.registerUser(email, passwordHash, name, phone, dob, gender);
            if (success) {
                request.setAttribute("message", "Registration successful! Please login.");
                request.getRequestDispatcher("/Views/login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Registration failed. Please try again!");
                request.getRequestDispatcher("/Views/register.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/Views/register.jsp").forward(request, response);
        }
    }
}
