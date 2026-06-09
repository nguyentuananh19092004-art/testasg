<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("userRole") == null || !"phuhuynh".equals(session.getAttribute("userRole"))) {
        response.sendRedirect("dang_nhap.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phụ Huynh Dashboard - School Bus</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f4f6f9; }
        .navbar { background: linear-gradient(135deg, #f6c23e 0%, #dda20a 100%); box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .dashboard-card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); transition: transform 0.3s ease; }
        .dashboard-card:hover { transform: translateY(-5px); }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark sticky-top py-3">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#">
                <i class="bi bi-people-fill me-2"></i>Phụ Huynh Panel
            </a>
            <div class="d-flex align-items-center">
                <span class="text-light me-3"><i class="bi bi-person-circle me-1"></i> Xin chào, <b><%= session.getAttribute("username") %></b></span>
                <a href="dang_nhap.jsp" class="btn btn-sm btn-outline-light"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <h2 class="fw-bold mb-4">Thông tin của con</h2>
        <div class="row g-4">
            <div class="col-md-6">
                <div class="card dashboard-card h-100 border-start border-warning border-5">
                    <div class="card-body">
                        <h5 class="fw-bold text-warning">Trạng thái hiện tại</h5>
                        <div class="alert alert-success mt-3">
                            <i class="bi bi-check-circle-fill me-2"></i> Con đã lên xe an toàn lúc 06:45 AM.
                        </div>
                        <p class="text-muted"><i class="bi bi-geo-alt-fill me-2"></i> Điểm đón: S2.15 (Ocean Park)</p>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="card dashboard-card h-100 border-start border-danger border-5">
                    <div class="card-body">
                        <h5 class="fw-bold text-danger">Báo nghỉ học / Không đi xe</h5>
                        <p class="text-muted">Nếu hôm nay con nghỉ học hoặc phụ huynh tự đưa đón, vui lòng thông báo trước cho nhà trường.</p>
                        <button class="btn btn-danger"><i class="bi bi-x-circle me-1"></i> Báo vắng mặt hôm nay</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
