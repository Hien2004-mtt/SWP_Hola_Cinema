/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.util.Date;

/**
 *
 * @author USER
 */
public class Booking {
    private int bookingId;
    private int userId;
    private int showtimeId;
    private String status;
    private Double totalPrice;
    private Date createdAt;
    private Date expiresAt;

    public Booking() {
    }

    public Booking(int bookingId, int userId, int showtimeId, String status, Double totalPrice, Date createdAt, Date expiresAt) {
        this.bookingId = bookingId;
        this.userId = userId;
        this.showtimeId = showtimeId;
        this.status = status;
        this.totalPrice = totalPrice;
        this.createdAt = createdAt;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(Double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(Date expiresAt) {
        this.expiresAt = expiresAt;
    }
    
}
