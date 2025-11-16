/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAL;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author dinhh
 */
public class DBContext {
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=cinema;encrypt=false";
    private static final String USER = "sa";     // thay bằng username của bạn
    private static final String PASS = "123"; // thay bằng password của bạn

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(" Không tìm thấy SQLServer JDBC Driver", e);
        }
        return DriverManager.getConnection(URL, USER, PASS);
    }
}


