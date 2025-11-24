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
import jakarta.servlet.http.HttpSession;

/**
 * Servlet to handle user profile update
 * @author Acer
 */
@WebServlet(name = "UpdateProfileServlet", urlPatterns = {"/updateProfile"})
public class UpdateProfileServlet1 extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO(); // Initialize UserDAO
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        // Forward to update profile page with current user info
        User user = (User) session.getAttribute("user");
        request.setAttribute("user", user);
        request.getRequestDispatcher("/Views/updateProfile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Check if user is logged in
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User currentUser = (User) session.getAttribute("user");
        String email = currentUser.getEmail(); // Email not updatable, use from session

        // Get form parameters
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String dobStr = request.getParameter("dob");
        String genderStr = request.getParameter("gender");

        // Password change parameters
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");

        // Map to store validation errors
        Map<String, String> errors = new HashMap<>();

        // Validate password change (if user wants to change password)
        boolean changePassword = false;
        if ((currentPassword != null && !currentPassword.trim().isEmpty()) ||
            (newPassword != null && !newPassword.trim().isEmpty()) ||
            (confirmNewPassword != null && !confirmNewPassword.trim().isEmpty())) {

            changePassword = true;

            // All password fields must be filled
            if (currentPassword == null || currentPassword.trim().isEmpty()) {
                errors.put("currentPassword", "Please enter your current password!");
            } else {
                // Verify current password
                if (!PasswordUtil.verifyPassword(currentPassword, currentUser.getPasswordHash())) {
                    errors.put("currentPassword", "Current password is incorrect!");
                }
            }

            if (newPassword == null || newPassword.trim().isEmpty()) {
                errors.put("newPassword", "Please enter a new password!");
            } else {
                String passwordError = PasswordUtil.getPasswordValidationError(newPassword);
                if (passwordError != null) {
                    errors.put("newPassword", passwordError);
                }
            }

            if (confirmNewPassword == null || confirmNewPassword.trim().isEmpty()) {
                errors.put("confirmNewPassword", "Please confirm your new password!");
            } else if (!confirmNewPassword.equals(newPassword)) {
                errors.put("confirmNewPassword", "Password confirmation does not match!");
            }
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

        // If there are validation errors, return to form with errors
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("name", name);
            request.setAttribute("phone", phone);
            request.setAttribute("dob", dobStr);
            request.setAttribute("gender", genderStr);
            request.setAttribute("user", currentUser);
            request.getRequestDispatcher("/Views/updateProfile.jsp").forward(request, response);
            return;
        }

        try {
            // Parse date and gender
            java.sql.Date dob = (dobStr != null && !dobStr.trim().isEmpty()) ? Date.valueOf(dobStr) : null;
            boolean gender = (genderStr != null && genderStr.equals("1")) ? true : false;

            // Determine password hash to use
            String passwordHash = currentUser.getPasswordHash(); // Keep current by default

            if (changePassword && errors.isEmpty()) {
                // Hash the new password with BCrypt
                passwordHash = PasswordUtil.hashPassword(newPassword);
            }

            // Update user profile (role not updated)
            boolean success = userDAO.updateProfile(email, passwordHash, name, phone, dob, gender);
            if (success) {
                // Update session with new info
                User updatedUser = userDAO.getUserByEmail(email);
                session.setAttribute("user", updatedUser);

                String successMsg = changePassword ?
                    "Profile and password updated successfully!" :
                    "Profile updated successfully!";
                request.setAttribute("successMessage", successMsg);
                request.setAttribute("user", updatedUser);
                request.getRequestDispatcher("/Views/updateProfile.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Profile update failed. Please try again!");
                request.setAttribute("user", currentUser);
                request.getRequestDispatcher("/Views/updateProfile.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.setAttribute("user", currentUser);
            request.getRequestDispatcher("/Views/updateProfile.jsp").forward(request, response);
        }
    }
}