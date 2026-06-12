import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class UpdateExactCoords {
    public static void main(String[] args) {
        String url = "jdbc:sqlserver://localhost:1433;databaseName=SchoolBusDB;encrypt=true;trustServerCertificate=true;";
        String username = "sa";
        String password = "123";

        String[] updates = {
            "UPDATE Stops SET Latitude = 20.9910977, Longitude = 105.9435884 WHERE StopID = 1;", // S2.15
            "UPDATE Stops SET Latitude = 20.9947239, Longitude = 105.9431557 WHERE StopID = 2;",  // S1.08
            "UPDATE Stops SET Latitude = 20.9716199, Longitude = 105.8795939 WHERE StopID = 3;", // The Zen Gamuda
            "UPDATE Stops SET Latitude = 21.0165986, Longitude = 105.7760220 WHERE StopID = 5;", // Trường Marie Curie
            "UPDATE Stops SET Latitude = 21.0509278, Longitude = 105.9163608 WHERE StopID = 6;", // VinCom Long Biên
            "UPDATE Stops SET Latitude = 21.0419908, Longitude = 105.9044396 WHERE StopID = 7;", // H3 Chu Huy Mân
            "UPDATE Stops SET Latitude = 20.9989958, Longitude = 105.8664846 WHERE StopID = 8;", // 423 Minh Khai
            "UPDATE Stops SET Latitude = 21.0235360, Longitude = 105.8088920 WHERE StopID = 12;", // VinCom Nguyễn Chí Thanh
            "UPDATE Stops SET Latitude = 21.0654675, Longitude = 105.7981705 WHERE StopID = 13;", // N03-T1
            "UPDATE Stops SET Latitude = 21.0633291, Longitude = 105.7971657 WHERE StopID = 14;", // N01-T6 Han Jardin
            "UPDATE Stops SET Latitude = 21.0513256, Longitude = 105.7996255 WHERE StopID = 15;", // 6th Element
            "UPDATE Stops SET Latitude = 21.0520662, Longitude = 105.7804489 WHERE StopID = 17;", // 27A2 Green Stars
            "UPDATE Stops SET Latitude = 21.0435299, Longitude = 105.7666960 WHERE StopID = 18;", // R1 Goldmark City
            "UPDATE Stops SET Latitude = 21.0360243, Longitude = 105.7603859 WHERE StopID = 19;", // A1 Vinhomes Gardenia
            "UPDATE Stops SET Latitude = 20.9591715, Longitude = 105.7685205 WHERE StopID = 20;", // V3 Văn Phú Victoria
            "UPDATE Stops SET Latitude = 20.9638593, Longitude = 105.7566201 WHERE StopID = 21;", // Park Kiara @ ParkCity Hanoi
            "UPDATE Stops SET Latitude = 20.9903249, Longitude = 105.7383832 WHERE StopID = 22;", // C16 Geleximco / Pho La Duong
            "UPDATE Stops SET Latitude = 21.0051280, Longitude = 105.7330400 WHERE StopID = 23;", // A32 Geleximco / Lapland
            "UPDATE Stops SET Latitude = 21.0055366, Longitude = 105.7371635 WHERE StopID = 24;"  // GS1 Smart City
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
                System.out.println("Success! Updated coordinates for " + totalUpdates + " stops.");
            }
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
        }
    }
}
