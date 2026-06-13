package dal;

import java.sql.Connection;
import java.sql.Statement;

public class RunSQL {
    public static void main(String[] args) {
        try {
            DBContext db = new DBContext() {};
            Connection conn = db.connection;
            Statement st = conn.createStatement();
            
            // Drop old constraint, update capacity, add new constraint
            String[] updates = {
                "DECLARE @ConstraintName nvarchar(200)\n" +
                "SELECT @ConstraintName = Name FROM sys.check_constraints WHERE parent_object_id = OBJECT_ID('Buses')\n" +
                "IF @ConstraintName IS NOT NULL\n" +
                "EXEC('ALTER TABLE Buses DROP CONSTRAINT ' + @ConstraintName)",
                
                "UPDATE Buses SET Capacity = 7 WHERE Capacity = 29",
                "UPDATE Buses SET Capacity = 9 WHERE Capacity = 47",
                
                "ALTER TABLE Buses ADD CONSTRAINT CK_Buses_Capacity CHECK (Capacity IN (7, 9))"
            };
            
            for (String sql : updates) {
                st.execute(sql);
            }
            System.out.println("Updated Bus capacities to 7 and 9.");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
