<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${user != null ? 'Cập nhật' : 'Thêm mới'} Tài khoản / Nhân viên</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-5">
            <div class="row justify-content-center">
                <div class="col-md-6">
                    <div class="card shadow">
                        <div class="card-header bg-primary text-white">
                            <h4 class="mb-0">${user != null ? 'Cập nhật tài khoản' : 'Thêm tài khoản mới'}</h4>
                        </div>
                        <div class="card-body">
                            <form action="${user != null ? 'user-edit' : 'user-add'}" method="POST">
                                <c:if test="${user != null}">
                                    <input type="hidden" name="userID" value="${user.userID}">
                                </c:if>
                                
                                <div class="mb-3">
                                    <label class="form-label">Tên đăng nhập</label>
                                    <input type="text" class="form-control" name="username" value="${user.username}" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Mật khẩu</label>
                                    <input type="text" class="form-control" name="password" value="${user != null ? user.password : '123'}" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Họ và tên</label>
                                    <input type="text" class="form-control" name="fullName" value="${user.fullName}" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Vai trò</label>
                                    <select class="form-select" name="role" required>
                                        <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>ADMIN - Quản trị viên</option>
                                        <option value="DRIVER" ${user.role == 'DRIVER' ? 'selected' : ''}>DRIVER - Tài xế</option>
                                        <option value="MONITOR" ${user.role == 'MONITOR' ? 'selected' : ''}>MONITOR - Giám sát</option>
                                        <option value="PARENT" ${user.role == 'PARENT' ? 'selected' : ''}>PARENT - Phụ huynh</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Số điện thoại</label>
                                    <input type="text" class="form-control" name="phone" value="${user.phone}">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Email</label>
                                    <input type="email" class="form-control" name="email" value="${user.email}">
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
