package controller;

import dal.ScheduleDAO;
import dal.BusDAO;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "TechnicianActionServlet", urlPatterns = {"/technician-action"})
public class TechnicianActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        if (session.getAttribute("userRole") == null || !"kythuat".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("dang_nhap.jsp");
            return;
        }

        String action = request.getParameter("action");
        
        if ("resolve_incident".equals(action)) {
            int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
            ScheduleDAO dao = new ScheduleDAO();
            String sql = "UPDATE Schedules SET IncidentStatus = 'NORMAL' WHERE ScheduleID = ?";
            try {
                PreparedStatement st = dao.getConnection().prepareStatement(sql);
                st.setInt(1, scheduleID);
                st.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else if ("finish_maintenance".equals(action)) {
            int busID = Integer.parseInt(request.getParameter("busID"));
            BusDAO dao = new BusDAO();
            String sql = "UPDATE Buses SET Status = 'SAN_SANG' WHERE BusID = ?";
            try {
                PreparedStatement st = dao.getConnection().prepareStatement(sql);
                st.setInt(1, busID);
                st.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("technician-dashboard");
    }
}
