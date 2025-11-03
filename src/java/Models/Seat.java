/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author USER
 */
public class Seat {
    private int seatId;
    private int auditoriumId;
    private String row;
    private int number;
    private String seatType;
    private boolean isActivate;
    private boolean isShowing;

    public Seat() {
    }

    public Seat(int seatId, int auditoriumId, String row, int number, String seatType, boolean isActivate, boolean isShowing) {
        this.seatId = seatId;
        this.auditoriumId = auditoriumId;
        this.row = row;
        this.number = number;
        this.seatType = seatType;
        this.isActivate = isActivate;
        this.isShowing = isShowing;
    }

    public boolean isIsShowing() {
        return isShowing;
    }

    public void setIsShowing(boolean isShowing) {
        this.isShowing = isShowing;
    }

    

    public int getSeatId() {
        return seatId;
    }

    public void setSeatId(int seatId) {
        this.seatId = seatId;
    }

    public int getAuditoriumId() {
        return auditoriumId;
    }

    public void setAuditoriumId(int auditoriumId) {
        this.auditoriumId = auditoriumId;
    }

    public String getRow() {
        return row;
    }

    public void setRow(String row) {
        this.row = row;
    }

    public int getNumber() {
        return number;
    }

    public void setNumber(int number) {
        this.number = number;
    }

    public String getSeatType() {
        return seatType;
    }

    public void setSeatType(String seatType) {
        this.seatType = seatType;
    }

    public boolean isIsActivate() {
        return isActivate;
    }

    public void setIsActivate(boolean isActivate) {
        this.isActivate = isActivate;
    }
    
}
