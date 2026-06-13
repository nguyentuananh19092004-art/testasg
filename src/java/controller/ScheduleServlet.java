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

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                ScheduleDAO sDao = new ScheduleDAO();
                boolean success = sDao.deleteSchedule(id);
                if (success) {
                    response.sendRedirect("ScheduleServlet?msg=deleted");
                } else {
                    response.sendRedirect("ScheduleServlet?msg=error");
                }
                return;
            } catch (Exception e) {
                response.sendRedirect("ScheduleServlet?msg=error");
                return;
            }
        }

        UserDAO userDAO = new UserDAO();
        BusDAO busDAO = new BusDAO();
        RouteDAO routeDAO = new RouteDAO();
        ScheduleDAO scheduleDAO = new ScheduleDAO();

        List<User> drivers = userDAO.getUsersByRole("DRIVER").stream().filter(u -> "Sẵn sàng".equals(u.getStatus())).collect(Collectors.toList());
        List<User> monitors = userDAO.getUsersByRole("MONITOR").stream().filter(u -> "Sẵn sàng".equals(u.getStatus())).collect(Collectors.toList());
        List<User> technicians = userDAO.getUsersByRole("TECHNICIAN").stream().filter(u -> "Sẵn sàng".equals(u.getStatus())).collect(Collectors.toList());
        
        List<Bus> buses = busDAO.getAllBuses().stream().filter(b -> !"Bảo dưỡng/Sửa chữa".equals(b.getStatus())).collect(Collectors.toList());
        List<Route> routes = routeDAO.getAllRoutes();
        List<Schedule> schedules = scheduleDAO.getAllSchedules();
        
        dal.HocSinhDAO hsDAO = new dal.HocSinhDAO();
        java.util.Map<Integer, Integer> routeStudentCounts = new java.util.HashMap<>();
        List<String> capacityWarnings = new java.util.ArrayList<>();
        java.time.LocalDate today = java.time.LocalDate.now();
        java.sql.Date sqlToday = java.sql.Date.valueOf(today);
        
        for (Route r : routes) {
            int students = hsDAO.countActiveHocSinhByRoute(r.getRouteID());
            routeStudentCounts.put(r.getRouteID(), students);
            
            if (students > 0) {
                int optimal47 = students / 45;
                int remainder = students % 45;
                int optimal29 = 0;
                if (remainder > 0) {
                    if (remainder <= 27) {
                        optimal29 = 1;
                    } else {
                        optimal47++;
                    }
                }
                String suggestion = (optimal47 > 0 ? optimal47 + " xe 47 chỗ " : "") + (optimal29 > 0 ? optimal29 + " xe 29 chỗ" : "");
                
                int assignedSchool = 0;
                int assignedHome = 0;
                for (Schedule s : schedules) {
                    if (s.getRouteID() == r.getRouteID() && s.getDate().equals(sqlToday)) {
                        Bus b = buses.stream().filter(bus -> bus.getBusID() == s.getBusID()).findFirst().orElse(null);
                        if (b != null) {
                            if ("TO_SCHOOL".equals(s.getDirection())) assignedSchool += (b.getCapacity() - 2);
                            if ("TO_HOME".equals(s.getDirection())) assignedHome += (b.getCapacity() - 2);
                        }
                    }
                }
                
                if (assignedSchool < students) {
                    capacityWarnings.add("Tuyến " + r.getRouteName() + " (Đến trường hôm nay): Có " + students + " học sinh đăng ký. Đã gán sức chứa: " + assignedSchool + ". Còn thiếu: " + (students - assignedSchool) + " chỗ. Đề xuất tổng cộng: " + suggestion);
                }
                if (assignedHome < students) {
                    capacityWarnings.add("Tuyến " + r.getRouteName() + " (Về nhà hôm nay): Có " + students + " học sinh đăng ký. Đã gán sức chứa: " + assignedHome + ". Còn thiếu: " + (students - assignedHome) + " chỗ. Đề xuất tổng cộng: " + suggestion);
                }
            }
        }
        request.setAttribute("routeStudentCounts", routeStudentCounts);
        request.setAttribute("capacityWarnings", capacityWarnings);
        
        List<model.TechnicianSchedule> techSchedules = scheduleDAO.getTechnicianSchedules();

        request.setAttribute("drivers", drivers);
        request.setAttribute("monitors", monitors);
        request.setAttribute("technicians", technicians);
        request.setAttribute("buses", buses);
        request.setAttribute("routes", routes);
        request.setAttribute("schedules", schedules);
        request.setAttribute("techSchedules", techSchedules);

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

            java.time.LocalDate scheduleDate = date.toLocalDate();
            java.time.LocalDateTime now = java.time.LocalDateTime.now();
            java.time.LocalDate today = now.toLocalDate();

            if (scheduleDate.isBefore(today)) {
                response.sendRedirect("ScheduleServlet?msg=past_date");
                return;
            }

            if (scheduleDate.isEqual(today)) {
                if ("TO_SCHOOL".equals(direction) && now.getHour() >= 6) {
                    response.sendRedirect("ScheduleServlet?msg=timeout_school");
                    return;
                }
                if ("TO_HOME".equals(direction) && now.getHour() >= 16) {
                    response.sendRedirect("ScheduleServlet?msg=timeout_home");
                    return;
                }
            }

            ScheduleDAO dao = new ScheduleDAO();

            if (dao.isConflict(date, direction, driverID, monitorID, busID)) {
                response.sendRedirect("ScheduleServlet?msg=conflict");
                return;
            }

            Schedule s = new Schedule(0, date, direction, routeID, busID, driverID, monitorID, "PENDING", "NORMAL");
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
