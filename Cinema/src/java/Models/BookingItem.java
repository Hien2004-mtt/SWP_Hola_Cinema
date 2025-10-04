/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author Admin
 */
public class BookingItem {
    private int bookingItemId;
    private int bookingId;
    private int showtimeId;
    private int seat_id;
    private double price;
    private String ticketType;

    public BookingItem() {
    }

    public BookingItem(int bookingItemId, int bookingId, int showtimeId, int seat_id, double price, String ticketType) {
        this.bookingItemId = bookingItemId;
        this.bookingId = bookingId;
        this.showtimeId = showtimeId;
        this.seat_id = seat_id;
        this.price = price;
        this.ticketType = ticketType;
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

    public int getShowtimeId() {
        return showtimeId;
    }

    public void setShowtimeId(int showtimeId) {
        this.showtimeId = showtimeId;
    }

    public int getSeat_id() {
        return seat_id;
    }

    public void setSeat_id(int seat_id) {
        this.seat_id = seat_id;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getTicketType() {
        return ticketType;
    }

    public void setTicketType(String ticketType) {
        this.ticketType = ticketType;
    }
    
}
