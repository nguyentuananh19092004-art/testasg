import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.util.regex.*;
import java.util.ArrayList;
import java.util.List;

public class SafelyUpdateDB {
    public static void main(String[] args) {
        try {
            Path path = Paths.get("SchoolBusDB.sql");
            
            // The file is pure UTF-8 natively!
            String content = new String(Files.readAllBytes(path), StandardCharsets.UTF_8);

            // 1. Update CREATE TABLE Users
            String oldUsersTable = "    Email VARCHAR(100)\r\n);";
            String newUsersTable = "    Email VARCHAR(100),\r\n    Status VARCHAR(20) DEFAULT 'Active'\r\n);";
            if (!content.contains(oldUsersTable)) {
                oldUsersTable = "    Email VARCHAR(100)\n);";
                newUsersTable = "    Email VARCHAR(100),\n    Status VARCHAR(20) DEFAULT 'Active'\n);";
            }
            content = content.replace(oldUsersTable, newUsersTable);

            // 2. Update CREATE TABLE Buses
            String oldBusesTable = "    Capacity INT NOT NULL CHECK \\(Capacity IN \\(29, 47\\)\\)\r?\n\\);";
            String newBusesTable = "    Capacity INT NOT NULL CHECK (Capacity IN (29, 47)),\n    Status VARCHAR(20) DEFAULT 'Active'\n);";
            content = content.replaceAll(oldBusesTable, newBusesTable);

            // 3. Replace INSERT INTO Buses
            String oldBusesInsertPattern = "INSERT INTO Buses \\(LicensePlate, Capacity, Status\\) VALUES\\s*\\([^;]+;";
            String newBusesInsert = "INSERT INTO Buses (LicensePlate, Capacity) VALUES\n" +
                "('29E-111.11', 29),\n" +
                "('29E-222.22', 47),\n" +
                "('29E-333.33', 29),\n" +
                "('29E-444.44', 47),\n" +
                "('29E-555.55', 29),\n" +
                "('29E-666.66', 47),\n" +
                "('29E-777.77', 29),\n" +
                "('29E-888.88', 47),\n" +
                "('29E-999.99', 29),\n" +
                "('29E-101.01', 47);";
            content = content.replaceAll(oldBusesInsertPattern, newBusesInsert);

            // 4. Extract HocSinh to generate Parents
            String hocSinhRegex = "\\('([^']+)',\\s*N'([^']+)',\\s*\\d+,\\s*'([^']+)'";
            Pattern hsPattern = Pattern.compile(hocSinhRegex);
            Matcher hsMatcher = hsPattern.matcher(content);
            List<String> parents = new ArrayList<>();
            while (hsMatcher.find()) {
                String fullName = hsMatcher.group(2);
                String tenTK = hsMatcher.group(3);
                parents.add(String.format("('%s', '123', 'PARENT', N'Phụ huynh %s', NULL, NULL, 'Active')", tenTK, fullName));
            }

            // 5. Replace INSERT INTO Users
            StringBuilder newUsers = new StringBuilder("INSERT INTO Users (Username, Password, Role, FullName, Phone, Email) VALUES\n");
            newUsers.append("('admin', '123', 'ADMIN', N'Quản trị viên', '0900000001', NULL),\n");
            
            for (int i = 1; i <= 10; i++) {
                newUsers.append(String.format("('taixe%d', '123', 'DRIVER', N'Tài xế %d', '090000001%d', NULL),\n", i, i, i%10));
            }
            for (int i = 1; i <= 10; i++) {
                newUsers.append(String.format("('giamsat%d', '123', 'MONITOR', N'Giám sát %d', '090000002%d', NULL),\n", i, i, i%10));
            }
            
            for (int i = 1; i <= 5; i++) {
                newUsers.append(String.format("('kythuat%d', '123', 'TECHNICIAN', N'Kỹ thuật %d', '090000003%d', NULL),\n", i, i, i%10));
            }
            
            for (int i = 0; i < parents.size(); i++) {
                newUsers.append(parents.get(i).replace(", 'Active')", ")"));
                if (i == parents.size() - 1) {
                    newUsers.append(";");
                } else {
                    newUsers.append(",\n");
                }
            }

            String userPattern = "INSERT INTO Users \\(Username, Password, Role, FullName, Phone, Email, Status\\) VALUES\\s*\\([^;]+;";
            if (!content.replaceAll(userPattern, "").equals(content)) {
                content = content.replaceAll(userPattern, newUsers.toString());
            } else {
                userPattern = "INSERT INTO Users \\(Username, Password, Role, FullName, Phone\\) VALUES\\s*\\([^;]+;";
                content = content.replaceAll(userPattern, newUsers.toString());
            }

            // Write the file back as UTF-8
            Files.write(path, content.getBytes(StandardCharsets.UTF_8));
            System.out.println("Safely updated SchoolBusDB.sql with pure UTF-8 encoding!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
