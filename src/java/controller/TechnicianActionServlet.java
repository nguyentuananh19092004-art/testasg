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
        
        if ("dispatch_bus".equals(action)) {
            int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
            int replacementBusID = Integer.parseInt(request.getParameter("replacementBusID"));
            ScheduleDAO dao = new ScheduleDAO();
            dao.updateIncidentStatus(scheduleID, "DISPATCHED", replacementBusID);
        } else if ("arrive_incident".equals(action)) {
            int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
            ScheduleDAO dao = new ScheduleDAO();
            dao.updateIncidentStatus(scheduleID, "ARRIVED", 0);
        } else if ("handover_bus".equals(action)) {
            int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
            ScheduleDAO dao = new ScheduleDAO();
            dao.updateIncidentStatus(scheduleID, "HANDED_OVER", 0);
        } else if ("mark_maintenance".equals(action)) {
            int busID = Integer.parseInt(request.getParameter("brokenBusID"));
            int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
            
            BusDAO busDAO = new BusDAO();
            String sql = "UPDATE Buses SET Status = N'Bảo dưỡng/Sửa chữa' WHERE BusID = ?";
            try {
                PreparedStatement st = busDAO.getConnection().prepareStatement(sql);
                st.setInt(1, busID);
                st.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            
            ScheduleDAO scheduleDAO = new ScheduleDAO();
            scheduleDAO.updateIncidentStatus(scheduleID, "TECH_RESOLVED", 0);
            
        } else if ("resolve_incident".equals(action)) {
            int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
            ScheduleDAO dao = new ScheduleDAO();
            dao.updateIncidentStatus(scheduleID, "TECH_RESOLVED", 0);
        } else if ("finish_maintenance".equals(action)) {
            int busID = Integer.parseInt(request.getParameter("busID"));
            BusDAO dao = new BusDAO();
            String sql = "UPDATE Buses SET Status = N'Sẵn sàng' WHERE BusID = ?";
            try {
                PreparedStatement st = dao.getConnection().prepareStatement(sql);
                st.setInt(1, busID);
                st.executeUpdate();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else if ("start_shift".equals(action)) {
            int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
            int userID = (int) session.getAttribute("userID");
            ScheduleDAO dao = new ScheduleDAO();
            dao.updateTechnicianScheduleStatus(scheduleID, "IN_PROGRESS");
            
            dal.UserDAO userDAO = new dal.UserDAO();
            userDAO.updateUserStatus(userID, "Đang hoạt động");
            
        } else if ("end_shift".equals(action)) {
            int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
            int userID = (int) session.getAttribute("userID");
            ScheduleDAO dao = new ScheduleDAO();
            dao.updateTechnicianScheduleStatus(scheduleID, "COMPLETED");
            
            dal.UserDAO userDAO = new dal.UserDAO();
            userDAO.updateUserStatus(userID, "Sẵn sàng");
        }

        response.sendRedirect("technician-dashboard");
    }
}
