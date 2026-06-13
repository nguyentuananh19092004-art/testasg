<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="model.HocSinh"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Danh sách Học sinh</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-4">
            <h2>Danh sách Học Sinh</h2>
            <div class="d-flex justify-content-between align-items-center mb-3">
                <a href="hocsinh-add" class="btn btn-primary">Thêm học sinh</a>
                <a href="AdminDashboardServlet" class="btn btn-outline-secondary">Về Dashboard</a>
            </div>
            <% if ("stopped".equals(request.getParameter("msg"))) { %>
                <div class="alert alert-warning alert-dismissible fade show">
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    <i class="bi bi-info-circle-fill me-2"></i><strong>Thông báo:</strong> Dịch vụ ngưng hoạt động từ ngày mai. Trạng thái học sinh đã chuyển về "Ngưng hoạt động".
                </div>
            <% } %>
            <table class="table table-bordered table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>Mã HS</th>
                        <th>Tên HS</th>
                        <th>Lớp</th>
                        <th>Tên TK</th>
                        <th>Mật khẩu</th>
                        <th>Trạng thái</th>
                        <th>Lộ trình</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                    <tbody>
                        <%
                            List<HocSinh> hocsinhList = (List<HocSinh>) request.getAttribute("hocsinhList");
                            Map<Integer, String> routeMap = (Map<Integer, String>) request.getAttribute("routeMap");
                            if (hocsinhList != null) {
                                for (HocSinh hs : hocsinhList) {
                        %>
                        <tr>
                            <td><%= hs.getMaHocSinh() %></td>
                            <td><%= hs.getTenHocSinh() %></td>
                            <td><%= hs.getLop() %></td>
                            <td><%= hs.getTenTK() %></td>
                            <td><%= hs.getMatKhau() %></td>
                            <td><%= hs.getTrangThai() %></td>
                            <td>
                                <% if (hs.getDefaultRouteID() != null && routeMap != null && routeMap.containsKey(hs.getDefaultRouteID())) { %>
                                    <%= routeMap.get(hs.getDefaultRouteID()) %>
                                <% } else { %>
                                    <span class="text-muted">Chưa có</span>
                                <% } %>
                            </td>
                            <td>
                                <a href="hocsinh-edit?id=<%= hs.getMaHocSinh() %>" class="btn btn-sm btn-warning">Sửa</a>
                                <a href="hocsinh-delete?id=<%= hs.getMaHocSinh() %>" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa học sinh này?');">Xóa</a>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
            </table>
        </div>
    </body>
</html>
