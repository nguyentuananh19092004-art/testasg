package controller;

import dal.BusDAO;
import dal.UserDAO;
import java.io.IOException;
import java.sql.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "DailyStatusServlet", urlPatterns = {"/daily-status"})
public class DailyStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        String type = request.getParameter("type"); // "user" or "bus"
        String dateStr = request.getParameter("date");
        Date date = Date.valueOf(dateStr);
        
        if ("user".equals(type)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String role = request.getParameter("role");
            UserDAO dao = new UserDAO();
            if ("cancel_leave".equals(action)) {
                dao.deleteUserLeave(id, date);
            } else if ("report_leave".equals(action)) {
                dao.insertUserLeave(id, date, "Nghỉ phép", "APPROVED");
            }
            response.sendRedirect("user-list?role=" + role + "&date=" + dateStr);
        } else if ("bus".equals(type)) {
            int id = Integer.parseInt(request.getParameter("id"));
            BusDAO dao = new BusDAO();
            if ("cancel_maint".equals(action)) {
                dao.deleteBusMaintenance(id, date);
            } else if ("report_maint".equals(action)) {
                dao.insertBusMaintenance(id, date, "Bảo dưỡng định kỳ");
            }
            response.sendRedirect("bus-list?date=" + dateStr);
        }
    }
}
