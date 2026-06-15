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
        
        // Handle selectedDate
        String dateParam = request.getParameter("selectedDate");
        java.time.LocalDate selectedDate;
        if (dateParam != null && !dateParam.isEmpty()) {
            selectedDate = java.time.LocalDate.parse(dateParam);
        } else {
            selectedDate = java.time.LocalDate.now().plusDays(1); // Default to tomorrow
        }
        java.sql.Date sqlSelectedDate = java.sql.Date.valueOf(selectedDate);
        request.setAttribute("selectedDate", selectedDate.toString());
        
        // Filter schedules to only show the selected date
        schedules = schedules.stream().filter(s -> s.getDate().toString().equals(sqlSelectedDate.toString())).collect(Collectors.toList());
        
        for (Route r : routes) {
            int students = hsDAO.countActiveHocSinhByRoute(r.getRouteID());
            routeStudentCounts.put(r.getRouteID(), students);
            
            if (students > 0) {
                int optimal9 = students / 7;
                int remainder = students % 7;
                int optimal7 = 0;
                if (remainder > 0) {
                    if (remainder <= 5) {
                        optimal7 = 1;
                    } else {
                        optimal9++;
                    }
                }
                String suggestion = (optimal9 > 0 ? optimal9 + " xe 9 chỗ " : "") + (optimal7 > 0 ? optimal7 + " xe 7 chỗ" : "");
                
                int assignedSchool = 0;
                int assignedHome = 0;
                for (Schedule s : schedules) {
                    if (s.getRouteID() == r.getRouteID() && s.getDate().toString().equals(sqlSelectedDate.toString())) {
                        Bus b = buses.stream().filter(bus -> bus.getBusID() == s.getBusID()).findFirst().orElse(null);
                        if (b != null) {
                            if ("TO_SCHOOL".equals(s.getDirection())) assignedSchool += (b.getCapacity() - 2);
                            if ("TO_HOME".equals(s.getDirection())) assignedHome += (b.getCapacity() - 2);
                        }
                    }
                }
                
                if (assignedSchool < students) {
                    capacityWarnings.add("Tuyến " + r.getRouteName() + " (Đến trường ngày " + selectedDate.toString() + "): Có " + students + " học sinh đăng ký. Đã gán: " + assignedSchool + ". Còn thiếu: " + (students - assignedSchool) + " chỗ. Đề xuất: " + suggestion);
                }
                if (assignedHome < students) {
                    capacityWarnings.add("Tuyến " + r.getRouteName() + " (Về nhà ngày " + selectedDate.toString() + "): Có " + students + " học sinh đăng ký. Đã gán: " + assignedHome + ". Còn thiếu: " + (students - assignedHome) + " chỗ. Đề xuất: " + suggestion);
                }
            }
        }
        request.setAttribute("routeStudentCounts", routeStudentCounts);
        request.setAttribute("capacityWarnings", capacityWarnings);
        
        List<model.TechnicianSchedule> techSchedules = scheduleDAO.getTechnicianSchedules();
        techSchedules = techSchedules.stream().filter(ts -> ts.getDate().toString().equals(sqlSelectedDate.toString())).collect(Collectors.toList());

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

            String paramStr = "&selectedDate=" + date.toString() + "&direction=" + direction + "&routeID=" + routeID + "&busID=" + busID + "&driverID=" + driverID + "&monitorID=" + monitorID;

            if (scheduleDate.isBefore(today)) {
                response.sendRedirect("ScheduleServlet?msg=past_date" + paramStr);
                return;
            }

            if (scheduleDate.isEqual(today)) {
                if ("TO_SCHOOL".equals(direction) && now.getHour() >= 6) {
                    response.sendRedirect("ScheduleServlet?msg=timeout_school" + paramStr);
                    return;
                }
                if ("TO_HOME".equals(direction) && now.getHour() >= 16) {
                    response.sendRedirect("ScheduleServlet?msg=timeout_home" + paramStr);
                    return;
                }
            }

            ScheduleDAO dao = new ScheduleDAO();
            
            // Check Capacity Override
            dal.HocSinhDAO hsDAO = new dal.HocSinhDAO();
            int students = hsDAO.countActiveHocSinhByRoute(routeID);
            
            if (students == 0) {
                 response.sendRedirect("ScheduleServlet?msg=no_students" + paramStr);
                 return;
            }
            
            // Calculate current assigned capacity
            java.util.List<Schedule> allSchedules = dao.getAllSchedules();
            dal.BusDAO busDAO = new dal.BusDAO();
            int currentAssignedCapacity = 0;
            for (Schedule s : allSchedules) {
                if (s.getRouteID() == routeID && s.getDate().toString().equals(date.toString()) && s.getDirection().equals(direction) && !"CANCELLED".equals(s.getStatus())) {
                    model.Bus b = busDAO.getBusById(s.getBusID());
                    if (b != null) {
                        currentAssignedCapacity += (b.getCapacity() - 2);
                    }
                }
            }
            
            if (currentAssignedCapacity >= students) {
                 response.sendRedirect("ScheduleServlet?msg=overcapacity" + paramStr);
                 return;
            }

            if (dao.isConflict(date, direction, driverID, monitorID, busID)) {
                response.sendRedirect("ScheduleServlet?msg=conflict" + paramStr);
                return;
            }

            Schedule s = new Schedule(0, date, direction, routeID, busID, driverID, monitorID, "PENDING", "NORMAL");
            boolean success = dao.insertSchedule(s);

            if (success) {
                response.sendRedirect("ScheduleServlet?msg=success&selectedDate=" + date.toString());
            } else {
                response.sendRedirect("ScheduleServlet?msg=error" + paramStr);
            }
        } catch (Exception e) {
            response.sendRedirect("ScheduleServlet?msg=invalid");
        }
    }
}
