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
    private int totalSeat;
    private boolean isDeleted; //1 da bi xoa ---- 0 chua bi xoa
    private String description;

    public Auditorium() {
    }

  
    public Auditorium(int auditoriumId, String name, int totalSeat, boolean isDeleted, String description) {
        this.auditoriumId = auditoriumId;
        this.name = name;
        this.totalSeat = totalSeat;
        this.isDeleted = isDeleted;
        this.description = description;
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

    public int getTotalSeat() {
        return totalSeat;
    }

    public void setTotalSeat(int totalSeat) {
        this.totalSeat = totalSeat;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

   
    
           
}
