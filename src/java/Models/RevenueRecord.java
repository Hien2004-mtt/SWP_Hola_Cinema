package Models;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class RevenueRecord {

    private String movieTitle;
    private int totalTickets;
    private BigDecimal totalRevenue;
    private Timestamp paidAt;

    public RevenueRecord() {
    }

    public RevenueRecord(String movieTitle, int totalTickets, BigDecimal totalRevenue, Timestamp paidAt) {
        this.movieTitle = movieTitle;
        this.totalTickets = totalTickets;
        this.totalRevenue = totalRevenue;
        this.paidAt = paidAt;
    }

    public String getMovieTitle() {
        return movieTitle;
    }

    public void setMovieTitle(String movieTitle) {
        this.movieTitle = movieTitle;
    }

    public int getTotalTickets() {
        return totalTickets;
    }

    public void setTotalTickets(int totalTickets) {
        this.totalTickets = totalTickets;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public Timestamp getPaidAt() {
        return paidAt;
    }

    public void setPaidAt(Timestamp paidAt) {
        this.paidAt = paidAt;
    }
}
