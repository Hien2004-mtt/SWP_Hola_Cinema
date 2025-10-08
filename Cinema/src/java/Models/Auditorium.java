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

    public Auditorium() {
    }

    public Auditorium(int auditoriumId, String name, String seatLayoutMeta) {
        this.auditoriumId = auditoriumId;
        this.name = name;
        this.seatLayoutMeta = seatLayoutMeta;
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
