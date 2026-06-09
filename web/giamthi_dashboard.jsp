<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("userRole") == null || !"giamthi".equals(session.getAttribute("userRole"))) {
        response.sendRedirect("dang_nhap.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giám Thị Dashboard - School Bus</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f4f6f9; }
        .navbar { background: linear-gradient(135deg, #1cc88a 0%, #13855c 100%); box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .dashboard-card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); transition: transform 0.3s ease; }
        .dashboard-card:hover { transform: translateY(-5px); }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark sticky-top py-3">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#">
                <i class="bi bi-person-badge-fill me-2"></i>Giám Thị Panel
            </a>
            <div class="d-flex align-items-center">
                <span class="text-light me-3"><i class="bi bi-person-circle me-1"></i> Xin chào, <b><%= session.getAttribute("username") %></b></span>
                <a href="dang_nhap.jsp" class="btn btn-sm btn-outline-light"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <h2 class="fw-bold mb-4">Nhiệm vụ hôm nay</h2>
        <div class="row g-4">
            <div class="col-md-6">
                <div class="card dashboard-card h-100 border-start border-success border-5">
                    <div class="card-body">
                        <h5 class="fw-bold text-success">Chuyến xe đang giám sát</h5>
                        <p class="text-muted mb-1"><i class="bi bi-bus-front me-2"></i> Xe 29E-111.11 (Tuyến LT1)</p>
                        <p class="text-muted"><i class="bi bi-clock me-2"></i> Giờ xuất phát: 06:40</p>
                        <button class="btn btn-success"><i class="bi bi-check2-square me-1"></i> Bắt đầu điểm danh</button>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card dashboard-card h-100 border-start border-warning border-5">
                    <div class="card-body">
                        <h5 class="fw-bold text-warning">Thông báo khẩn cấp</h5>
                        <p class="text-muted">Chưa có thông báo nào từ phụ huynh về việc học sinh nghỉ học ngày hôm nay.</p>
                        <button class="btn btn-outline-warning"><i class="bi bi-bell me-1"></i> Xem thông báo</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
