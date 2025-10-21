package Models;

import java.util.Date;

public class Payment {
    private int paymentId;
    private int bookingId;
    private double amount;
     private String method;
    private String transactionRef;
    private String status;
    private Date paidAt;
    private String qrCodeUrl;

    public Payment() {}

    public Payment(int bookingId, double amount, String method, String transactionRef,
                   String status, Date paidAt, String qrCodeUrl) {
        this.bookingId = bookingId;
        this.amount = amount;
        this.method = method;
        this.transactionRef = transactionRef;
        this.status = status;
        this.paidAt = paidAt;
        this.qrCodeUrl = qrCodeUrl;
    }

    // Getters & setters
    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    

    

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    

    public String getTransactionRef() { return transactionRef; }
    public void setTransactionRef(String transactionRef) { this.transactionRef = transactionRef; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Date getPaidAt() { return paidAt; }
    public void setPaidAt(Date paidAt) { this.paidAt = paidAt; }

    public String getQrCodeUrl() { return qrCodeUrl; }
    public void setQrCodeUrl(String qrCodeUrl) { this.qrCodeUrl = qrCodeUrl; }
}
