<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.User"%>
<%
    List<User> userList = (List<User>) request.getAttribute("userList");
    String role = (String) request.getAttribute("role");
    String title = "DRIVER".equals(role) ? "Quản lý Lái xe" : "Quản lý Giám sát";
    String icon = "DRIVER".equals(role) ? "bi-person-badge" : "bi-eye";
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title><%= title %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        body { background-color: #f8f9fa; }
        .card { border: none; border-radius: 12px; }
        .table th { background-color: #343a40; color: white; }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold"><i class="bi <%= icon %> text-primary me-2"></i><%= title %></h2>
            <div>
                <a href="user-create?role=<%= role %>" class="btn btn-success me-2"><i class="bi bi-plus-circle"></i> Thêm mới</a>
                <a href="AdminDashboardServlet" class="btn btn-outline-secondary"><i class="bi bi-arrow-left"></i> Về Dashboard</a>
            </div>
        </div>
        
        <div class="card shadow-sm">
            <div class="card-body p-0">
                <table class="table table-hover table-striped mb-0 text-center align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Tên TK</th>
                            <th>Họ và tên</th>
                            <th>SĐT</th>
                            <th>Trạng thái</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            if (userList != null && !userList.isEmpty()) {
                                for (User u : userList) {
                        %>
                            <tr>
                                <td><%= u.getUserID() %></td>
                                <td class="fw-bold"><%= u.getUsername() %></td>
                                <td><%= u.getFullName() %></td>
                                <td><%= u.getPhone() != null ? u.getPhone() : "" %></td>
                                <td>
                                    <% if ("Active".equalsIgnoreCase(u.getStatus()) || "Hoạt động".equalsIgnoreCase(u.getStatus())) { %>
                                        <span class="badge bg-success">Hoạt động</span>
                                    <% } else if ("Rest".equalsIgnoreCase(u.getStatus()) || "Nghỉ".equalsIgnoreCase(u.getStatus())) { %>
                                        <span class="badge bg-secondary">Nghỉ</span>
                                    <% } else { %>
                                        <span class="badge bg-info"><%= u.getStatus() != null ? u.getStatus() : "Active" %></span>
                                    <% } %>
                                </td>
                                <td>
                                    <a href="user-update?id=<%= u.getUserID() %>" class="btn btn-sm btn-primary"><i class="bi bi-pencil"></i> Sửa</a>
                                    <a href="user-delete?id=<%= u.getUserID() %>&role=<%= role %>" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa nhân sự này?');"><i class="bi bi-trash"></i> Xóa</a>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="6" class="text-center text-muted py-3">Không có dữ liệu trong hệ thống.</td>
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
