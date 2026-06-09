<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.User"%>
<%
    User user = (User) request.getAttribute("user");
    boolean isUpdate = (user != null);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%= isUpdate ? "Cập nhật" : "Thêm mới" %> Tài khoản / Nhân viên</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card shadow">
                        <div class="card-header bg-primary text-white">
                            <h4 class="mb-0"><%= isUpdate ? "Cập nhật tài khoản" : "Thêm tài khoản mới" %></h4>
                        </div>
                        <div class="card-body">
                            <form action="<%= isUpdate ? "user-edit" : "user-add" %>" method="POST">
                                <% if (isUpdate) { %>
                                    <input type="hidden" name="userID" value="<%= user.getUserID() %>">
                                <% } %>
                                
                                <div class="mb-3">
                                    <label class="form-label">Tên đăng nhập</label>
                                    <input type="text" class="form-control" name="username" value="<%= isUpdate ? user.getUsername() : "" %>" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Mật khẩu</label>
                                    <input type="text" class="form-control" name="password" value="<%= isUpdate ? user.getPassword() : "123" %>" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Họ và tên</label>
                                    <input type="text" class="form-control" name="fullName" value="<%= isUpdate && user.getFullName() != null ? user.getFullName() : "" %>" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Vai trò</label>
                                    <select class="form-select" name="role" required>
                                        <option value="ADMIN" <%= isUpdate && "ADMIN".equals(user.getRole()) ? "selected" : "" %>>ADMIN - Quản trị viên</option>
                                        <option value="DRIVER" <%= isUpdate && "DRIVER".equals(user.getRole()) ? "selected" : "" %>>DRIVER - Tài xế</option>
                                        <option value="MONITOR" <%= isUpdate && "MONITOR".equals(user.getRole()) ? "selected" : "" %>>MONITOR - Giám sát</option>
                                        <option value="PARENT" <%= isUpdate && "PARENT".equals(user.getRole()) ? "selected" : "" %>>PARENT - Phụ huynh</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Số điện thoại</label>
                                    <input type="text" class="form-control" name="phone" value="<%= isUpdate && user.getPhone() != null ? user.getPhone() : "" %>">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Email</label>
                                    <input type="email" class="form-control" name="email" value="<%= isUpdate && user.getEmail() != null ? user.getEmail() : "" %>">
                                </div>
                                <div class="d-flex justify-content-between">
                                    <a href="user-list" class="btn btn-secondary">Quay lại</a>
                                    <button type="submit" class="btn btn-success">Lưu lại</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
