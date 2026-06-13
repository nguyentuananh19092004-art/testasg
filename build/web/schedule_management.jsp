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
    List<User> technicians = (List<User>) request.getAttribute("technicians");
    List<model.TechnicianSchedule> techSchedules = (List<model.TechnicianSchedule>) request.getAttribute("techSchedules");
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
    <% } else if("tech_success".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-success alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>Phân ca kỹ thuật thành công!</div>
    <% } else if("tech_deleted".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-success alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>Xóa ca kỹ thuật thành công!</div>
    <% } else if("tech_conflict".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-warning alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>Lỗi: Kỹ thuật viên này đã được phân công vào ngày này rồi!</div>
    <% } else if("tech_error".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-danger alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button>Có lỗi xảy ra khi xử lý ca kỹ thuật!</div>
    <% } else if("past_date".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-danger alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button><i class="bi bi-x-circle-fill me-2"></i><strong>Lỗi:</strong> Không thể phân ca cho ngày trong quá khứ!</div>
    <% } else if("timeout_school".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-danger alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button><i class="bi bi-x-circle-fill me-2"></i><strong>Lỗi:</strong> Đã quá 6h sáng, không thể phân ca chiều đi (Đến trường) cho ngày hôm nay nữa!</div>
    <% } else if("timeout_home".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-danger alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button><i class="bi bi-x-circle-fill me-2"></i><strong>Lỗi:</strong> Đã quá 16h (4h chiều), không thể phân ca chiều về (Về nhà) cho ngày hôm nay nữa!</div>
    <% } else if("tech_past_date".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-danger alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button><i class="bi bi-x-circle-fill me-2"></i><strong>Lỗi:</strong> Không thể phân ca kỹ thuật cho ngày hôm trước!</div>
    <% } %>

    <% java.util.List<String> capacityWarnings = (java.util.List<String>) request.getAttribute("capacityWarnings"); 
       if (capacityWarnings != null && !capacityWarnings.isEmpty()) { %>
        <div class="card shadow-sm border-danger mb-4">
            <div class="card-header bg-danger text-white fw-bold">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> Bảng Cảnh Báo & Đề Xuất Phân Xe Hôm Nay
            </div>
            <div class="card-body bg-light">
                <ul class="mb-0 text-danger fw-bold">
                    <% for (String warning : capacityWarnings) { %>
                        <li><%= warning %></li>
                    <% } %>
                </ul>
            </div>
        </div>
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
                                <% java.util.Map<Integer, Integer> routeStudentCounts = (java.util.Map<Integer, Integer>) request.getAttribute("routeStudentCounts"); %>
                                <% if(routes != null) for(Route r : routes) { 
                                    int c = routeStudentCounts != null && routeStudentCounts.containsKey(r.getRouteID()) ? routeStudentCounts.get(r.getRouteID()) : 0;
                                %>
                                    <option value="<%= r.getRouteID() %>"><%= r.getRouteName() %> (Đang có <%= c %> học sinh)</option>
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

    <!-- Phân ca Kỹ thuật -->
    <hr class="my-5">
    <h4 class="mb-4 text-secondary"><i class="bi bi-tools me-2"></i>Phân ca Kỹ thuật viên (Xưởng bảo dưỡng)</h4>
    <div class="row">
        <!-- Form Kỹ thuật -->
        <div class="col-md-4">
            <div class="card shadow-sm border-warning">
                <div class="card-header bg-warning text-dark fw-bold">
                    <h5 class="mb-0">Thêm Ca Kỹ Thuật</h5>
                </div>
                <div class="card-body">
                    <form action="tech-schedule" method="POST">
                        <input type="hidden" name="action" value="add">
                        <div class="mb-3">
                            <label for="techDate">Ngày làm việc</label>
                            <input type="date" id="techDate" name="date" class="form-control" required style="cursor: pointer;" onclick="this.showPicker()">
                        </div>
                        <div class="mb-4">
                            <label>Kỹ thuật viên</label>
                            <select name="technicianID" class="form-select" required>
                                <% if(technicians != null) for(User t : technicians) { %>
                                    <option value="<%= t.getUserID() %>"><%= t.getFullName() %></option>
                                <% } %>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-warning w-100 fw-bold"><i class="bi bi-plus-circle me-1"></i> Lưu ca Kỹ thuật</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Danh sách ca kỹ thuật -->
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header bg-white">
                    <h5 class="mb-0">Danh sách Ca Kỹ thuật</h5>
                </div>
                <div class="card-body p-0 table-responsive">
                    <table class="table table-hover table-striped mb-0 text-nowrap">
                        <thead class="table-light">
                            <tr>
                                <th>ID Ca</th>
                                <th>Ngày làm việc</th>
                                <th>Tên Kỹ thuật viên</th>
                                <th>Ngày tạo</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if(techSchedules != null && !techSchedules.isEmpty()) { 
                                for(model.TechnicianSchedule ts : techSchedules) { %>
                                <tr>
                                    <td>#<%= ts.getTechScheduleID() %></td>
                                    <td class="fw-bold text-primary"><%= ts.getDate() %></td>
                                    <td><%= ts.getTechnicianName() %></td>
                                    <td class="text-muted"><%= new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(ts.getCreatedAt()) %></td>
                                    <td>
                                        <form action="tech-schedule" method="POST" style="display:inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="<%= ts.getTechScheduleID() %>">
                                            <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa ca kỹ thuật này?');">
                                                <i class="bi bi-trash"></i> Xóa
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            <% } } else { %>
                                <tr>
                                    <td colspan="5" class="text-center py-3 text-muted">Chưa có lịch phân ca kỹ thuật nào.</td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
