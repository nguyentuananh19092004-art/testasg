<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - Hệ thống School Bus</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #e0c3fc 0%, #8ec5fc 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }
        .login-wrapper {
            width: 100%;
            max-width: 1100px;
            display: flex;
            flex-direction: row;
            align-items: center;
            justify-content: space-between;
            padding: 20px;
        }
        .bus-illustration {
            flex: 1.2;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 20px;
            text-align: center;
        }
        @keyframes floatingBus {
            0% { transform: translateY(0); }
            50% { transform: translateY(-15px); }
            100% { transform: translateY(0); }
        }
        .bus-image {
            max-width: 90%;
            height: auto;
            animation: floatingBus 3s ease-in-out infinite;
            filter: drop-shadow(0 20px 20px rgba(0,0,0,0.15));
            /* Giúp xóa nền trắng nếu file ảnh chưa trong suốt hoàn toàn */
            mix-blend-mode: multiply; 
        }
        .illustration-text {
            color: #2c3e50;
            margin-top: 30px;
        }
        .illustration-text h1 {
            font-weight: 800;
            font-size: 2.5rem;
        }
        
        .login-card {
            flex: 1;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 25px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            padding: 50px 40px;
            max-width: 450px;
            margin-left: auto;
        }
        .login-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .login-header h3 {
            font-weight: 700;
            color: #333;
            margin-bottom: 5px;
        }
        .login-header p {
            color: #6c757d;
            font-size: 0.95rem;
        }
        .role-selector {
            display: flex;
            gap: 10px;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }
        .role-option {
            flex: 1 1 calc(50% - 10px);
        }
        .role-option input[type="radio"] {
            display: none;
        }
        .role-option label {
            display: block;
            text-align: center;
            padding: 12px 10px;
            border: 2px solid #e9ecef;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 500;
            color: #6c757d;
            background: #fff;
        }
        .role-option input[type="radio"]:checked + label {
            border-color: #4a90e2;
            background: #f0f7ff;
            color: #4a90e2;
            box-shadow: 0 4px 15px rgba(74, 144, 226, 0.15);
        }
        .role-option label i {
            display: block;
            font-size: 1.5rem;
            margin-bottom: 5px;
        }
        .form-floating > .form-control:focus ~ label {
            color: #4a90e2;
        }
        .form-control:focus {
            border-color: #4a90e2;
            box-shadow: 0 0 0 0.25rem rgba(74, 144, 226, 0.25);
            border-radius: 10px;
        }
        .form-control {
            border-radius: 10px;
        }
        .btn-login {
            background: linear-gradient(135deg, #4a90e2, #007aff);
            border: none;
            color: white;
            padding: 15px;
            border-radius: 12px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            box-shadow: 0 5px 15px rgba(0, 122, 255, 0.3);
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 122, 255, 0.4);
            color: white;
        }
        .back-home {
            text-align: center;
            margin-top: 20px;
        }
        .back-home a {
            color: #6c757d;
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.3s;
        }
        .back-home a:hover {
            color: #4a90e2;
        }

        @media (max-width: 992px) {
            .login-wrapper {
                flex-direction: column;
                justify-content: center;
            }
            .bus-illustration {
                display: none; /* Ẩn hình ảnh trên mobile để tập trung vào form */
            }
            .login-card {
                margin: 0 auto;
                width: 100%;
            }
        }
    </style>
</head>
<body>

    <div class="login-wrapper">
        <!-- Khu vực hình ảnh bên trái -->
        <div class="bus-illustration">
            <img src="img/bus.png" alt="School Bus" class="bus-image">
            <div class="illustration-text">
                <h1>Hệ thống quản lý School Bus</h1>
                <p class="lead">Trường Marie Curie - An toàn, Tiện lợi, Chuyên nghiệp</p>
            </div>
        </div>

        <!-- Khu vực form đăng nhập bên phải -->
        <div class="login-card">
            <div class="login-header">
                <h3>Đăng Nhập</h3>
                <p>Chọn vai trò của bạn</p>
            </div>

            <form action="LoginServlet" method="POST">
                <!-- Role Selection -->
                <div class="role-selector">
                    <div class="role-option">
                        <input type="radio" name="role" id="role-admin" value="admin" checked>
                        <label for="role-admin">
                            <i class="bi bi-shield-lock"></i>
                            Admin
                        </label>
                    </div>
                    <div class="role-option">
                        <input type="radio" name="role" id="role-supervisor" value="giamthi">
                        <label for="role-supervisor">
                            <i class="bi bi-person-badge"></i>
                            Giám Thị
                        </label>
                    </div>
                    <div class="role-option">
                        <input type="radio" name="role" id="role-parent" value="phuhuynh">
                        <label for="role-parent">
                            <i class="bi bi-people"></i>
                            Phụ Huynh
                        </label>
                    </div>
                    <div class="role-option">
                        <input type="radio" name="role" id="role-driver" value="taixe">
                        <label for="role-driver">
                            <i class="bi bi-car-front"></i>
                            Tài Xế
                        </label>
                    </div>
                </div>

                <!-- Credentials -->
                <div class="form-floating mb-3">
                    <input type="text" class="form-control" id="username" name="username" placeholder="Tên đăng nhập" required>
                    <label for="username">Tên đăng nhập</label>
                </div>
                
                <div class="form-floating mb-4">
                    <input type="password" class="form-control" id="password" name="password" placeholder="Mật khẩu" required>
                    <label for="password">Mật khẩu</label>
                </div>

                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="rememberMe">
                        <label class="form-check-label text-muted" for="rememberMe">
                            Ghi nhớ tôi
                        </label>
                    </div>
                    <a href="#" class="text-decoration-none" style="color: #4a90e2; font-size: 0.9rem;">Quên mật khẩu?</a>
                </div>

                <button type="submit" class="btn btn-login w-100">Đăng Nhập</button>

                <div class="back-home">
                    <a href="index.jsp"><i class="bi bi-arrow-left me-1"></i> Trở về trang chủ</a>
                </div>
            </form>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
