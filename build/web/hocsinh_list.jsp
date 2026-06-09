<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
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
            <a href="hocsinh-add" class="btn btn-primary mb-3">Thêm học sinh</a>
            <table class="table table-bordered table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>Mã HS</th>
                        <th>Tên HS</th>
                        <th>Lớp</th>
                        <th>Tên TK</th>
                        <th>Mật khẩu</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${hocsinhList}" var="hs">
                        <tr>
                            <td>${hs.maHocSinh}</td>
                            <td>${hs.tenHocSinh}</td>
                            <td>${hs.lop}</td>
                            <td>${hs.tenTK}</td>
                            <td>${hs.matKhau}</td>
                            <td>${hs.trangThai}</td>
                            <td>
                                <a href="hocsinh-edit?id=${hs.maHocSinh}" class="btn btn-sm btn-warning">Sửa</a>
                                <a href="hocsinh-delete?id=${hs.maHocSinh}" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc chắn muốn xóa học sinh này?');">Xóa</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </body>
</html>
