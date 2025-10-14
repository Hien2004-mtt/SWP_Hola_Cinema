package Models;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Booking {

    private int bookingId;
    private int userId;
    private int showtimeId;
    private Integer voucherId; // nullable
    private String status; // 'cancelled', 'confirmed', 'pending'
    private BigDecimal totalPrice;
    private Timestamp createdAt;
    private Timestamp expiresAt;

    public Booking() {
    }

    public Booking(int userId, int showtimeId, Integer voucherId, String status, BigDecimal totalPrice) {
        this.userId = userId;
        this.showtimeId = showtimeId;
        this.voucherId = voucherId;
        this.status = status;
        this.totalPrice = totalPrice;
    }

    public Booking(int userId, int showtimeId, Integer voucherId, String status, BigDecimal totalPrice, Timestamp expiresAt) {
        this.userId = userId;
        this.showtimeId = showtimeId;
        this.voucherId = voucherId;
        this.status = status;
        this.totalPrice = totalPrice;
        this.expiresAt = expiresAt;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getShowtimeId() {
        return showtimeId;
    }

    public void setShowtimeId(int showtimeId) {
        this.showtimeId = showtimeId;
    }

    public Integer getVoucherId() {
        return voucherId;
    }

    public void setVoucherId(Integer voucherId) {
        this.voucherId = voucherId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Timestamp expiresAt) {
        this.expiresAt = expiresAt;
    }

    // Status constants for better code maintainability
    public static final String STATUS_PENDING = "pending";
    public static final String STATUS_CONFIRMED = "confirmed";
    public static final String STATUS_CANCELLED = "cancelled";

    // Helper methods for status validation
    public boolean isPending() {
        return STATUS_PENDING.equals(this.status);
    }

    public boolean isConfirmed() {
        return STATUS_CONFIRMED.equals(this.status);
    }

    public boolean isCancelled() {
        return STATUS_CANCELLED.equals(this.status);
    }

    // Helper method to check if booking is expired
    public boolean isExpired() {
        if (expiresAt == null) {
            return false;
        }
        return new Timestamp(System.currentTimeMillis()).after(expiresAt);
    }

    @Override
    public String toString() {
        return "Booking{" +
                "bookingId=" + bookingId +
                ", userId=" + userId +
                ", showtimeId=" + showtimeId +
                ", voucherId=" + voucherId +
                ", status='" + status + '\'' +
                ", totalPrice=" + totalPrice +
                ", createdAt=" + createdAt +
                ", expiresAt=" + expiresAt +
                '}';
    }
}