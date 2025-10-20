package Models;

import java.util.Date;

public class BookingItem {

    private int bookingItemId;
    private int bookingId;
    private int seatId;
    private double price;
    private String seatType;
    private Date createdAt;

    public BookingItem() {
    }

    public BookingItem(int bookingItemId, int bookingId, int seatId, double price, String seatType, Date createdAt) {
        this.bookingItemId = bookingItemId;
        this.bookingId = bookingId;
        this.seatId = seatId;
        this.price = price;
        this.seatType = seatType;
        this.createdAt = createdAt;
    }

    public int getBookingItemId() {
        return bookingItemId;
    }

    public void setBookingItemId(int bookingItemId) {
        this.bookingItemId = bookingItemId;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public int getSeatId() {
        return seatId;
    }

    public void setSeatId(int seatId) {
        this.seatId = seatId;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getSeatType() {
        return seatType;
    }

    public void setSeatType(String seatType) {
        this.seatType = seatType;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}
