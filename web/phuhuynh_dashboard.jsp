<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.*"%>
<%@page import="java.util.List"%>
<%
    if(session.getAttribute("userRole") == null || !"phuhuynh".equals(session.getAttribute("userRole"))) {
        response.sendRedirect("dang_nhap.jsp");
        return;
    }
    HocSinh student = (HocSinh) request.getAttribute("student");
    List<StopRouteOption> stopRouteOptions = (List<StopRouteOption>) request.getAttribute("stopRouteOptions");
    Stop currentStop = (Stop) request.getAttribute("currentStop");
    Schedule activeSchedule = (Schedule) request.getAttribute("activeSchedule");
    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
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
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
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
            <a class="navbar-brand fw-bold" href="parent-dashboard">
                <i class="bi bi-people-fill me-2"></i>Phụ Huynh Panel
            </a>
            <div class="d-flex align-items-center">
                <span class="text-light me-3"><i class="bi bi-person-circle me-1"></i> Xin chào, <b><%= session.getAttribute("username") %></b></span>
                <a href="dang_nhap.jsp" class="btn btn-sm btn-outline-light"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a>
            </div>
        </div>
    </nav>

    <div class="container my-5">
        <% if (student != null) { %>
        <h2 class="fw-bold mb-4">Thông tin của học sinh: <span class="text-primary"><%= student.getTenHocSinh() %> (Lớp <%= student.getLop() %>)</span></h2>
        
        <div class="row g-4 mb-4">
            <!-- Tình trạng học sinh -->
            <div class="col-md-6">
                <div class="card dashboard-card h-100 border-start border-warning border-5">
                    <div class="card-body">
                        <h5 class="fw-bold text-warning mb-3">Tình trạng học hôm nay</h5>
                        <% if ("Nghỉ".equals(student.getTrangThai())) { %>
                            <div class="alert alert-danger">
                                <i class="bi bi-info-circle-fill me-2"></i> Gia đình đã báo cho học sinh nghỉ ngày hôm nay.
                            </div>
                        <% } else if ("Ngưng hoạt động".equals(student.getTrangThai()) || student.getDefaultStopID() == null) { %>
                            <div class="alert alert-secondary">
                                <i class="bi bi-exclamation-circle-fill me-2 text-warning"></i> Trạng thái: <strong>Chưa kích hoạt</strong>. Vui lòng thiết lập Điểm đón và Khung giờ ở bên dưới để đăng ký sử dụng dịch vụ xe Bus.
                            </div>
                        <% } else { %>
                            <div class="alert alert-success">
                                <i class="bi bi-check-circle-fill me-2"></i> Trạng thái: Hoạt động. Xe đưa đón hoạt động từ ngày mai.
                            </div>
                            <form action="parent-action" method="POST" class="mt-3">
                                <input type="hidden" name="action" value="report_absent">
                                <p class="text-muted small">Nếu con nghỉ học hôm nay, vui lòng thông báo:</p>
                                <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Xác nhận báo cho học sinh nghỉ học ngày hôm nay?');"><i class="bi bi-x-circle me-1"></i> Báo vắng mặt hôm nay</button>
                            </form>
                        <% } %>
                    </div>
                </div>
            </div>
            
            <!-- Trạng thái xe -->
            <div class="col-md-6">
                <div class="card dashboard-card h-100 border-start border-success border-5">
                    <div class="card-body">
                        <h5 class="fw-bold text-success mb-3">Trạng thái xe đến điểm đón</h5>
                        <% if ("Nghỉ".equals(student.getTrangThai())) { %>
                            <p class="text-muted">Học sinh đã báo nghỉ, hệ thống không theo dõi xe cho ngày hôm nay.</p>
                        <% } else if (currentStop == null) { %>
                            <div class="alert alert-warning"><i class="bi bi-exclamation-triangle-fill me-2"></i> Chưa cấu hình điểm đón.</div>
                        <% } else { %>
                            <p class="mb-2"><i class="bi bi-geo-alt-fill text-danger me-2"></i> <strong>Điểm đón:</strong> <%= currentStop.getStopName() %></p>
                            <% if (activeSchedule != null) { %>
                                <div class="alert alert-info mt-3">
                                    <i class="bi bi-bus-front-fill me-2"></i> Xe tuyến <strong><%= activeSchedule.getRouteID() %></strong> đang trong quá trình di chuyển. Vui lòng chú ý điện thoại hoặc thông báo.
                                </div>
                            <% } else { %>
                                <div class="alert alert-secondary mt-3">
                                    <i class="bi bi-clock me-2"></i> Hiện không có chuyến xe nào hoạt động đi qua điểm đón này.
                                </div>
                            <% } %>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row g-4">
            <!-- Cài đặt điểm đón -->
            <div class="col-md-6">
                <div class="card dashboard-card h-100 border-start border-primary border-5">
                    <div class="card-body">
                        <h5 class="fw-bold text-primary mb-3">Thiết lập điểm đón cố định</h5>
                        <form action="parent-action" method="POST">
                            <input type="hidden" name="action" value="change_stop">
                            <div class="mb-3">
                                <label for="stopRoute" class="form-label">Chọn Điểm đón & Khung giờ (Tuyến):</label>
                                <select class="form-select" name="stopRoute" id="stopRoute" required>
                                    <option value="">-- Chọn điểm đón và giờ --</option>
                                    <% if (stopRouteOptions != null) {
                                        for (StopRouteOption sro : stopRouteOptions) { 
                                            String val = sro.getStopID() + "_" + sro.getRouteID();
                                            boolean isSelected = (student.getDefaultStopID() != null && student.getDefaultRouteID() != null && 
                                                                  student.getDefaultStopID() == sro.getStopID() && 
                                                                  student.getDefaultRouteID() == sro.getRouteID());
                                    %>
                                            <option value="<%= val %>" <%= isSelected ? "selected" : "" %>>
                                                <%= sro.getStopName() %> (Đón: <%= sro.getEstimatedTime().toString().substring(0,5) %>, Trả: <%= sro.getReturnTime() != null ? sro.getReturnTime().toString().substring(0,5) : "--" %>)
                                            </option>
                                    <%  } 
                                       } %>
                                </select>
                            </div>
                            
                            <div id="stopMap" style="height: 350px; border-radius: 8px; margin-bottom: 15px; border: 1px solid #dee2e6; z-index: 1;"></div>
                            <small class="text-muted d-block mb-3"><i class="bi bi-info-circle me-1"></i>Bạn có thể click vào các điểm trên bản đồ để chọn nhanh điểm đón.</small>
                            
                            <button type="submit" class="btn btn-primary btn-sm"><i class="bi bi-save"></i> Cập nhật điểm đón</button>
                        </form>
                    </div>
                </div>
            </div>
            
            <!-- Hộp thư thông báo -->
            <div class="col-md-6">
                <div class="card dashboard-card h-100 border-start border-info border-5">
                    <div class="card-body">
                        <h5 class="fw-bold text-info mb-3"><i class="bi bi-bell-fill me-2"></i>Hộp thư thông báo</h5>
                        <% if (notifications != null && !notifications.isEmpty()) { %>
                            <div class="list-group" style="max-height: 300px; overflow-y: auto;">
                                <% for (Notification n : notifications) { %>
                                    <div class="list-group-item list-group-item-action <%= !n.isRead() ? "list-group-item-light fw-bold border-info" : "" %>">
                                        <div class="d-flex w-100 justify-content-between">
                                            <p class="mb-1"><%= n.getMessage() %></p>
                                            <small class="text-muted"><%= n.getCreatedAt() %></small>
                                        </div>
                                        <% if (!n.isRead()) { %>
                                        <form action="parent-action" method="POST" class="text-end mt-1">
                                            <input type="hidden" name="action" value="mark_read">
                                            <input type="hidden" name="notifID" value="<%= n.getNotifID() %>">
                                            <button type="submit" class="btn btn-sm btn-link text-decoration-none p-0">Đánh dấu đã đọc</button>
                                        </form>
                                        <% } %>
                                    </div>
                                <% } %>
                            </div>
                        <% } else { %>
                            <p class="text-muted">Chưa có thông báo nào từ nhà trường.</p>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
        <% } else { %>
            <div class="alert alert-danger">Lỗi tải thông tin học sinh.</div>
        <% } %>
    </div>

    <!-- Leaflet JS -->
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
            var map = L.map('stopMap').setView([21.028511, 105.804817], 11); // Default Hanoi
            
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                maxZoom: 19,
                attribution: '© OpenStreetMap'
            }).addTo(map);

            var stops = [
                <% if (stopRouteOptions != null) {
                    for (int i = 0; i < stopRouteOptions.size(); i++) {
                        model.StopRouteOption sro = stopRouteOptions.get(i);
                        String val = sro.getStopID() + "_" + sro.getRouteID();
                        String estTime = sro.getEstimatedTime() != null ? sro.getEstimatedTime().toString().substring(0,5) : "--";
                        String retTime = sro.getReturnTime() != null ? sro.getReturnTime().toString().substring(0,5) : "--";
                %>
                {
                    lat: <%= sro.getLatitude() %>,
                    lng: <%= sro.getLongitude() %>,
                    val: '<%= val %>',
                    name: '<%= sro.getStopName().replace("'", "\\'") %>',
                    desc: 'Đón: <%= estTime %>, Trả: <%= retTime %>'
                }<%= (i < stopRouteOptions.size() - 1) ? "," : "" %>
                <%  }
                   } %>
            ];

            var bounds = [];
            stops.forEach(function(stop) {
                if (stop.lat && stop.lng) {
                    var marker = L.marker([stop.lat, stop.lng]).addTo(map);
                    bounds.push([stop.lat, stop.lng]);
                    
                    var popupContent = '<div class="text-center"><b>' + stop.name + '</b><br/>' + stop.desc + 
                                       '<br/><button type="button" class="btn btn-sm btn-primary mt-2 w-100" onclick="selectStop(\'' + stop.val + '\')">Chọn điểm này</button></div>';
                    marker.bindPopup(popupContent);
                    
                    // On click marker, select the option
                    marker.on('click', function() {
                        selectStop(stop.val);
                    });
                }
            });

            if (bounds.length > 0) {
                map.fitBounds(bounds, {padding: [20, 20]});
            }
        });

        function selectStop(val) {
            var select = document.getElementById('stopRoute');
            select.value = val;
            
            // Visual feedback
            select.classList.add('is-valid');
            setTimeout(function() {
                select.classList.remove('is-valid');
            }, 1500);
        }
    </script>
</body>
</html>
