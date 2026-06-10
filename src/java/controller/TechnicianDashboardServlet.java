package controller;

import dal.ScheduleDAO;
import dal.BusDAO;
import model.Schedule;
import model.Bus;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "TechnicianDashboardServlet", urlPatterns = {"/technician-dashboard"})
public class TechnicianDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("userRole") == null || !"kythuat".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("dang_nhap.jsp");
            return;
        }

        ScheduleDAO scheduleDAO = new ScheduleDAO();
        List<Schedule> incidentSchedules = scheduleDAO.getIncidentSchedules();
        request.setAttribute("incidentSchedules", incidentSchedules);

        BusDAO busDAO = new BusDAO();
        List<Bus> maintenanceBuses = busDAO.getAllBuses().stream().filter(b -> "BAO_DUONG".equals(b.getStatus())).collect(java.util.stream.Collectors.toList());
        request.setAttribute("maintenanceBuses", maintenanceBuses);
        
        Map<Integer, Bus> busMap = new HashMap<>();
        for(Schedule s : incidentSchedules) {
            if(!busMap.containsKey(s.getBusID())) {
                busMap.put(s.getBusID(), busDAO.getBusById(s.getBusID()));
            }
        }
        request.setAttribute("busMap", busMap);

        request.getRequestDispatcher("kythuat_dashboard.jsp").forward(request, response);
    }
}
