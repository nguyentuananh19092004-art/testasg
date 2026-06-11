import java.nio.file.*;
import java.nio.charset.StandardCharsets;

public class UpdateSql {
    public static void main(String[] args) throws Exception {
        Path path = Paths.get("d:\\PRJ\\AsigmentSU26_PRJ301\\SchoolBusDB.sql");
        String content = Files.readString(path, StandardCharsets.UTF_8);
        
        // 1. Cập nhật Schema
        content = content.replace("Status VARCHAR(20) DEFAULT 'SAN_SANG'", "Status NVARCHAR(50) DEFAULT N'Sẵn sàng'");
        content = content.replace("Status VARCHAR(20) DEFAULT 'SAN_SANG' -- SAN_SANG, DANG_HOAT_DONG, BAO_DUONG", "Status NVARCHAR(50) DEFAULT N'Sẵn sàng' -- Sẵn sàng, Đang hoạt động, Bảo dưỡng/Sửa chữa");
        
        // 2. Cập nhật Data Users
        content = content.replace("NULL, 'Active')", "NULL, N'Sẵn sàng')");
        content = content.replace("NULL, N'Active')", "NULL, N'Sẵn sàng')");
        content = content.replace("NULL, 'Rest')", "NULL, N'Nghỉ')");
        
        // 3. Cập nhật Data Buses
        content = content.replace("29, 'Active')", "29, N'Sẵn sàng')");
        content = content.replace("47, 'Active')", "47, N'Sẵn sàng')");
        content = content.replace("29, 'Rest')", "29, N'Bảo dưỡng/Sửa chữa')");
        content = content.replace("47, 'Maintenance')", "47, N'Bảo dưỡng/Sửa chữa')");
        
        // 4. Fix MonitorID trong Schedule
        content = content.replace("(CAST(GETDATE() AS DATE), 'TO_SCHOOL', 1, 1, 3, 2, 'PENDING')", "(CAST(GETDATE() AS DATE), 'TO_SCHOOL', 1, 1, 3, 12, 'PENDING')");
        content = content.replace("(CAST(GETDATE() AS DATE), 'TO_HOME',   1, 1, 3, 2, 'PENDING')", "(CAST(GETDATE() AS DATE), 'TO_HOME',   1, 1, 3, 12, 'PENDING')");
        
        Files.writeString(path, content, StandardCharsets.UTF_8);
        System.out.println("Done updating SchoolBusDB.sql");
    }
}
