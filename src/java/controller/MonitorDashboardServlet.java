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
                List<Schedule> allSchedules = scheduleDAO.getAllSchedules();
                List<Schedule> relatedSchedules = allSchedules.stream()
                        .filter(s -> s.getRouteID() == activeSchedule.getRouteID() &&
                                     s.getDate().toString().equals(activeSchedule.getDate().toString()) &&
                                     s.getDirection().equals(activeSchedule.getDirection()) &&
                                     !"CANCELLED".equals(s.getStatus()))
                        .sorted((s1, s2) -> Integer.compare(s1.getScheduleID(), s2.getScheduleID()))
                        .collect(java.util.stream.Collectors.toList());

                List<HocSinh> allRouteStudents = new java.util.ArrayList<>();
                for (Stop s : stops) {
                    List<HocSinh> hsList = hsDAO.getHocSinhByStopID(s.getStopID());
                    for (HocSinh hs : hsList) {
                        if ("Sử dụng".equals(hs.getTrangThai()) || "Nghỉ".equals(hs.getTrangThai())) {
                            allRouteStudents.add(hs);
                        }
                    }
                }
                allRouteStudents.sort((h1, h2) -> h1.getMaHocSinh().compareTo(h2.getMaHocSinh()));

                List<HocSinh> assignedStudents = new java.util.ArrayList<>();
                int currentIndex = 0;
                for (Schedule s : relatedSchedules) {
                    model.Bus b = busDAO.getBusById(s.getBusID());
                    int capacity = b != null ? Math.max(0, b.getCapacity() - 2) : 0;
                    
                    if (s.getScheduleID() == activeSchedule.getScheduleID()) {
                        int endIndex = Math.min(currentIndex + capacity, allRouteStudents.size());
                        if (currentIndex < allRouteStudents.size()) {
                            assignedStudents = new java.util.ArrayList<>(allRouteStudents.subList(currentIndex, endIndex));
                        }
                        break;
                    }
                    currentIndex += capacity;
                }

                Map<Integer, List<HocSinh>> studentsByStop = new HashMap<>();
                for (Stop s : stops) {
                    List<HocSinh> stopStudents = assignedStudents.stream()
                            .filter(hs -> hs.getDefaultStopID() != null && hs.getDefaultStopID() == s.getStopID())
                            .collect(java.util.stream.Collectors.toList());
                    studentsByStop.put(s.getStopID(), stopStudents);
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
