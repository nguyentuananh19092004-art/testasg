<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    // Kiểm tra đăng nhập
    if(session.getAttribute("userRole") == null || !"admin".equals(session.getAttribute("userRole"))) {
        response.sendRedirect("dang_nhap.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - School Bus</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f4f6f9;
        }
        .navbar {
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        .dashboard-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            transition: transform 0.3s ease;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        .icon-box {
            width: 60px; height: 60px;
            border-radius: 15px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.8rem; color: white;
        }
        .bg-gradient-primary { background: linear-gradient(135deg, #4e73df 0%, #224abe 100%); }
        .bg-gradient-success { background: linear-gradient(135deg, #1cc88a 0%, #13855c 100%); }
        .bg-gradient-warning { background: linear-gradient(135deg, #f6c23e 0%, #dda20a 100%); }
        .bg-gradient-danger { background: linear-gradient(135deg, #e74a3b 0%, #be2617 100%); }
    </style>
</head>
<body>

    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark sticky-top py-3">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#">
                <i class="bi bi-shield-lock-fill me-2"></i>Admin Panel
            </a>
            <div class="d-flex align-items-center">
                <span class="text-light me-3"><i class="bi bi-person-circle me-1"></i> Xin chào, <b><%= session.getAttribute("username") %></b></span>
                <a href="dang_nhap.jsp" class="btn btn-sm btn-outline-light"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container my-5">
        <h2 class="fw-bold mb-4">Tổng quan hệ thống</h2>
        <div class="row g-4">
            <!-- Card 1 -->
            <div class="col-md-3">
                <div class="card dashboard-card h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted fw-bold mb-1">TỔNG SỐ HỌC SINH</h6>
                                <h3 class="fw-bold mb-0 text-dark"><%= request.getAttribute("totalStudents") != null ? request.getAttribute("totalStudents") : 0 %></h3>
                            </div>
                            <div class="icon-box bg-gradient-primary shadow-sm">
                                <i class="bi bi-people-fill"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Card 2 -->
            <div class="col-md-3">
                <div class="card dashboard-card h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted fw-bold mb-1">SỐ LƯỢNG XE BUS</h6>
                                <h3 class="fw-bold mb-0 text-dark"><%= request.getAttribute("totalBuses") != null ? request.getAttribute("totalBuses") : 0 %></h3>
                            </div>
                            <div class="icon-box bg-gradient-success shadow-sm">
                                <i class="bi bi-bus-front"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Card 3 -->
            <div class="col-md-3">
                <div class="card dashboard-card h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted fw-bold mb-1">TUYẾN ĐƯỜNG</h6>
                                <h3 class="fw-bold mb-0 text-dark"><%= request.getAttribute("totalRoutes") != null ? request.getAttribute("totalRoutes") : 0 %></h3>
                            </div>
                            <div class="icon-box bg-gradient-warning shadow-sm">
                                <i class="bi bi-map-fill"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Card 4 -->
            <div class="col-md-3">
                <div class="card dashboard-card h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h6 class="text-muted fw-bold mb-1">TÀI KHOẢN</h6>
                                <h3 class="fw-bold mb-0 text-dark"><%= request.getAttribute("totalUsers") != null ? request.getAttribute("totalUsers") : 0 %></h3>
                            </div>
                            <div class="icon-box bg-gradient-danger shadow-sm">
                                <i class="bi bi-person-badge-fill"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-5">
            <div class="col-12">
                <div class="card dashboard-card">
                    <div class="card-header bg-white border-0 pt-4 pb-0">
                        <h5 class="fw-bold"><i class="bi bi-gear-fill me-2 text-primary"></i>Quản lý nhanh</h5>
                    </div>
                    <div class="card-body">
                        <a href="hocsinh-list" class="btn btn-outline-primary me-2"><i class="bi bi-person-lines-fill me-1"></i> Quản lý Học Sinh</a>
                        <a href="ScheduleServlet" class="btn btn-outline-success me-2"><i class="bi bi-calendar-check me-1"></i> Phân ca & Lịch trình</a>
                        <a href="bus-list" class="btn btn-outline-warning me-2"><i class="bi bi-bus-front me-1"></i> Quản lý Xe Bus</a>
                        <a href="user-list?role=DRIVER" class="btn btn-outline-info me-2"><i class="bi bi-person-vcard me-1"></i> Quản lý Lái xe</a>
                        <a href="user-list?role=MONITOR" class="btn btn-outline-dark"><i class="bi bi-eye-fill me-1"></i> Quản lý Giám sát</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
