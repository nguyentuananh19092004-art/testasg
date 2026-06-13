package controller;

import dal.ScheduleDAO;
import dal.StopDAO;
import dal.UserDAO;
import dal.HocSinhDAO;
import dal.ScheduleProgressDAO;
import dal.BusDAO;
import model.Schedule;
import model.Stop;
import model.User;
import model.HocSinh;
import model.ScheduleProgress;
import dal.AttendanceDAO;
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

@WebServlet(name = "MonitorDashboardServlet", urlPatterns = {"/monitor-dashboard"})
public class MonitorDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("userRole") == null || !"giamthi".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("dang_nhap.jsp");
            return;
        }

        String username = (String) session.getAttribute("username");
        UserDAO userDAO = new UserDAO();
        User monitor = userDAO.getUserByUsername(username);

        if (monitor != null) {
            ScheduleDAO scheduleDAO = new ScheduleDAO();
            Schedule activeSchedule = scheduleDAO.getActiveScheduleByMonitor(monitor.getUserID());

            if (activeSchedule != null) {
                request.setAttribute("activeSchedule", activeSchedule);
                
                BusDAO busDAO = new BusDAO();
                request.setAttribute("bus", busDAO.getBusById(activeSchedule.getBusID()));

                StopDAO stopDAO = new StopDAO();
                List<Stop> stops = stopDAO.getStopsByRoute(activeSchedule.getRouteID());
                if ("Về nhà".equals(activeSchedule.getDirection())) {
                    java.util.Collections.reverse(stops);
                }
                request.setAttribute("stops", stops);

                HocSinhDAO hsDAO = new HocSinhDAO();
                Map<Integer, List<HocSinh>> studentsByStop = new HashMap<>();
                for (Stop s : stops) {
                    studentsByStop.put(s.getStopID(), hsDAO.getHocSinhByStopID(s.getStopID()));
                }
                request.setAttribute("studentsByStop", studentsByStop);

                ScheduleProgressDAO progressDAO = new ScheduleProgressDAO();
                List<ScheduleProgress> progresses = progressDAO.getProgressBySchedule(activeSchedule.getScheduleID());
                List<Integer> reachedStops = progresses.stream().map(ScheduleProgress::getStopID).collect(java.util.stream.Collectors.toList());
                request.setAttribute("reachedStops", reachedStops);
                
                AttendanceDAO attendanceDAO = new AttendanceDAO();
                List<String> attendedStudents = attendanceDAO.getAttendedStudents(activeSchedule.getScheduleID());
                request.setAttribute("attendedStudents", attendedStudents);
            }
        }

        request.getRequestDispatcher("giamthi_dashboard.jsp").forward(request, response);
    }
}
