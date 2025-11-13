/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.sql.Timestamp;

public class ShowtimeSchedule {
    private int showtimeId;
    private int movieId;
    private String movieName;
    private int auditoriumId;
    private String auditoriumName;
    private Timestamp startTime;
    private Timestamp endTime;
    private double price;
    private String status; // 'active', 'cancelled', 'completed'
    private boolean isActive; // new column mapping for DB: is_active (1 = active, 0 = inactive/cancelled)

    public ShowtimeSchedule(int showtimeId, int movieId, String movieName, int auditoriumId, String auditoriumName,
                           Timestamp startTime, Timestamp endTime, double price) {
        this.showtimeId = showtimeId;
        this.movieId = movieId;
        this.movieName = movieName;
        this.auditoriumId = auditoriumId;
        this.auditoriumName = auditoriumName;
        this.startTime = startTime;
        this.endTime = endTime;
        this.price = price;
        this.status = "active"; // Mặc định là active
        this.isActive = true;
        refreshStatusFromState();
    }
    
    // Constructor với status
    public ShowtimeSchedule(int showtimeId, int movieId, String movieName, int auditoriumId, String auditoriumName,
                           Timestamp startTime, Timestamp endTime, double price, String status) {
        this.showtimeId = showtimeId;
        this.movieId = movieId;
        this.movieName = movieName;
        this.auditoriumId = auditoriumId;
        this.auditoriumName = auditoriumName;
        this.startTime = startTime;
        this.endTime = endTime;
        this.price = price;
        this.status = status;
        // derive isActive from status for backward compatibility
        this.isActive = "active".equalsIgnoreCase(status);
        refreshStatusFromState();
    }

    // New constructor that accepts isActive directly (for DB is_active boolean)
    public ShowtimeSchedule(int showtimeId, int movieId, String movieName, int auditoriumId, String auditoriumName,
                           Timestamp startTime, Timestamp endTime, double price, boolean isActive) {
        this.showtimeId = showtimeId;
        this.movieId = movieId;
        this.movieName = movieName;
        this.auditoriumId = auditoriumId;
        this.auditoriumName = auditoriumName;
        this.startTime = startTime;
        this.endTime = endTime;
        this.price = price;
        this.isActive = isActive;
        this.status = isActive ? "active" : "cancelled";
        refreshStatusFromState();
    }

    // Getter và Setter
    public int getShowtimeId() { return showtimeId; }
    public void setShowtimeId(int showtimeId) { this.showtimeId = showtimeId; }
    public int getMovieId() { return movieId; }
    public void setMovieId(int movieId) { this.movieId = movieId; }
    public String getMovieName() { return movieName; }
    public void setMovieName(String movieName) { this.movieName = movieName; }
    public int getAuditoriumId() { return auditoriumId; }
    public void setAuditoriumId(int auditoriumId) { this.auditoriumId = auditoriumId; }
    public String getAuditoriumName() { return auditoriumName; }
    public void setAuditoriumName(String auditoriumName) { this.auditoriumName = auditoriumName; }
    public Timestamp getStartTime() { return startTime; }
    public void setStartTime(Timestamp startTime) { this.startTime = startTime; }
    public Timestamp getEndTime() { return endTime; }
    public void setEndTime(Timestamp endTime) { 
        this.endTime = endTime; 
        refreshStatusFromState();
    }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public String getStatus() { return status; }
    public void setStatus(String status) { 
        this.status = status; 
        if ("active".equalsIgnoreCase(status)) {
            this.isActive = true;
        } else if ("cancelled".equalsIgnoreCase(status) || "completed".equalsIgnoreCase(status)) {
            this.isActive = false;
        }
    }

    public boolean isIsActive() { return isActive; }
    public boolean getIsActive() { return isActive; }
    public void setIsActive(boolean isActive) { 
        this.isActive = isActive; 
        // keep status string in sync for views that still use it
        this.status = isActive ? "active" : "cancelled";
        refreshStatusFromState();
    }

    private void refreshStatusFromState() {
        Timestamp now = new Timestamp(System.currentTimeMillis());
        if (endTime != null && endTime.before(now)) {
            this.status = "completed";
            this.isActive = false;
        } else {
            this.status = isActive ? "active" : "cancelled";
        }
    }
}
