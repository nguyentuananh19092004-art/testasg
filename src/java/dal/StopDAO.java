package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Stop;

public class StopDAO extends DBContext {

    public List<Stop> getStopsByRoute(int routeID) {
        List<Stop> list = new ArrayList<>();
        String sql = "SELECT s.*, rs.StopOrder, rs.EstimatedTime, rs.ReturnTime " +
                     "FROM Stops s " +
                     "JOIN RouteStops rs ON s.StopID = rs.StopID " +
                     "WHERE rs.RouteID = ? " +
                     "ORDER BY rs.StopOrder";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, routeID);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Stop s = new Stop(
                        rs.getInt("StopID"),
                        rs.getString("StopName"),
                        rs.getString("Address"),
                        rs.getDouble("Latitude"),
                        rs.getDouble("Longitude")
                );
                s.setStopOrder(rs.getInt("StopOrder"));
                s.setEstimatedTime(rs.getTime("EstimatedTime"));
                s.setReturnTime(rs.getTime("ReturnTime"));
                list.add(s);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<Stop> getAllStops() {
        List<Stop> list = new ArrayList<>();
        String sql = "SELECT * FROM Stops";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Stop(
                        rs.getInt("StopID"),
                        rs.getString("StopName"),
                        rs.getString("Address"),
                        rs.getDouble("Latitude"),
                        rs.getDouble("Longitude")
                ));
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }
}
