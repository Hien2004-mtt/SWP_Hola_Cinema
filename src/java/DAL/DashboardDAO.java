package DAL;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DashboardDAO {

    public double getTotalRevenue() {
        String sql = "SELECT SUM(amount) AS total_revenue FROM Payment WHERE status = 'PAID'";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getDouble("total_revenue");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTicketsSold() {
        String sql = "SELECT COUNT(*) AS tickets_sold FROM BookingItem";
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("tickets_sold");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getTotalCustomers() {
        String sql = "SELECT COUNT(*) AS total_customers FROM Users WHERE role = 2"; 
        try (Connection con = DBContext.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("total_customers");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}
