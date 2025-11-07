package Util;

import java.io.IOException;
import java.util.Properties;
import java.util.Random;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class ForgotPassword
 */
@WebServlet("/forgotPassword")
public class ForgotPassword extends HttpServlet {

<<<<<<< HEAD
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
=======
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("forgotPassword.jsp");
        dispatcher.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
>>>>>>> origin/Nguyễn-Quang-Huy

        String email = request.getParameter("email");
        RequestDispatcher dispatcher = null;
        HttpSession mySession = request.getSession();

        if (email != null && !email.equals("")) {
            // Generate 6-digit OTP
            Random rand = new Random();
            int otpvalue = 100000 + rand.nextInt(900000);

            // Set up mail properties
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.socketFactory.port", "465");
            props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.port", "465");

            // Replace with your app-specific password stored securely
            final String senderEmail = "hienmtthe180121@fpt.edu.vn";
            final String senderPassword = "your_app_password_here";

            Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(senderEmail, senderPassword);
                }
            });

            try {
                // Compose the message
                MimeMessage message = new MimeMessage(session);
                message.setFrom(new InternetAddress(senderEmail, "Cinema Service Management"));
                message.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
                message.setSubject("HOLA Cinema Service - One-Time Password (OTP) Verification");

                String content = "Dear Valued Customer,\n\n"
                        + "To proceed with your request on our Cinema Service, please use the following One-Time Password (OTP):\n\n"
                        + otpvalue + "\n\n"
                        + "⚠️ Please do not share this code with anyone. "
                        + "This OTP is valid for a limited time and can only be used once.\n\n"
                        + "Thank you for choosing our service.\n\n"
                        + "Best regards,\n"
                        + "Cinema Service Management Team";

                message.setText(content);

                Transport.send(message);
                System.out.println("OTP email sent successfully to " + email);

                // Set attributes and forward
                mySession.setAttribute("otp", otpvalue);
                mySession.setAttribute("email", email);
                request.setAttribute("message", "OTP has been sent to your email.");
                dispatcher = request.getRequestDispatcher("EnterOtp.jsp");
                dispatcher.forward(request, response);

            } catch (MessagingException e) {
                e.printStackTrace();
                throw new RuntimeException("Error while sending OTP email: " + e.getMessage());
            }
        } else {
            request.setAttribute("error", "Invalid email address.");
            dispatcher = request.getRequestDispatcher("forgotPassword.jsp");
            dispatcher.forward(request, response);
        }
    }
}
