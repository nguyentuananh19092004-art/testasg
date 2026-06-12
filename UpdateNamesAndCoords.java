import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class UpdateNamesAndCoords {
    public static void main(String[] args) {
        String url = "jdbc:sqlserver://localhost:1433;databaseName=SchoolBusDB;encrypt=true;trustServerCertificate=true;";
        String username = "sa";
        String password = "123";

        String[] updates = {
            // Update Stop 22 (ICID Complex)
            "UPDATE Stops SET StopName = 'ICID Complex', Latitude = 20.9826949, Longitude = 105.7428937 WHERE StopID = 22;",
            
            // Update Stop 25 (I2 SmartCity)
            "UPDATE Stops SET StopName = 'I2 Smart City', Latitude = 20.9995848, Longitude = 105.7398698 WHERE StopID = 25;",
            
            // Update Stop 26 (Mỹ Đình Pearl)
            "UPDATE Stops SET Latitude = 21.0066249, Longitude = 105.7688810 WHERE StopID = 26;",
            
            // Update Stop 27 (Matrix One)
            "UPDATE Stops SET Latitude = 21.0095436, Longitude = 105.7739969 WHERE StopID = 27;"
        };

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            try (Connection conn = DriverManager.getConnection(url, username, password)) {
                int totalUpdates = 0;
                for (String sql : updates) {
                    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                        totalUpdates += stmt.executeUpdate();
                    }
                }
                System.out.println("Success! Updated " + totalUpdates + " stops.");
            }
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
        }
    }
}
