import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class UpdateAllRoutes {
    public static void main(String[] args) {
        String url = "jdbc:sqlserver://localhost:1433;databaseName=SchoolBusDB;encrypt=true;trustServerCertificate=true;";
        String username = "sa";
        String password = "123";

        String[] updates = {
            // Đã fix cực chuẩn:
            "UPDATE Stops SET Latitude = 20.9910977, Longitude = 105.9435884 WHERE StopID = 1;", // S2.15
            "UPDATE Stops SET Latitude = 20.9947239, Longitude = 105.9431557 WHERE StopID = 2;", // S1.08
            "UPDATE Stops SET Latitude = 20.9716199, Longitude = 105.8795939 WHERE StopID = 3;", // The Zen Gamuda
            "UPDATE Stops SET Latitude = 21.0175000, Longitude = 105.7841000 WHERE StopID = 4;", // LandMark 72 (Keangnam)
            "UPDATE Stops SET Latitude = 21.0165986, Longitude = 105.7760220 WHERE StopID = 5;", // Trường Marie Curie

            // Fix 22 điểm còn lại:
            "UPDATE Stops SET Latitude = 21.041699, Longitude = 105.920556 WHERE StopID = 6;", // VinCom Long Biên
            "UPDATE Stops SET Latitude = 21.032650, Longitude = 105.916120 WHERE StopID = 7;", // H3 Chu Huy Mân (Hope Residences)
            "UPDATE Stops SET Latitude = 20.997860, Longitude = 105.865480 WHERE StopID = 8;", // 423 Minh Khai (Imperia Sky Garden)
            "UPDATE Stops SET Latitude = 20.995400, Longitude = 105.867560 WHERE StopID = 9;", // VinCom TimesCity
            "UPDATE Stops SET Latitude = 21.002840, Longitude = 105.815520 WHERE StopID = 10;",// Royal City
            "UPDATE Stops SET Latitude = 21.031730, Longitude = 105.814320 WHERE StopID = 11;",// Vincom Metropolis
            "UPDATE Stops SET Latitude = 21.024440, Longitude = 105.808800 WHERE StopID = 12;",// VinCom Nguyễn Chí Thanh
            "UPDATE Stops SET Latitude = 21.063460, Longitude = 105.794690 WHERE StopID = 13;",// N03-T1 Minh Tảo
            "UPDATE Stops SET Latitude = 21.065840, Longitude = 105.795490 WHERE StopID = 14;",// N01-T6
            "UPDATE Stops SET Latitude = 21.056020, Longitude = 105.800360 WHERE StopID = 15;",// 6th elements
            "UPDATE Stops SET Latitude = 21.078170, Longitude = 105.782800 WHERE StopID = 16;",// Tòa N02, Ecohome 3
            "UPDATE Stops SET Latitude = 21.053450, Longitude = 105.780540 WHERE StopID = 17;",// 27A2 thành phố giao lưu
            "UPDATE Stops SET Latitude = 21.039010, Longitude = 105.766100 WHERE StopID = 18;",// R1 GoldMark City
            "UPDATE Stops SET Latitude = 21.034500, Longitude = 105.764420 WHERE StopID = 19;",// A1 Vinhome gardenia
            "UPDATE Stops SET Latitude = 20.957720, Longitude = 105.765690 WHERE StopID = 20;",// V3 Victory Văn Phú
            "UPDATE Stops SET Latitude = 20.968030, Longitude = 105.752310 WHERE StopID = 21;",// P2 ParkCity
            "UPDATE Stops SET Latitude = 20.988500, Longitude = 105.742500 WHERE StopID = 22;",// C16 Gleximco (Dự tính)
            "UPDATE Stops SET Latitude = 20.995000, Longitude = 105.745500 WHERE StopID = 23;",// A32 Gleximco (Dự tính)
            "UPDATE Stops SET Latitude = 21.008580, Longitude = 105.748120 WHERE StopID = 24;",// GS1 SmartCity
            "UPDATE Stops SET Latitude = 21.005110, Longitude = 105.745300 WHERE StopID = 25;",// S401 SmartCity
            "UPDATE Stops SET Latitude = 21.009650, Longitude = 105.774470 WHERE StopID = 26;",// Mỹ Đình Pearl
            "UPDATE Stops SET Latitude = 21.011380, Longitude = 105.776760 WHERE StopID = 27;" // Matrix One
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
                System.out.println("Success! Updated ALL coordinates for " + totalUpdates + " stops.");
            }
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
        }
    }
}
