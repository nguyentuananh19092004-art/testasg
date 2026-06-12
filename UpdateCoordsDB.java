import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class UpdateCoordsDB {
    public static void main(String[] args) {
        String url = "jdbc:sqlserver://localhost:1433;databaseName=SchoolBusDB;encrypt=true;trustServerCertificate=true;";
        String username = "sa";
        String password = "123";

        String[] updates = {
            "UPDATE Stops SET Latitude = 20.991500, Longitude = 105.941600 WHERE StopID = 1;",
            "UPDATE Stops SET Latitude = 20.994200, Longitude = 105.946300 WHERE StopID = 2;",
            "UPDATE Stops SET Latitude = 20.965500, Longitude = 105.867200 WHERE StopID = 3;",
            "UPDATE Stops SET Latitude = 21.0173, Longitude = 105.7841 WHERE StopID = 4;",
            "UPDATE Stops SET Latitude = 21.017500, Longitude = 105.780800 WHERE StopID = 5;",
            "UPDATE Stops SET Latitude = 21.0401, Longitude = 105.9189 WHERE StopID = 6;",
            "UPDATE Stops SET Latitude = 21.0345, Longitude = 105.9123 WHERE StopID = 7;",
            "UPDATE Stops SET Latitude = 20.9981, Longitude = 105.8654 WHERE StopID = 8;",
            "UPDATE Stops SET Latitude = 20.9954, Longitude = 105.8675 WHERE StopID = 9;",
            "UPDATE Stops SET Latitude = 21.0028, Longitude = 105.8155 WHERE StopID = 10;",
            "UPDATE Stops SET Latitude = 21.0317, Longitude = 105.8143 WHERE StopID = 11;",
            "UPDATE Stops SET Latitude = 21.0244, Longitude = 105.8088 WHERE StopID = 12;",
            "UPDATE Stops SET Latitude = 21.0664, Longitude = 105.7950 WHERE StopID = 13;",
            "UPDATE Stops SET Latitude = 21.0682, Longitude = 105.7941 WHERE StopID = 14;",
            "UPDATE Stops SET Latitude = 21.0573, Longitude = 105.8005 WHERE StopID = 15;",
            "UPDATE Stops SET Latitude = 21.0772, Longitude = 105.7831 WHERE StopID = 16;",
            "UPDATE Stops SET Latitude = 21.0543, Longitude = 105.7803 WHERE StopID = 17;",
            "UPDATE Stops SET Latitude = 21.0396, Longitude = 105.7656 WHERE StopID = 18;",
            "UPDATE Stops SET Latitude = 21.0342, Longitude = 105.7635 WHERE StopID = 19;",
            "UPDATE Stops SET Latitude = 20.9572, Longitude = 105.7644 WHERE StopID = 20;",
            "UPDATE Stops SET Latitude = 20.9665, Longitude = 105.7533 WHERE StopID = 21;",
            "UPDATE Stops SET Latitude = 20.9882, Longitude = 105.7421 WHERE StopID = 22;",
            "UPDATE Stops SET Latitude = 20.9950, Longitude = 105.7455 WHERE StopID = 23;",
            "UPDATE Stops SET Latitude = 21.0084, Longitude = 105.7483 WHERE StopID = 24;",
            "UPDATE Stops SET Latitude = 21.0062, Longitude = 105.7451 WHERE StopID = 25;",
            "UPDATE Stops SET Latitude = 21.0093, Longitude = 105.7744 WHERE StopID = 26;",
            "UPDATE Stops SET Latitude = 21.0116, Longitude = 105.7766 WHERE StopID = 27;"
        };

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            try (Connection conn = DriverManager.getConnection(url, username, password)) {
                System.out.println("Connected to the database. Updating coordinates...");
                int totalUpdates = 0;
                for (String sql : updates) {
                    try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                        int rows = stmt.executeUpdate();
                        totalUpdates += rows;
                    }
                }
                System.out.println("Success! Updated coordinates for " + totalUpdates + " stops.");
            }
        } catch (ClassNotFoundException | SQLException ex) {
            System.err.println("Error connecting or updating: " + ex.getMessage());
            ex.printStackTrace();
        }
    }
}
