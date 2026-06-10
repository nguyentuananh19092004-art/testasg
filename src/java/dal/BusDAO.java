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

    public Bus getBusById(int id) {
        String sql = "SELECT * FROM Buses WHERE BusID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Bus(
                        rs.getInt("BusID"),
                        rs.getString("LicensePlate"),
                        rs.getInt("Capacity"),
                        rs.getString("Status")
                );
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public void insertBus(Bus b) {
        String sql = "INSERT INTO Buses (LicensePlate, Capacity, Status) VALUES (?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, b.getLicensePlate());
            st.setInt(2, b.getCapacity());
            st.setString(3, b.getStatus());
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void updateBus(Bus b) {
        String sql = "UPDATE Buses SET LicensePlate=?, Capacity=?, Status=? WHERE BusID=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, b.getLicensePlate());
            st.setInt(2, b.getCapacity());
            st.setString(3, b.getStatus());
            st.setInt(4, b.getBusID());
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public void deleteBus(int id) {
        String sql = "DELETE FROM Buses WHERE BusID=?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (SQLException e) {
            System.out.println(e);
        }
    }

    public boolean checkLicensePlateExist(String licensePlate, int excludeBusId) {
        String sql = "SELECT 1 FROM Buses WHERE LicensePlate = ? AND BusID != ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, licensePlate);
            st.setInt(2, excludeBusId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return true;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }
}
