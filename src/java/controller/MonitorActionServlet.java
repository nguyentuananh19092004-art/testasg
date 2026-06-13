package controller;

import dal.ScheduleProgressDAO;
import dal.NotificationDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "MonitorActionServlet", urlPatterns = {"/monitor-action"})
public class MonitorActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        if (session.getAttribute("userRole") == null || !"giamthi".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("dang_nhap.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("reach_stop".equals(action)) {
            int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
            int stopID = Integer.parseInt(request.getParameter("stopID"));
            ScheduleProgressDAO dao = new ScheduleProgressDAO();
            dao.insertProgress(scheduleID, stopID);
        } else if ("notify_parent".equals(action)) {
            String hocSinhTK = request.getParameter("hocSinhTK");
            String stopName = request.getParameter("stopName");
            String message = "Xe buýt đã gần đến điểm đón: " + stopName + ". Phụ huynh vui lòng chuẩn bị cho học sinh ra điểm đón!";
            NotificationDAO dao = new NotificationDAO();
            dao.insertNotification(hocSinhTK, message); // The Username in Notification table matches the HocSinh.TenTK which is the Parent's account.
        } else if ("mark_attendance".equals(action)) {
            int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
            int stopID = Integer.parseInt(request.getParameter("stopID"));
            String maHocSinh = request.getParameter("maHocSinh");
            boolean isAbsent = Boolean.parseBoolean(request.getParameter("isAbsent"));
            String direction = request.getParameter("direction");
            
            dal.AttendanceDAO dao = new dal.AttendanceDAO();
            dao.insertAttendance(scheduleID, maHocSinh, stopID, isAbsent, direction);
        } else if ("complete_trip".equals(action)) {
            int scheduleID = Integer.parseInt(request.getParameter("scheduleID"));
            ScheduleProgressDAO dao = new ScheduleProgressDAO();
            dao.insertProgress(scheduleID, -1); // -1 marks that the monitor has completed the trip
        }

        response.sendRedirect("monitor-dashboard");
    }
}
