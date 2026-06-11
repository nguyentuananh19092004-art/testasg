package controller;

import dal.ScheduleDAO;
import dal.BusDAO;
import dal.UserDAO;
import model.Schedule;
import model.Bus;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "DriverActionServlet", urlPatterns = {"/driver-action"})
public class DriverActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        if (session.getAttribute("userRole") == null || !"taixe".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("dang_nhap.jsp");
            return;
        }

        String action = request.getParameter("action");
        int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
        int busID = Integer.parseInt(request.getParameter("busID"));

        ScheduleDAO scheduleDAO = new ScheduleDAO();
        BusDAO busDAO = new BusDAO();

        if ("start_trip".equals(action)) {
            // Update Schedule Status to IN_PROGRESS
            updateScheduleStatus(scheduleID, "IN_PROGRESS", scheduleDAO);
            // Update Bus Status to Hoạt động
            updateBusStatus(busID, "Hoạt động", busDAO);
        } else if ("report_incident".equals(action)) {
            // Update Schedule IncidentStatus to INCIDENT
            updateScheduleIncidentStatus(scheduleID, "INCIDENT", scheduleDAO);
            // Update Bus Status to Bảo dưỡng/Sửa chữa
            updateBusStatus(busID, "Bảo dưỡng/Sửa chữa", busDAO);
            
            // Notification can also be sent to Technician here, but UI Dashboard handles reading IncidentStatus.
        }

        response.sendRedirect("driver-dashboard");
    }

    private void updateScheduleStatus(int scheduleID, String status, ScheduleDAO dao) {
        String sql = "UPDATE Schedules SET Status = ? WHERE ScheduleID = ?";
        try {
            PreparedStatement st = dao.getConnection().prepareStatement(sql);
            st.setString(1, status);
            st.setInt(2, scheduleID);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void updateScheduleIncidentStatus(int scheduleID, String incidentStatus, ScheduleDAO dao) {
        String sql = "UPDATE Schedules SET IncidentStatus = ? WHERE ScheduleID = ?";
        try {
            PreparedStatement st = dao.getConnection().prepareStatement(sql);
            st.setString(1, incidentStatus);
            st.setInt(2, scheduleID);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void updateBusStatus(int busID, String status, BusDAO dao) {
        String sql = "UPDATE Buses SET Status = ? WHERE BusID = ?";
        try {
            PreparedStatement st = dao.getConnection().prepareStatement(sql);
            st.setString(1, status);
            st.setInt(2, busID);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
