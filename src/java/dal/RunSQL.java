package dal;

import java.sql.Connection;
import java.sql.Statement;

public class RunSQL {
    public static void main(String[] args) {
        try {
            DBContext db = new DBContext() {};
            Connection conn = db.connection;
            Statement st = conn.createStatement();
            
            // Add DefaultRouteID to HocSinh
            String sql = "ALTER TABLE HocSinh ADD DefaultRouteID INT FOREIGN KEY REFERENCES Routes(RouteID)";
            st.execute(sql);
            System.out.println("Added DefaultRouteID to HocSinh.");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
