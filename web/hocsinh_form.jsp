<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.HocSinh"%>
<%
    HocSinh hs = (HocSinh) request.getAttribute("hs");
    boolean isUpdate = (hs != null);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title><%= isUpdate ? "Cập nhật" : "Thêm mới" %> Học sinh</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="container mt-4">
            <h2><%= isUpdate ? "Cập nhật Học sinh" : "Thêm mới Học sinh" %></h2>
            <form action="<%= isUpdate ? "hocsinh-edit" : "hocsinh-add" %>" method="POST">
                <div class="mb-3">
                    <label>Mã Học Sinh</label>
                    <input type="text" name="maHocSinh" value="<%= isUpdate ? hs.getMaHocSinh() : "" %>" class="form-control" <%= isUpdate ? "readonly" : "required" %>/>
                </div>
                <div class="mb-3">
                    <label>Tên Học Sinh</label>
                    <input type="text" name="tenHocSinh" value="<%= isUpdate ? hs.getTenHocSinh() : "" %>" class="form-control" required/>
                </div>
                <div class="mb-3">
                    <label>Lớp (1-5)</label>
                    <input type="number" name="lop" value="<%= isUpdate ? hs.getLop() : "" %>" class="form-control" min="1" max="5" required/>
                </div>
                <div class="mb-3">
                    <label>Tên Tài Khoản</label>
                    <input type="text" name="tenTK" value="<%= isUpdate ? hs.getTenTK() : "" %>" class="form-control" required/>
                </div>
                <div class="mb-3">
                    <label>Mật Khẩu</label>
                    <input type="text" name="matKhau" value="<%= isUpdate ? hs.getMatKhau() : "1" %>" class="form-control" required/>
                </div>
                <div class="mb-3">
                    <label>Trạng Thái</label>
                    <select name="trangThai" class="form-select">
                        <option value="Sử dụng" <%= isUpdate && "Sử dụng".equals(hs.getTrangThai()) ? "selected" : "" %>>Sử dụng</option>
                        <option value="Không sử dụng" <%= isUpdate && "Không sử dụng".equals(hs.getTrangThai()) ? "selected" : "" %>>Không sử dụng</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-success">Lưu</button>
                <a href="hocsinh-list" class="btn btn-secondary">Quay lại</a>
            </form>
        </div>
    </body>
</html>
