/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author USER
 */
public class User {
    private int userId;
    private String email;
    private String password;
    private String name;
    private String phone;
    private Date dob;
    private boolean gender;
    private int role;
    private Date createAt;
    private Date updateAt;

    public User() {
    }

    public User(int userId, String email, String password, String name, String phone, Date dob, boolean gender, int role, Date createAt, Date updateAt) {
        this.userId = userId;
        this.email = email;
        this.password = password;
        this.name = name;
        this.phone = phone;
        this.dob = dob;
        this.gender = gender;
        this.role = role;
        this.createAt = createAt;
        this.updateAt = updateAt;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    
    public int getRole() {
        return role;
    }

    public void setRole(int role) {
        this.role = role;
    }

    

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public boolean isGender() {
        return gender;
    }

    public void setGender(boolean gender) {
        this.gender = gender;
    }

    public Date getCreateAt() {
        return createAt;
    }

    public void setCreateAt(Date createAt) {
        this.createAt = createAt;
    }

    public Date getUpdateAt() {
        return updateAt;
    }

    public void setUpdateAt(Date updateAt) {
        this.updateAt = updateAt;
    }
    
}
