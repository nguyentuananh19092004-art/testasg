<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>${hs == null ? 'Thêm mới' : 'Cập nhật'} Học sinh</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-4">
            <h2>${hs == null ? 'Thêm mới Học sinh' : 'Cập nhật Học sinh'}</h2>
            <form action="${hs == null ? 'hocsinh-add' : 'hocsinh-edit'}" method="POST">
                <div class="mb-3">
                    <label>Mã Học Sinh</label>
                    <input type="text" name="maHocSinh" value="${hs.maHocSinh}" class="form-control" ${hs != null ? 'readonly' : 'required'}/>
                </div>
                <div class="mb-3">
                    <label>Tên Học Sinh</label>
                    <input type="text" name="tenHocSinh" value="${hs.tenHocSinh}" class="form-control" required/>
                </div>
                <div class="mb-3">
                    <label>Lớp (1-5)</label>
                    <input type="number" name="lop" value="${hs.lop}" class="form-control" min="1" max="5" required/>
                </div>
                <div class="mb-3">
                    <label>Tên Tài Khoản</label>
                    <input type="text" name="tenTK" value="${hs.tenTK}" class="form-control" required/>
                </div>
                <div class="mb-3">
                    <label>Mật Khẩu</label>
                    <input type="text" name="matKhau" value="${hs != null ? hs.matKhau : '1'}" class="form-control" required/>
                </div>
                <div class="mb-3">
                    <label>Trạng Thái</label>
                    <select name="trangThai" class="form-select">
                        <option value="Sử dụng" ${hs.trangThai == 'Sử dụng' ? 'selected' : ''}>Sử dụng</option>
                        <option value="Không sử dụng" ${hs.trangThai == 'Không sử dụng' ? 'selected' : ''}>Không sử dụng</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-success">Lưu</button>
                <a href="hocsinh-list" class="btn btn-secondary">Quay lại</a>
            </form>
        </div>
    </body>
</html>
