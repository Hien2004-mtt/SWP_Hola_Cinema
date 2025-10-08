/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAL;

import java.sql.*;
import Models.Auditorium;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Admin
 */
public class AuditoriumDAO {

    public List<Auditorium> getAll() {
        List<Auditorium> list = new ArrayList<>();
        String sql = " SELECT * FROM Auditorium WHERE is_deleted = 0";
        try (PreparedStatement ps = DBContext.getConnection().prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Auditorium(
                        rs.getInt("auditorium_id"),
                        rs.getString("name"),
                        rs.getString("seat_layout_meta"),
                        rs.getBoolean("is_deleted")
                ));

            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insert(Auditorium au) {
        String sql = "INSERT INTO Auditorium"
                + "("
                + "name,"
                + "seat_layout_meta,"
                + "is_deleted,"
                + ")";
        try (PreparedStatement ps = DBContext.getConnection().prepareStatement(sql)) {
            ps.setString(1, au.getName());
            ps.setString(2, au.getSeatLayoutMeta());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update(Auditorium au) {
        String sql = "UPDATE AUDITORIUM SET "
                + "name = ?,"
                + "seat_meta_layout = ?,"
                + "is_deleted = ?"
                + "WHERE auditorium_id = ?";
        try (PreparedStatement ps = DBContext.getConnection().prepareStatement(sql)) {
            ps.setString(1, au.getName());
            ps.setString(2,au.getSeatLayoutMeta());
            ps.setBoolean(3, au.isIsDeleted());
            ps.setInt(4, au.getAuditoriumId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
    public void delete(int id){
        String sql ="UPDATE Auditorium SET is_deleted = 1 WHERE auditorium_id= ?";
        try(PreparedStatement ps = DBContext.getConnection().prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
