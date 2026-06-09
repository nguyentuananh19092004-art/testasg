package dal;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Schedule;

public class ScheduleDAO extends DBContext {

    public List<Schedule> getAllSchedules() {
        List<Schedule> list = new ArrayList<>();
        String sql = "SELECT * FROM Schedules ORDER BY Date DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Schedule s = new Schedule(
                        rs.getInt("ScheduleID"),
                        rs.getDate("Date"),
                        rs.getString("Direction"),
                        rs.getInt("RouteID"),
                        rs.getInt("BusID"),
                        rs.getInt("DriverID"),
                        rs.getInt("MonitorID"),
                        rs.getString("Status")
                );
                list.add(s);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public boolean insertSchedule(Schedule s) {
        String sql = "INSERT INTO Schedules (Date, Direction, RouteID, BusID, DriverID, MonitorID, Status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setDate(1, s.getDate());
            st.setString(2, s.getDirection());
            st.setInt(3, s.getRouteID());
            st.setInt(4, s.getBusID());
            st.setInt(5, s.getDriverID());
            st.setInt(6, s.getMonitorID());
            st.setString(7, s.getStatus());
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println(e);
            return false;
        }
    }
}
