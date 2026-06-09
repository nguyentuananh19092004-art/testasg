package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Bus;

public class BusDAO extends DBContext {

    public List<Bus> getAllBuses() {
        List<Bus> list = new ArrayList<>();
        String sql = "SELECT * FROM Buses";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Bus b = new Bus(
                        rs.getInt("BusID"),
                        rs.getString("LicensePlate"),
                        rs.getInt("Capacity"),
                        rs.getString("Status")
                );
                list.add(b);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }
}
