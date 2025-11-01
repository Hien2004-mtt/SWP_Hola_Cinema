package Models;

import java.sql.Date;

public class Actor {

    // ======== CÁC THUỘC TÍNH CHÍNH (từ bảng Actor) ========
    private int actorId;
    private String name;
    private String bio;
    private Date dob;
    private String photoUrl;

    // ======== THUỘC TÍNH MỞ RỘNG (JOIN Movie_Actor) ========
    private String roleName; // vai diễn của diễn viên trong phim cụ thể

    // ======== CONSTRUCTOR ========
    public Actor() {
    }

    public Actor(int actorId, String name, String bio, Date dob, String photoUrl) {
        this.actorId = actorId;
        this.name = name;
        this.bio = bio;
        this.dob = dob;
        this.photoUrl = photoUrl;
    }

    // ======== GETTER & SETTER ========

    public int getActorId() {
        return actorId;
    }

    public void setActorId(int actorId) {
        this.actorId = actorId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public String getPhotoUrl() {
        return photoUrl;
    }

    public void setPhotoUrl(String photoUrl) {
        this.photoUrl = photoUrl;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    // ======== TO STRING ========

    @Override
    public String toString() {
        return "Actor{" +
                "actorId=" + actorId +
                ", name='" + name + '\'' +
                ", dob=" + dob +
                ", roleName='" + roleName + '\'' +
                '}';
    }
}
