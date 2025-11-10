package Controllers.Util;

import jakarta.websocket.Session;
import javax.mail.*;
import javax.mail.internet.*;
import java.io.File;
import java.net.Authenticator;
import java.net.PasswordAuthentication;
import java.util.Properties;

/**
 * Tiện ích gửi email có đính kèm file QR Code.
 * Sử dụng Gmail SMTP với App Password.
 */
public class EmailUtil {

    // ⚙️ Gửi email có QR Code đính kèm
    public static void sendEmailWithQRCode(String to, String subject, String text, String filePath) throws MessagingException {
        final String from = "holacinema.center@gmail.com"; // Gmail gửi
        final String password = "rkeutwwwznvgkaqe"; // App Password Gmail (KHÔNG phải mật khẩu đăng nhập!)

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        //  Tạo session có xác thực
        javax.mail.Session session = javax.mail.Session.getDefaultInstance(props, new javax.mail.Authenticator() {
                protected javax.mail.PasswordAuthentication getPasswordAuthentication() {
                    return new javax.mail.PasswordAuthentication(from, password);
                }
            });

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(from, " HolaCinema Center"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            msg.setSubject(subject);

            // ️ Nội dung chính
            MimeBodyPart textPart = new MimeBodyPart();
            textPart.setText(text, "UTF-8");

            //  File QR đính kèm
            Multipart multipart = new MimeMultipart();
            multipart.addBodyPart(textPart);

            if (filePath != null && !filePath.isEmpty()) {
                File qrFile = new File(filePath);
                if (qrFile.exists()) {
                    MimeBodyPart attachmentPart = new MimeBodyPart();
                    attachmentPart.attachFile(qrFile);
                    multipart.addBodyPart(attachmentPart);
                } else {
                    System.out.println("⚠️ File QR không tồn tại: " + filePath);
                }
            }

            msg.setContent(multipart);

            //  Gửi mail
            Transport.send(msg);
            System.out.println(" Đã gửi email có QR tới: " + to);

        } catch (Exception e) {
            System.err.println(" Lỗi khi gửi email: " + e.getMessage());
            throw new MessagingException("Không thể gửi email tới " + to, e);
        }
    }
}
