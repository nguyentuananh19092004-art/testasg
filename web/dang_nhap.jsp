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
            background: linear-gradient(135deg, #f6d365 0%, #fda085 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }
        .login-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.2);
            overflow: hidden;
            width: 100%;
            max-width: 900px;
            display: flex;
            flex-direction: row;
        }
        .login-image {
            flex: 1;
            background: url('img/home_bus.png') center center/cover no-repeat;
            position: relative;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding: 40px;
            color: white;
            text-shadow: 1px 1px 4px rgba(0,0,0,0.6);
        }
        .login-image::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: rgba(0,0,0,0.4);
            z-index: 1;
        }
        .login-image-content {
            position: relative;
            z-index: 2;
        }
        .login-form-container {
            flex: 1;
            padding: 50px 40px;
            background: white;
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
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 500;
            color: #6c757d;
        }
        .role-option input[type="radio"]:checked + label {
            border-color: #ff9800;
            background: #fff3e0;
            color: #ff9800;
            box-shadow: 0 4px 10px rgba(255, 152, 0, 0.2);
        }
        .role-option label i {
            display: block;
            font-size: 1.5rem;
            margin-bottom: 5px;
        }
        .form-floating > .form-control:focus ~ label {
            color: #ff9800;
        }
        .form-control:focus {
            border-color: #ff9800;
            box-shadow: 0 0 0 0.25rem rgba(255, 152, 0, 0.25);
        }
        .btn-login {
            background: linear-gradient(135deg, #ff9800, #ff5722);
            border: none;
            color: white;
            padding: 15px;
            border-radius: 10px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(255, 87, 34, 0.3);
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
            color: #ff9800;
        }

        @media (max-width: 768px) {
            .login-card {
                flex-direction: column;
                margin: 20px;
            }
            .login-image {
                padding: 30px;
                min-height: 200px;
            }
            .role-option label i {
                font-size: 1.2rem;
            }
            .role-option label {
                padding: 8px;
                font-size: 0.9rem;
            }
        }
    </style>
</head>
<body>

    <div class="login-card">
        <!-- Image Side -->
        <div class="login-image">
            <div class="login-image-content">
                <h2 class="fw-bold mb-3">Chào mừng trở lại!</h2>
                <p class="mb-0">Hệ thống quản lý School Bus trường Marie Curie. Vui lòng đăng nhập để tiếp tục.</p>
            </div>
        </div>

        <!-- Form Side -->
        <div class="login-form-container">
            <div class="text-center mb-4">
                <h3 class="fw-bold" style="color: #333;">Đăng Nhập</h3>
                <p class="text-muted">Chọn vai trò của bạn</p>
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
                    <a href="#" class="text-decoration-none" style="color: #ff9800; font-size: 0.9rem;">Quên mật khẩu?</a>
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
