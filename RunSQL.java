import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.nio.file.Files;
import java.nio.file.Paths;

public class RunSQL {
    public static void main(String[] args) {
        String url = "jdbc:sqlserver://localhost:1433;databaseName=SchoolBusDB;encrypt=false";
        String user = "sa";
        String password = "123";

        try {
            Connection conn = DriverManager.getConnection(url, user, password);
            Statement stmt = conn.createStatement();
            
            // Cannot run GO inside JDBC executeUpdate easily, so we split the script
            String sql1 = "IF OBJECT_ID('TechnicianSchedules', 'U') IS NOT NULL DROP TABLE TechnicianSchedules;";
            String sql2 = "CREATE TABLE TechnicianSchedules (" +
                          "TechScheduleID INT IDENTITY(1,1) PRIMARY KEY," +
                          "TechnicianID INT FOREIGN KEY REFERENCES Users(UserID)," +
                          "Date DATE NOT NULL," +
                          "CreatedAt DATETIME DEFAULT GETDATE()," +
                          "UNIQUE (TechnicianID, Date)" +
                          ");";
            
            stmt.executeUpdate(sql1);
            stmt.executeUpdate(sql2);
            
            System.out.println("TechnicianSchedules table created successfully.");
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
