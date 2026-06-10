package controller;

import dal.HocSinhDAO;
import dal.StopDAO;
import dal.NotificationDAO;
import dal.ScheduleDAO;
import model.HocSinh;
import model.Stop;
import model.Notification;
import model.Schedule;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ParentDashboardServlet", urlPatterns = {"/parent-dashboard"})
public class ParentDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("userRole") == null || !"phuhuynh".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("dang_nhap.jsp");
            return;
        }

        String username = (String) session.getAttribute("username");
        HocSinhDAO hsDAO = new HocSinhDAO();
        HocSinh student = hsDAO.getHocSinhByTenTK(username);
        
        if (student != null) {
            request.setAttribute("student", student);
            
            StopDAO stopDAO = new StopDAO();
            List<Stop> allStops = stopDAO.getAllStops();
            request.setAttribute("allStops", allStops);
            
            if (student.getDefaultStopID() != null) {
                // Find stop details
                Stop currentStop = allStops.stream().filter(s -> s.getStopID() == student.getDefaultStopID()).findFirst().orElse(null);
                request.setAttribute("currentStop", currentStop);
                
                // Find if there is an active schedule moving towards this stop
                ScheduleDAO scheduleDAO = new ScheduleDAO();
                Schedule activeSchedule = scheduleDAO.getActiveScheduleForStop(student.getDefaultStopID());
                request.setAttribute("activeSchedule", activeSchedule);
            }
            
            NotificationDAO notifDAO = new NotificationDAO();
            List<Notification> notifications = notifDAO.getNotificationsByUsername(username);
            request.setAttribute("notifications", notifications);
        }

        request.getRequestDispatcher("phuhuynh_dashboard.jsp").forward(request, response);
    }
}
