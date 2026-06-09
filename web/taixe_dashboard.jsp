<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if(session.getAttribute("userRole") == null || !"taixe".equals(session.getAttribute("userRole"))) {
        response.sendRedirect("dang_nhap.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tài Xế Dashboard - School Bus</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f4f6f9; }
        .navbar { background: linear-gradient(135deg, #e74a3b 0%, #be2617 100%); box-shadow: 0 4px 12px rgba(0,0,0,0.1); }
        .dashboard-card { border: none; border-radius: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.05); transition: transform 0.3s ease; }
        .dashboard-card:hover { transform: translateY(-5px); }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-dark sticky-top py-3">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#">
                <i class="bi bi-car-front-fill me-2"></i>Tài Xế Panel
            </a>
            <div class="d-flex align-items-center">
                <span class="text-light me-3"><i class="bi bi-person-circle me-1"></i> Xin chào, <b><%= session.getAttribute("username") %></b></span>
                <a href="dang_nhap.jsp" class="btn btn-sm btn-outline-light"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <h2 class="fw-bold mb-4">Lịch trình lái xe</h2>
        <div class="row g-4">
            <div class="col-md-12">
                <div class="card dashboard-card border-start border-danger border-5">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h5 class="fw-bold text-danger">Tuyến LT1: Ocean Park -> Trường học</h5>
                                <p class="text-muted mb-0"><i class="bi bi-clock me-2"></i> Bắt đầu lúc: 06:40 AM</p>
                            </div>
                            <button class="btn btn-danger btn-lg"><i class="bi bi-geo-alt-fill me-2"></i> Bắt đầu chuyến đi</button>
                        </div>
                        <hr>
                        <div class="mt-3">
                            <h6 class="fw-bold mb-3">Danh sách điểm dừng:</h6>
                            <ul class="list-group list-group-flush">
                                <li class="list-group-item"><i class="bi bi-1-circle-fill text-primary me-2"></i> S2.15 (Ocean Park) - 06:40</li>
                                <li class="list-group-item"><i class="bi bi-2-circle-fill text-primary me-2"></i> S1.08 (Ocean Park) - 06:50</li>
                                <li class="list-group-item"><i class="bi bi-3-circle-fill text-primary me-2"></i> The Zen Gamuda - 07:10</li>
                                <li class="list-group-item"><i class="bi bi-4-circle-fill text-primary me-2"></i> LandMark 72 - 07:40</li>
                                <li class="list-group-item"><i class="bi bi-flag-fill text-success me-2"></i> Trường Marie Curie - 08:00</li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
