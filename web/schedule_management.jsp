<%@page import="model.Schedule"%>
<%@page import="model.Route"%>
<%@page import="model.Bus"%>
<%@page import="model.User"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("userRole") == null || !"admin".equals(session.getAttribute("userRole"))) {
        response.sendRedirect("dang_nhap.jsp");
        return;
    }
    List<User> drivers = (List<User>) request.getAttribute("drivers");
    List<User> monitors = (List<User>) request.getAttribute("monitors");
    List<Bus> buses = (List<Bus>) request.getAttribute("buses");
    List<Route> routes = (List<Route>) request.getAttribute("routes");
    List<Schedule> schedules = (List<Schedule>) request.getAttribute("schedules");
%>
<%!
    String getBusPlate(List<Bus> buses, int id) {
        if (buses != null) {
            for (Bus b : buses) {
                if (b.getBusID() == id) return b.getLicensePlate();
            }
        }
        return "Unknown";
    }
    String getUserName(List<User> users, int id) {
        if (users != null) {
            for (User u : users) {
                if (u.getUserID() == id) return u.getFullName();
            }
        }
        return "Unknown";
    }
    String getRouteName(List<Route> routes, int id) {
        if (routes != null) {
            for (Route r : routes) {
                if (r.getRouteID() == id) return r.getRouteName();
            }
        }
        return "Unknown";
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Phân ca & Lịch trình - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-dark mb-4">
    <div class="container">
        <a class="navbar-brand" href="AdminDashboardServlet"><i class="bi bi-arrow-left"></i> Về Dashboard</a>
        <span class="navbar-text text-white">Quản lý Phân Ca</span>
    </div>
</nav>

<div class="container">
    <% if("success".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-success alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>Thêm phân ca thành công!</div>
    <% } else if("deleted".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-success alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>Xóa phân ca thành công!</div>
    <% } else if("conflict".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-warning alert-dismissible fade show">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> <strong>Cảnh báo:</strong> Xe bus, Tài xế, hoặc Giám thị này đã được phân công vào ca này rồi! Bạn không thể phân công trùng lặp.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } else if("error".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-danger alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>Có lỗi xảy ra!</div>
    <% } %>

    <div class="row">
        <!-- Form Phân ca -->
        <div class="col-md-4">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">Thêm Ca Mới</h5>
                </div>
                <div class="card-body">
                    <form action="ScheduleServlet" method="POST">
                        <div class="mb-3">
                            <label for="scheduleDate">Ngày chạy</label>
                            <input type="date" id="scheduleDate" name="date" class="form-control" required style="cursor: pointer;" onclick="this.showPicker()">
                        </div>
                        <div class="mb-3">
                            <label>Chiều đi</label>
                            <select name="direction" class="form-select">
                                <option value="TO_SCHOOL">Đến trường</option>
                                <option value="TO_HOME">Về nhà</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label>Tuyến đường</label>
                            <select name="routeID" class="form-select">
                                <% if(routes != null) for(Route r : routes) { %>
                                    <option value="<%= r.getRouteID() %>"><%= r.getRouteName() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label>Xe Bus</label>
                            <select name="busID" class="form-select">
                                <% if(buses != null) for(Bus b : buses) { %>
                                    <option value="<%= b.getBusID() %>"><%= b.getLicensePlate() %> (<%= b.getCapacity() %> chỗ)</option>
                                <% } %>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label>Tài xế</label>
                            <select name="driverID" class="form-select">
                                <% if(drivers != null) for(User d : drivers) { %>
                                    <option value="<%= d.getUserID() %>"><%= d.getFullName() %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label>Giám thị</label>
                            <select name="monitorID" class="form-select">
                                <% if(monitors != null) for(User m : monitors) { %>
                                    <option value="<%= m.getUserID() %>"><%= m.getFullName() %></option>
                                <% } %>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Lưu phân ca</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Danh sách ca đã phân -->
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header bg-white">
                    <h5 class="mb-0">Danh sách Phân ca</h5>
                </div>
                <div class="card-body p-0 table-responsive">
                    <table class="table table-hover table-striped mb-0 text-nowrap">
                        <thead class="table-light">
                            <tr>
                                <th>ID</th>
                                <th>Ngày</th>
                                <th>Chiều</th>
                                <th>Tuyến</th>
                                <th>Xe Bus</th>
                                <th>Tài xế</th>
                                <th>Giám thị</th>
                                <th>Trạng thái</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if(schedules != null) { 
                                for(Schedule s : schedules) { %>
                                <tr>
                                    <td>#<%= s.getScheduleID() %></td>
                                    <td><%= s.getDate() %></td>
                                    <td><%= s.getDirection().equals("TO_SCHOOL") ? "Đến trường" : "Về nhà" %></td>
                                    <td>LT<%= s.getRouteID() %></td>
                                    <td><%= getBusPlate(buses, s.getBusID()) %></td>
                                    <td><%= getUserName(drivers, s.getDriverID()) %></td>
                                    <td><%= getUserName(monitors, s.getMonitorID()) %></td>
                                    <td><span class="badge bg-warning"><%= s.getStatus() %></span></td>
                                    <td>
                                        <a href="ScheduleServlet?action=delete&id=<%= s.getScheduleID() %>" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa lịch phân ca này không?');">
                                            <i class="bi bi-trash"></i> Xóa
                                        </a>
                                    </td>
                                </tr>
                            <% } } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
