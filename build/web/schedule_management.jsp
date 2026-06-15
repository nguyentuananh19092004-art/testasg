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
    String checkSelected(String errDir, String targetDir, String paramVal, int currentVal) {
        if (errDir != null && errDir.equals(targetDir) && paramVal != null && paramVal.equals(String.valueOf(currentVal))) {
            return "selected";
        }
        return "";
    }
    String checkDefault(String errDir, String targetDir, String paramVal) {
        if (errDir != null && errDir.equals(targetDir) && paramVal != null && !paramVal.isEmpty()) {
            return "";
        }
        return "selected";
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
    <% } else if("overcapacity".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-danger alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button><i class="bi bi-x-circle-fill me-2"></i><strong>Lỗi:</strong> Không thể phân thêm xe! Tuyến này đã đủ sức chứa cho số lượng học sinh hiện tại (không cần thêm xe).</div>
    <% } else if("no_students".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-danger alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button><i class="bi bi-x-circle-fill me-2"></i><strong>Lỗi:</strong> Không thể phân xe! Tuyến này hiện không có học sinh nào đăng ký hoạt động.</div>
    <% } else if("tech_on_leave".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-danger alert-dismissible fade show"><button type="button" class="btn-close" data-bs-dismiss="alert"></button><i class="bi bi-x-circle-fill me-2"></i><strong>Lỗi:</strong> Nhân sự này đã được duyệt nghỉ phép vào ngày được chọn!</div>
    <% } %>

    <% 
       String errDir = request.getParameter("direction");
       String errRoute = request.getParameter("routeID");
       String errBus = request.getParameter("busID");
       String errDriver = request.getParameter("driverID");
       String errMonitor = request.getParameter("monitorID");
       String selectedDate = (String) request.getAttribute("selectedDate"); 
    %>
    <!-- Date Picker Form -->
    <div class="card shadow-sm mb-4 border-info">
        <div class="card-body bg-light d-flex align-items-center">
            <h5 class="mb-0 me-3 text-info"><i class="bi bi-calendar3 me-2"></i>Chọn ngày phân ca:</h5>
            <form action="ScheduleServlet" method="GET" class="d-flex m-0" id="dateForm">
                <input type="date" name="selectedDate" value="<%= selectedDate %>" class="form-control" required onchange="document.getElementById('dateForm').submit();" style="cursor: pointer;" onclick="this.showPicker()">
            </form>
        </div>
    </div>

    <% java.util.List<String> capacityWarnings = (java.util.List<String>) request.getAttribute("capacityWarnings"); 
       if (capacityWarnings != null && !capacityWarnings.isEmpty()) { %>
        <div class="card shadow-sm border-danger mb-4">
            <div class="card-header bg-danger text-white fw-bold">
                <i class="bi bi-exclamation-triangle-fill me-2"></i> Bảng Cảnh Báo & Đề Xuất Phân Xe Ngày <%= selectedDate %>
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

    <div class="row mb-4">
        <!-- Form Phân ca Đến trường -->
        <div class="col-md-6">
            <div class="card shadow-sm border-primary">
                <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="bi bi-sun me-2"></i>Phân ca Chiều đi (Đến trường)</h5>
                    <span class="badge bg-light text-primary"><%= selectedDate %></span>
                </div>
                <div class="card-body">
                    <form action="ScheduleServlet" method="POST">
                        <input type="hidden" name="date" value="<%= selectedDate %>">
                        <input type="hidden" name="direction" value="TO_SCHOOL">
                        <div class="mb-3">
                            <label>Tuyến đường</label>
                            <select name="routeID" class="form-select" required>
                                <option value="" disabled <%= checkDefault(errDir, "TO_SCHOOL", errRoute) %>>-- Chọn tuyến đường --</option>
                                <% java.util.Map<Integer, Integer> routeStudentCounts = (java.util.Map<Integer, Integer>) request.getAttribute("routeStudentCounts"); %>
                                <% if(routes != null) for(Route r : routes) { 
                                    int c = routeStudentCounts != null && routeStudentCounts.containsKey(r.getRouteID()) ? routeStudentCounts.get(r.getRouteID()) : 0;
                                %>
                                    <option value="<%= r.getRouteID() %>" <%= checkSelected(errDir, "TO_SCHOOL", errRoute, r.getRouteID()) %>><%= r.getRouteName() %> (Đang có <%= c %> học sinh)</option>
                                <% } %>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label>Xe Bus</label>
                            <select name="busID" class="form-select" required>
                                <option value="" disabled <%= checkDefault(errDir, "TO_SCHOOL", errBus) %>>-- Chọn xe bus --</option>
                                <% if(buses != null) for(Bus b : buses) { %>
                                    <option value="<%= b.getBusID() %>" <%= checkSelected(errDir, "TO_SCHOOL", errBus, b.getBusID()) %>><%= b.getLicensePlate() %> (<%= b.getCapacity() %> chỗ)</option>
                                <% } %>
                            </select>
                        </div>
                        <div class="row mb-3">
                            <div class="col-6">
                                <label>Tài xế</label>
                                <select name="driverID" class="form-select" required>
                                    <option value="" disabled <%= checkDefault(errDir, "TO_SCHOOL", errDriver) %>>-- Chọn tài xế --</option>
                                    <% if(drivers != null) for(User d : drivers) { %>
                                        <option value="<%= d.getUserID() %>" <%= checkSelected(errDir, "TO_SCHOOL", errDriver, d.getUserID()) %>><%= d.getFullName() %></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="col-6">
                                <label>Giám thị</label>
                                <select name="monitorID" class="form-select" required>
                                    <option value="" disabled <%= checkDefault(errDir, "TO_SCHOOL", errMonitor) %>>-- Chọn giám thị --</option>
                                    <% if(monitors != null) for(User m : monitors) { %>
                                        <option value="<%= m.getUserID() %>" <%= checkSelected(errDir, "TO_SCHOOL", errMonitor, m.getUserID()) %>><%= m.getFullName() %></option>
                                    <% } %>
                                </select>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary w-100 fw-bold"><i class="bi bi-floppy me-2"></i>Lưu ca Đến trường</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- Form Phân ca Về nhà -->
        <div class="col-md-6">
            <div class="card shadow-sm border-success">
                <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0"><i class="bi bi-moon-stars me-2"></i>Phân ca Chiều về (Về nhà)</h5>
                    <span class="badge bg-light text-success"><%= selectedDate %></span>
                </div>
                <div class="card-body">
                    <form action="ScheduleServlet" method="POST">
                        <input type="hidden" name="date" value="<%= selectedDate %>">
                        <input type="hidden" name="direction" value="TO_HOME">
                        <div class="mb-3">
                            <label>Tuyến đường</label>
                            <select name="routeID" class="form-select" required>
                                <option value="" disabled <%= checkDefault(errDir, "TO_HOME", errRoute) %>>-- Chọn tuyến đường --</option>
                                <% if(routes != null) for(Route r : routes) { 
                                    int c = routeStudentCounts != null && routeStudentCounts.containsKey(r.getRouteID()) ? routeStudentCounts.get(r.getRouteID()) : 0;
                                %>
                                    <option value="<%= r.getRouteID() %>" <%= checkSelected(errDir, "TO_HOME", errRoute, r.getRouteID()) %>><%= r.getRouteName() %> (Đang có <%= c %> học sinh)</option>
                                <% } %>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label>Xe Bus</label>
                            <select name="busID" class="form-select" required>
                                <option value="" disabled <%= checkDefault(errDir, "TO_HOME", errBus) %>>-- Chọn xe bus --</option>
                                <% if(buses != null) for(Bus b : buses) { %>
                                    <option value="<%= b.getBusID() %>" <%= checkSelected(errDir, "TO_HOME", errBus, b.getBusID()) %>><%= b.getLicensePlate() %> (<%= b.getCapacity() %> chỗ)</option>
                                <% } %>
                            </select>
                        </div>
                        <div class="row mb-3">
                            <div class="col-6">
                                <label>Tài xế</label>
                                <select name="driverID" class="form-select" required>
                                    <option value="" disabled <%= checkDefault(errDir, "TO_HOME", errDriver) %>>-- Chọn tài xế --</option>
                                    <% if(drivers != null) for(User d : drivers) { %>
                                        <option value="<%= d.getUserID() %>" <%= checkSelected(errDir, "TO_HOME", errDriver, d.getUserID()) %>><%= d.getFullName() %></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="col-6">
                                <label>Giám thị</label>
                                <select name="monitorID" class="form-select" required>
                                    <option value="" disabled <%= checkDefault(errDir, "TO_HOME", errMonitor) %>>-- Chọn giám thị --</option>
                                    <% if(monitors != null) for(User m : monitors) { %>
                                        <option value="<%= m.getUserID() %>" <%= checkSelected(errDir, "TO_HOME", errMonitor, m.getUserID()) %>><%= m.getFullName() %></option>
                                    <% } %>
                                </select>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-success w-100 fw-bold"><i class="bi bi-floppy me-2"></i>Lưu ca Về nhà</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- Danh sách ca đã phân -->
        <div class="col-md-12">
            <div class="card shadow-sm">
                <div class="card-header bg-white">
                    <h5 class="mb-0">Danh sách Phân ca Ngày <%= selectedDate %></h5>
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
                                    <td class="fw-bold text-primary"><%= s.getDate() %></td>
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
                    <h5 class="mb-0">Danh sách Ca Kỹ thuật Ngày <%= selectedDate %></h5>
                </div>
                <div class="card-body p-0 table-responsive">
                    <table class="table table-hover table-striped mb-0 text-nowrap">
                        <thead class="table-light">
                            <tr>
                                <th>ID Ca</th>
                                <th>Ngày làm việc</th>
                                <th>Tên Kỹ thuật viên</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th>Hành động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if(techSchedules != null && !techSchedules.isEmpty()) { 
                                for(model.TechnicianSchedule ts : techSchedules) { 
                                    String statusBadge = "bg-warning text-dark";
                                    String statusText = "Chờ xử lý";
                                    if ("IN_PROGRESS".equals(ts.getStatus())) {
                                        statusBadge = "bg-primary";
                                        statusText = "Đang thực hiện";
                                    } else if ("COMPLETED".equals(ts.getStatus())) {
                                        statusBadge = "bg-success";
                                        statusText = "Hoàn tất";
                                    }
                            %>
                                <tr>
                                    <td>#<%= ts.getTechScheduleID() %></td>
                                    <td class="fw-bold text-primary"><%= ts.getDate() %></td>
                                    <td><%= ts.getTechnicianName() %></td>
                                    <td><span class="badge <%= statusBadge %>"><%= statusText %></span></td>
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
