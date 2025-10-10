/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.sql.Timestamp;
import java.time.LocalDate;

public class UserAccount {
    private int userId;
    private String email;
    private String passwordHash;
    private String name;
    private boolean status; // true = hoạt động, false = bị khóa
    private String phone;
    private LocalDate dob;
    private boolean gender; // true = male, false = female
    private int role;       // 0=admin, 1=manager, 2=customer
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Getters & Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public LocalDate getDob() { return dob; }
    public void setDob(LocalDate dob) { this.dob = dob; }

    public boolean isGender() { return gender; }
    public void setGender(boolean gender) { this.gender = gender; }

    public int getRole() { return role; }
    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }
    public void setRole(int role) { this.role = role; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
