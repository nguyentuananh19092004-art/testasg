<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Bus"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách Xe Bus</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold"><i class="bi bi-bus-front text-warning me-2"></i>Danh sách Xe Bus</h2>
            <div>
                <a href="bus-create" class="btn btn-success me-2"><i class="bi bi-plus-circle"></i> Thêm Xe Bus</a>
                <a href="AdminDashboardServlet" class="btn btn-outline-secondary"><i class="bi bi-arrow-left"></i> Về Dashboard</a>
            </div>
        </div>
        
        <div class="card shadow-sm">
            <div class="card-body p-0">
                <table class="table table-hover table-striped mb-0 text-center align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>ID Xe</th>
                            <th>Biển số xe</th>
                            <th>Sức chứa (Ghế)</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Bus> busList = (List<Bus>) request.getAttribute("busList");
                            if (busList != null && !busList.isEmpty()) {
                                for (Bus b : busList) {
                        %>
                            <tr>
                                <td><%= b.getBusID() %></td>
                                <td class="fw-bold"><%= b.getLicensePlate() %></td>
                                <td><%= b.getCapacity() %></td>
                                <td>
                                    <% if ("Hoạt động".equalsIgnoreCase(b.getStatus()) || "Active".equalsIgnoreCase(b.getStatus())) { %>
                                        <span class="badge bg-success">Hoạt động</span>
                                    <% } else if ("Sửa chữa".equalsIgnoreCase(b.getStatus()) || "Maintenance".equalsIgnoreCase(b.getStatus())) { %>
                                        <span class="badge bg-danger">Sửa chữa</span>
                                    <% } else if ("Nghỉ".equalsIgnoreCase(b.getStatus()) || "Rest".equalsIgnoreCase(b.getStatus())) { %>
                                        <span class="badge bg-secondary">Nghỉ</span>
                                    <% } else { %>
                                        <span class="badge bg-info"><%= b.getStatus() %></span>
                                    <% } %>
                                </td>
                                <td>
                                    <a href="bus-update?id=<%= b.getBusID() %>" class="btn btn-sm btn-primary"><i class="bi bi-pencil"></i> Sửa</a>
                                    <a href="bus-delete?id=<%= b.getBusID() %>" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa xe này?');"><i class="bi bi-trash"></i> Xóa</a>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="5" class="text-center text-muted py-3">Không có xe bus nào trong hệ thống.</td>
                            </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>
