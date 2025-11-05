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
                        rs.getInt("total_seat"),
                        rs.getBoolean("is_deleted"),
                        rs.getString("description ")
                ));
            }
            System.out.println("Load " + list.size() + " phòng chiếu.");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
     public List<Auditorium> getAllForManager() {
        List<Auditorium> list = new ArrayList<>();
        String sql = "SELECT * FROM Auditorium";
        try (PreparedStatement ps = DBContext.getConnection().prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new Auditorium(
                        rs.getInt("auditorium_id"),
                        rs.getString("name"),
                        rs.getInt("total_seat"),
                        rs.getBoolean("is_deleted"),
                        rs.getString("description")
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
                            rs.getInt("total_seat"),
                            rs.getBoolean("is_deleted"),
                            rs.getString("description")
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
        String sql = "INSERT INTO Auditorium (name,total_seat,is_deleted,description) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = DBContext.getConnection().prepareStatement(sql)) {
            ps.setString(1, au.getName());
            ps.setInt(2,au.getTotalSeat());
            ps.setBoolean(3, au.isIsDeleted());
            ps.setString(4, au.getDescription());
            ps.executeUpdate();
            System.out.println("Thêm phòng chiếu thành công!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void update(Auditorium au) {
        String sql = "UPDATE Auditorium SET "
                + "name = ?, "
                + "total_seat = ?, "
                + "is_deleted = ?,"
                + "description = ? "
                + "WHERE auditorium_id = ?";
        try (PreparedStatement ps = DBContext.getConnection().prepareStatement(sql)) {
            ps.setString(1, au.getName());
            ps.setInt(2, au.getTotalSeat());
            ps.setBoolean(3, au.isIsDeleted());
            ps.setString(4, au.getDescription());
            ps.setInt(5, au.getAuditoriumId());
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
    public boolean restoreAuditorium(int id){
        String sql = "UPDATE Auditorium SET is_deleted = 0 WHERE auditorium_id=?";
        try(PreparedStatement ps = DBContext.getConnection().prepareStatement(sql);){
           ps.setInt(1, id);
            int t = ps.executeUpdate();
            return t >0;
        }catch(Exception e){
            e.printStackTrace();
            return false;
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
                            rs.getInt("total_seat"),
                            rs.getBoolean("is_deleted"),
                            rs.getString("description")
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
    public int countAuditoriums() {
    String sql = "SELECT COUNT(*) FROM Auditorium";
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) return rs.getInt(1);
    } catch (Exception e) {
        e.printStackTrace();
    }
    return 0;
}

public List<Auditorium> getAuditoriumsByPage(int page, int pageSize) {
    List<Auditorium> list = new ArrayList<>();
    String sql = """
        SELECT * FROM Auditorium
        ORDER BY auditorium_id
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """;
    try (Connection conn = DBContext.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, (page - 1) * pageSize);
        ps.setInt(2, pageSize);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Auditorium a = new Auditorium();
            a.setAuditoriumId(rs.getInt("auditorium_id"));
            a.setName(rs.getString("name"));
            a.setTotalSeat(rs.getInt("total_seat"));
            a.setDescription(rs.getString("description"));
            a.setIsDeleted(rs.getBoolean("is_deleted"));
            list.add(a);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

        

}
