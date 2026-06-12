import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CheckCoords {
    public static void main(String[] args) {
        String url = "jdbc:sqlserver://localhost:1433;databaseName=SchoolBusDB;encrypt=true;trustServerCertificate=true;";
        String username = "sa";
        String password = "123";

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            try (Connection conn = DriverManager.getConnection(url, username, password)) {
                String sql = "SELECT StopID, StopName, Latitude, Longitude FROM Stops WHERE StopID IN (1, 2, 3, 5)";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    ResultSet rs = stmt.executeQuery();
                    while (rs.next()) {
                        System.out.println("ID: " + rs.getInt("StopID") + ", Name: " + rs.getString("StopName") + ", Lat: " + rs.getBigDecimal("Latitude") + ", Lng: " + rs.getBigDecimal("Longitude"));
                    }
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
