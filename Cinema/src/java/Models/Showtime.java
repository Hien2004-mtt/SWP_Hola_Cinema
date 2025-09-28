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
public class Showtime {
    private int showtimeId;
    private int movieId;
    private int auditoriumId;
    private Date startTime;
    private Date endTime;
    private Double basePrice;

    public Showtime() {
    }

    public Showtime(int showtimeId, int movieId, int auditoriumId, Date startTime, Date endTime, Double basePrice) {
        this.showtimeId = showtimeId;
        this.movieId = movieId;
        this.auditoriumId = auditoriumId;
        this.startTime = startTime;
        this.endTime = endTime;
        this.basePrice = basePrice;
    }

    public int getShowtimeId() {
        return showtimeId;
    }

    public void setShowtimeId(int showtimeId) {
        this.showtimeId = showtimeId;
    }

    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
        this.movieId = movieId;
    }

    public int getAuditoriumId() {
        return auditoriumId;
    }

    public void setAuditoriumId(int auditoriumId) {
        this.auditoriumId = auditoriumId;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }

    public Double getBasePrice() {
        return basePrice;
    }

    public void setBasePrice(Double basePrice) {
        this.basePrice = basePrice;
    }
    
    
}
