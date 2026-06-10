package controller;

import dal.BusDAO;
import dal.RouteDAO;
import dal.ScheduleDAO;
import dal.UserDAO;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.stream.Collectors;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Bus;
import model.Route;
import model.Schedule;
import model.User;

@WebServlet(name = "ScheduleServlet", urlPatterns = {"/ScheduleServlet"})
public class ScheduleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session.getAttribute("userRole") == null || !"admin".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("dang_nhap.jsp");
            return;
        }

        UserDAO userDAO = new UserDAO();
        BusDAO busDAO = new BusDAO();
        RouteDAO routeDAO = new RouteDAO();
        ScheduleDAO scheduleDAO = new ScheduleDAO();

        List<User> drivers = userDAO.getUsersByRole("DRIVER").stream().filter(u -> "SAN_SANG".equals(u.getStatus())).collect(Collectors.toList());
        List<User> monitors = userDAO.getUsersByRole("MONITOR").stream().filter(u -> "SAN_SANG".equals(u.getStatus())).collect(Collectors.toList());
        List<Bus> buses = busDAO.getAllBuses().stream().filter(b -> !"BAO_DUONG".equals(b.getStatus())).collect(Collectors.toList());
        List<Route> routes = routeDAO.getAllRoutes();
        List<Schedule> schedules = scheduleDAO.getAllSchedules();

        request.setAttribute("drivers", drivers);
        request.setAttribute("monitors", monitors);
        request.setAttribute("buses", buses);
        request.setAttribute("routes", routes);
        request.setAttribute("schedules", schedules);

        request.getRequestDispatcher("schedule_management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        try {
            Date date = Date.valueOf(request.getParameter("date"));
            String direction = request.getParameter("direction");
            int routeID = Integer.parseInt(request.getParameter("routeID"));
            int busID = Integer.parseInt(request.getParameter("busID"));
            int driverID = Integer.parseInt(request.getParameter("driverID"));
            int monitorID = Integer.parseInt(request.getParameter("monitorID"));

            Schedule s = new Schedule(0, date, direction, routeID, busID, driverID, monitorID, "PENDING", "NORMAL");
            ScheduleDAO dao = new ScheduleDAO();
            boolean success = dao.insertSchedule(s);

            if (success) {
                response.sendRedirect("ScheduleServlet?msg=success");
            } else {
                response.sendRedirect("ScheduleServlet?msg=error");
            }
        } catch (Exception e) {
            response.sendRedirect("ScheduleServlet?msg=invalid");
        }
    }
}
