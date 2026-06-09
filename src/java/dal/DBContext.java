package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    protected Connection connection;

    public DBContext() {
        try {
            // Thay đổi username và password nếu môi trường SQL Server của bạn khác
            String url = "jdbc:sqlserver://localhost:1433;databaseName=SchoolBusDB;encrypt=true;trustServerCertificate=true;";
            String username = "sa";
            String password = "123"; // Mật khẩu thường dùng, bạn hãy sửa lại nếu cần
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException | SQLException ex) {
            System.out.println(ex);
        }
    }
}
