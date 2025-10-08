/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author Admin
 */
public class Auditorium {
    private int auditoriumId;
    private String name;
    private String seatLayoutMeta;
    private boolean isDeleted; //1 da bi xoa ---- 0 chua bi xoa

    public Auditorium() {
    }

    public Auditorium(int auditoriumId, String name, String seatLayoutMeta, boolean isDeleted) {
        this.auditoriumId = auditoriumId;
        this.name = name;
        this.seatLayoutMeta = seatLayoutMeta;
        this.isDeleted = isDeleted;
    }

    public boolean isIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(boolean deleted) {
        this.isDeleted = deleted;
    }
   
    public int getAuditoriumId() {
        return auditoriumId;
    }

    public void setAuditoriumId(int auditoriumId) {
        this.auditoriumId = auditoriumId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSeatLayoutMeta() {
        return seatLayoutMeta;
    }

    public void setSeatLayoutMeta(String seatLayoutMeta) {
        this.seatLayoutMeta = seatLayoutMeta;
    }
    
           
}
