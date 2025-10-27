package DAL;

import java.sql.*;
import Models.Auditorium;
import java.util.ArrayList;
import java.util.List;

public class AuditoriumDAO {

    public List<Auditorium> getAll() {
        List<Auditorium> list = new ArrayList<>();
        String sql = "SELECT * FROM Auditorium WHERE is_deleted = 0";
        try (PreparedStatement ps = DBContext.getConnection().prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new Auditorium(
                        rs.getInt("auditorium_id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getBoolean("is_deleted")
                ));
            }
            System.out.println("Load " + list.size() + " phòng chiếu.");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Auditorium> search(String keyword) {
        List<Auditorium> list = new ArrayList<>();
        String sql = "SELECT * FROM Auditorium WHERE is_deleted = 0 AND (name LIKE ? OR CAST(auditorium_id AS VARCHAR(20)) LIKE ?)";
        try (PreparedStatement ps = DBContext.getConnection().prepareStatement(sql)) {
            String like = "%" + keyword + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Auditorium(
                            rs.getInt("auditorium_id"),
                            rs.getString("name"),
                            rs.getString("description"),
                            rs.getBoolean("is_deleted")
                    ));
                }
            }
            System.out.println("Search auditorium with keyword='" + keyword + "', found " + list.size() + " rows.");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insert(Auditorium au) {
        String sql = "INSERT INTO Auditorium (name, description, is_deleted) VALUES (?, ?, ?)";
        try (PreparedStatement ps = DBContext.getConnection().prepareStatement(sql)) {
            ps.setString(1, au.getName());
            ps.setString(2, au.getSeatLayoutMeta());
            ps.setBoolean(3, au.isIsDeleted());
            ps.executeUpdate();
            System.out.println("Thêm phòng chiếu thành công!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update(Auditorium au) {
        String sql = "UPDATE Auditorium SET "
                + "name = ?, "
                + "description = ?, "
                + "is_deleted = ? "
                + "WHERE auditorium_id = ?";
        try (PreparedStatement ps = DBContext.getConnection().prepareStatement(sql)) {
            ps.setString(1, au.getName());
            ps.setString(2, au.getSeatLayoutMeta());
            ps.setBoolean(3, au.isIsDeleted());
            ps.setInt(4, au.getAuditoriumId());
            ps.executeUpdate();
            System.out.println("Cập nhật phòng chiếu thành công!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void delete(int id) {
        String sql = "UPDATE Auditorium SET is_deleted = 1 WHERE auditorium_id = ?";
        try (PreparedStatement ps = DBContext.getConnection().prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
            System.out.println("Đã xoá mềm phòng chiếu ID = " + id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Auditorium getById(int id) {
        String sql = "SELECT * FROM Auditorium WHERE auditorium_id = ?";
        try (PreparedStatement ps = DBContext.getConnection().prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Auditorium(
                            rs.getInt("auditorium_id"),
                            rs.getString("name"),
                            rs.getString("description"),
                            rs.getBoolean("is_deleted")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String getAuditoriumNameById(int auditoriumId) {
        String sql = "SELECT name FROM Auditorium WHERE auditorium_id = ?";
        try (Connection con = DBContext.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, auditoriumId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("name");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return "Không rõ phòng chiếu";
    }

}
