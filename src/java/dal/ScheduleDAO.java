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
                        rs.getString("Status"),
                        rs.getString("IncidentStatus")
                );
                list.add(s);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public List<Schedule> getSchedulesByUserAndDate(int userID, String role, java.sql.Date date) {
        List<Schedule> list = new ArrayList<>();
        String sql = "SELECT * FROM Schedules WHERE Date = ? ";
        if ("taixe".equals(role) || "DRIVER".equals(role)) {
            sql += "AND DriverID = ?";
        } else if ("giamthi".equals(role) || "MONITOR".equals(role)) {
            sql += "AND MonitorID = ?";
        } else {
            return list;
        }
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setDate(1, date);
            st.setInt(2, userID);
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
                    rs.getString("Status"),
                    rs.getString("IncidentStatus")
                );
                list.add(s);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public boolean insertSchedule(Schedule s) {
        String sql = "INSERT INTO Schedules (Date, Direction, RouteID, BusID, DriverID, MonitorID, Status, IncidentStatus) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setDate(1, s.getDate());
            st.setString(2, s.getDirection());
            st.setInt(3, s.getRouteID());
            st.setInt(4, s.getBusID());
            st.setInt(5, s.getDriverID());
            st.setInt(6, s.getMonitorID());
            st.setString(7, s.getStatus());
            st.setString(8, s.getIncidentStatus() != null ? s.getIncidentStatus() : "NORMAL");
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println(e);
            return false;
        }
    }

    public boolean isConflict(Date date, String direction, int driverID, int monitorID, int busID) {
        String sql = "SELECT COUNT(*) FROM Schedules WHERE Date = ? AND Direction = ? AND (DriverID = ? OR MonitorID = ? OR BusID = ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setDate(1, date);
            st.setString(2, direction);
            st.setInt(3, driverID);
            st.setInt(4, monitorID);
            st.setInt(5, busID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }

    public Schedule getActiveScheduleByMonitor(int monitorID) {
        String sql = "SELECT * FROM Schedules WHERE MonitorID = ? AND Date = CAST(GETDATE() AS DATE) AND Status != 'COMPLETED' AND Status != 'CANCELLED'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, monitorID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Schedule(
                        rs.getInt("ScheduleID"),
                        rs.getDate("Date"),
                        rs.getString("Direction"),
                        rs.getInt("RouteID"),
                        rs.getInt("BusID"),
                        rs.getInt("DriverID"),
                        rs.getInt("MonitorID"),
                        rs.getString("Status"),
                        rs.getString("IncidentStatus")
                );
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public Schedule getActiveScheduleByDriver(int driverID) {
        String sql = "SELECT * FROM Schedules WHERE DriverID = ? AND Date = CAST(GETDATE() AS DATE) AND Status != 'COMPLETED' AND Status != 'CANCELLED'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, driverID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Schedule(
                        rs.getInt("ScheduleID"),
                        rs.getDate("Date"),
                        rs.getString("Direction"),
                        rs.getInt("RouteID"),
                        rs.getInt("BusID"),
                        rs.getInt("DriverID"),
                        rs.getInt("MonitorID"),
                        rs.getString("Status"),
                        rs.getString("IncidentStatus")
                );
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public List<Schedule> getIncidentSchedules() {
        List<Schedule> list = new ArrayList<>();
        String sql = "SELECT * FROM Schedules WHERE IncidentStatus = 'INCIDENT' AND Status != 'COMPLETED' AND Status != 'CANCELLED'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Schedule(
                        rs.getInt("ScheduleID"),
                        rs.getDate("Date"),
                        rs.getString("Direction"),
                        rs.getInt("RouteID"),
                        rs.getInt("BusID"),
                        rs.getInt("DriverID"),
                        rs.getInt("MonitorID"),
                        rs.getString("Status"),
                        rs.getString("IncidentStatus")
                ));
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public Schedule getActiveScheduleForStop(int stopID) {
        String sql = "SELECT TOP 1 s.* FROM Schedules s " +
                     "JOIN RouteStops rs ON s.RouteID = rs.RouteID " +
                     "WHERE rs.StopID = ? AND s.Date = CAST(GETDATE() AS DATE) " +
                     "AND s.Status = 'IN_PROGRESS'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, stopID);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return new Schedule(
                        rs.getInt("ScheduleID"),
                        rs.getDate("Date"),
                        rs.getString("Direction"),
                        rs.getInt("RouteID"),
                        rs.getInt("BusID"),
                        rs.getInt("DriverID"),
                        rs.getInt("MonitorID"),
                        rs.getString("Status"),
                        rs.getString("IncidentStatus")
                );
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return null;
    }

    public boolean deleteSchedule(int id) {
        String deleteAttendances = "DELETE FROM Attendances WHERE ScheduleID = ?";
        String deleteProgress = "DELETE FROM ScheduleProgress WHERE ScheduleID = ?";
        String deleteSchedule = "DELETE FROM Schedules WHERE ScheduleID = ?";
        try {
            connection.setAutoCommit(false);
            
            // Delete dependent records first
            PreparedStatement st1 = connection.prepareStatement(deleteAttendances);
            st1.setInt(1, id);
            st1.executeUpdate();
            
            PreparedStatement st2 = connection.prepareStatement(deleteProgress);
            st2.setInt(1, id);
            st2.executeUpdate();
            
            // Delete main record
            PreparedStatement st3 = connection.prepareStatement(deleteSchedule);
            st3.setInt(1, id);
            int rows = st3.executeUpdate();
            
            connection.commit();
            connection.setAutoCommit(true);
            return rows > 0;
        } catch (SQLException e) {
            System.out.println(e);
            try {
                connection.rollback();
                connection.setAutoCommit(true);
            } catch (SQLException ex) {
                System.out.println(ex);
            }
        }
        return false;
    }

    public boolean updateSchedulePersonnel(int scheduleID, String role, int newUserID) {
        String column = ("taixe".equals(role) || "DRIVER".equals(role)) ? "DriverID" : "MonitorID";
        String sql = "UPDATE Schedules SET " + column + " = ? WHERE ScheduleID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, newUserID);
            st.setInt(2, scheduleID);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e);
        }
        return false;
    }

    public List<model.TechnicianSchedule> getTechnicianSchedules() {
        List<model.TechnicianSchedule> list = new ArrayList<>();
        String sql = "SELECT ts.*, u.FullName FROM TechnicianSchedules ts JOIN Users u ON ts.TechnicianID = u.UserID ORDER BY ts.Date DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                model.TechnicianSchedule ts = new model.TechnicianSchedule(
                        rs.getInt("TechScheduleID"),
                        rs.getInt("TechnicianID"),
                        rs.getDate("Date"),
                        rs.getTimestamp("CreatedAt")
                );
                ts.setTechnicianName(rs.getString("FullName"));
                list.add(ts);
            }
        } catch (SQLException e) {
            System.out.println(e);
        }
        return list;
    }

    public boolean insertTechnicianSchedule(int technicianID, Date date) {
        String sql = "INSERT INTO TechnicianSchedules (TechnicianID, Date) VALUES (?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, technicianID);
            st.setDate(2, date);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e);
            return false;
        }
    }

    public boolean deleteTechnicianSchedule(int id) {
        String sql = "DELETE FROM TechnicianSchedules WHERE TechScheduleID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println(e);
            return false;
        }
    }
}
