package controller;

import dal.HocSinhDAO;
import dal.NotificationDAO;
import model.HocSinh;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "ParentActionServlet", urlPatterns = {"/parent-action"})
public class ParentActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        if (session.getAttribute("userRole") == null || !"phuhuynh".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("dang_nhap.jsp");
            return;
        }

        String action = request.getParameter("action");
        String username = (String) session.getAttribute("username");
        HocSinhDAO hsDAO = new HocSinhDAO();
        HocSinh student = hsDAO.getHocSinhByTenTK(username);
        
        if (student == null) {
            response.sendRedirect("dang_nhap.jsp");
            return;
        }

        if ("report_absent".equals(action)) {
            student.setTrangThai("Nghỉ");
            hsDAO.updateHocSinh(student);
            
            // Optionally, we can also insert a Notification for Monitor or Admin, but updating TrangThai is enough since Monitor UI shows it.
        } else if ("change_stop".equals(action)) {
            String stopRoute = request.getParameter("stopRoute");
            if (stopRoute != null && stopRoute.contains("_")) {
                String[] parts = stopRoute.split("_");
                int stopID = Integer.parseInt(parts[0]);
                int routeID = Integer.parseInt(parts[1]);
                student.setDefaultStopID(stopID);
                student.setDefaultRouteID(routeID);
                student.setTrangThai("Sử dụng");
                hsDAO.updateHocSinh(student);
            }
        } else if ("mark_read".equals(action)) {
            int notifID = Integer.parseInt(request.getParameter("notifID"));
            NotificationDAO notifDAO = new NotificationDAO();
            notifDAO.markAsRead(notifID);
        }

        response.sendRedirect("parent-dashboard");
    }
}
