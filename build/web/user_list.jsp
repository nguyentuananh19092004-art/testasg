<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.User"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Quản lý Nhân viên / Tài khoản</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4">
            <div class="container">
                <a class="navbar-brand" href="AdminDashboardServlet"><i class="bi bi-shield-lock-fill me-2"></i>Admin Dashboard</a>
            </div>
        </nav>

        <div class="container mt-4">
            <h2 class="mb-4">Danh sách Nhân viên / Tài khoản</h2>
            <a href="user-add" class="btn btn-primary mb-3"><i class="bi bi-person-plus-fill"></i> Thêm tài khoản mới</a>
            <div class="table-responsive">
                <table class="table table-bordered table-hover align-middle">
                    <thead class="table-dark">
                        <tr>
                            <th>ID</th>
                            <th>Tên đăng nhập</th>
                            <th>Họ và tên</th>
                            <th>Vai trò (Role)</th>
                            <th>Số điện thoại</th>
                            <th>Email</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<User> userList = (List<User>) request.getAttribute("userList");
                            if (userList != null) {
                                for (User u : userList) {
                        %>
                            <tr>
                                <td><%= u.getUserID() %></td>
                                <td><%= u.getUsername() %></td>
                                <td><%= u.getFullName() %></td>
                                <td>
                                    <% if ("ADMIN".equals(u.getRole())) { %>
                                        <span class="badge bg-danger">ADMIN</span>
                                    <% } else if ("DRIVER".equals(u.getRole())) { %>
                                        <span class="badge bg-success">TÀI XẾ</span>
                                    <% } else if ("MONITOR".equals(u.getRole())) { %>
                                        <span class="badge bg-info text-dark">GIÁM SÁT</span>
                                    <% } else if ("PARENT".equals(u.getRole())) { %>
                                        <span class="badge bg-warning text-dark">PHỤ HUYNH</span>
                                    <% } else { %>
                                        <span class="badge bg-secondary"><%= u.getRole() %></span>
                                    <% } %>
                                </td>
                                <td><%= u.getPhone() != null ? u.getPhone() : "" %></td>
                                <td><%= u.getEmail() != null ? u.getEmail() : "" %></td>
                                <td>
                                    <a href="user-edit?id=<%= u.getUserID() %>" class="btn btn-sm btn-warning"><i class="bi bi-pencil-square"></i> Sửa</a>
                                    <a href="user-delete?id=<%= u.getUserID() %>" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa tài khoản này?');"><i class="bi bi-trash"></i> Xóa</a>
                                </td>
                            </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
