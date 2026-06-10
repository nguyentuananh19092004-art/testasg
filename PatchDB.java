import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.util.regex.*;

public class PatchDB {
    public static void main(String[] args) {
        try {
            Path path = Paths.get("SchoolBusDB.sql");
            String content = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);

            // Add DefaultStopID to HocSinh
            if (!content.contains("DefaultStopID INT FOREIGN KEY")) {
                content = content.replace(
                    "    MatKhau VARCHAR(255) DEFAULT '123',",
                    "    MatKhau VARCHAR(255) DEFAULT '123',\n    DefaultStopID INT FOREIGN KEY REFERENCES Stops(StopID),"
                );
            }

            // Add IncidentStatus to Schedules
            if (!content.contains("IncidentStatus VARCHAR(20)")) {
                content = content.replace(
                    "    Status VARCHAR(20) DEFAULT 'PENDING' -- PENDING, IN_PROGRESS, COMPLETED, CANCELLED",
                    "    Status VARCHAR(20) DEFAULT 'PENDING', -- PENDING, IN_PROGRESS, COMPLETED, CANCELLED\n    IncidentStatus VARCHAR(20) DEFAULT 'NORMAL' -- NORMAL, INCIDENT"
                );
            }

            // Add new tables
            if (!content.contains("CREATE TABLE ScheduleProgress")) {
                String newTables = "\n-- 9. Bảng ScheduleProgress (Tiến trình chuyến đi)\n" +
                    "CREATE TABLE ScheduleProgress (\n" +
                    "    ProgressID INT IDENTITY(1,1) PRIMARY KEY,\n" +
                    "    ScheduleID INT FOREIGN KEY REFERENCES Schedules(ScheduleID),\n" +
                    "    StopID INT FOREIGN KEY REFERENCES Stops(StopID),\n" +
                    "    ArrivalTime DATETIME NOT NULL\n" +
                    ");\n\n" +
                    "-- 10. Bảng Notifications (Thông báo)\n" +
                    "CREATE TABLE Notifications (\n" +
                    "    NotifID INT IDENTITY(1,1) PRIMARY KEY,\n" +
                    "    Username VARCHAR(50) FOREIGN KEY REFERENCES Users(Username),\n" +
                    "    Message NVARCHAR(255) NOT NULL,\n" +
                    "    CreatedAt DATETIME DEFAULT GETDATE(),\n" +
                    "    IsRead BIT DEFAULT 0\n" +
                    ");\n\nGO";
                
                content = content.replace("    Note NVARCHAR(255)\r\n);\r\n\r\nGO", "    Note NVARCHAR(255)\r\n);\r\n" + newTables);
                content = content.replace("    Note NVARCHAR(255)\n);\n\nGO", "    Note NVARCHAR(255)\n);\n" + newTables);
            }

            Files.write(path, content.getBytes(StandardCharsets.UTF_8));
            System.out.println("PatchDB completed successfully.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
