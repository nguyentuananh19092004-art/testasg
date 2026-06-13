package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AttendanceDAO extends DBContext {

    public void insertAttendance(int scheduleID, String maHocSinh, int stopID, boolean isAbsent, String direction) {
        String timeField = "TO_SCHOOL".equals(direction) ? "BoardingTime" : "AlightingTime";
        String sql = "INSERT INTO Attendances (ScheduleID, MaHocSinh, StopID, " + timeField + ", IsAbsent) VALUES (?, ?, ?, GETDATE(), ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, scheduleID);
            st.setString(2, maHocSinh);
            st.setInt(3, stopID);
            st.setBoolean(4, isAbsent);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<String> getAttendedStudents(int scheduleID) {
        List<String> list = new ArrayList<>();
        String sql = "SELECT MaHocSinh FROM Attendances WHERE ScheduleID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, scheduleID);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(rs.getString("MaHocSinh"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
